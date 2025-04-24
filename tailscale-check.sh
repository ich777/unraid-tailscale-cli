#!/bin/bash
#Send message to syslog to check for a new version
logger "tailscale-cli: Checking for new Tailscale version"

#Get/set variables
SETTINGS="$(cat /boot/config/plugins/tailscale-cli/settings.cfg)"

#Get latest and local version from Tailscale
TAILSCALE_VERSION="$(wget -qO- 'https://pkgs.tailscale.com/stable/?mode=json' | jq -r '.TarballsVersion')"
TAILSCALE_AVAIL_VERSION="$(ls -1 /boot/config/plugins/tailscale-cli/tailscale-package/ 2>/dev/null | cut -d '_' -f2 | sort -V | tail -1)"

if [ -z "${TAILSCALE_VERSION}" ]; then
  echo "tailscale-cli: ERROR: Can't get latest version from Tailscale"
  exit 1
fi

if [ "${TAILSCALE_VERSION}" != "${TAILSCALE_AVAIL_VERSION}" ]; then
  logger "tailscale-cli: Found new Tailscale version: ${TAILSCALE_VERSION}, downloading and installing..."
  if wget -q -nc -O /boot/config/plugins/tailscale-cli/tailscale-package/tailscale_${TAILSCALE_VERSION}_amd64.tgz "https://pkgs.tailscale.com/stable/tailscale_${TAILSCALE_VERSION}_amd64.tgz" ; then
    logger "tailscale-cli: Download from Tailscale version ${TAILSCALE_VERSION} successful"
  else
    logger "tailscale-cli: ERROR: Download from Tailscale version ${TAILSCALE_VERSION} failed"
    rm -rf /boot/config/plugins/tailscale-cli/tailscale-package/tailscale_${TAILSCALE_VERSION}_amd64.tgz
    exit 1
  fi
else
  logger "tailscale-cli: Tailscale version: ${TAILSCALE_AVAIL_VERSION} up-to-date"
  exit 0
fi

#Remove old Tailscale Packages
rm -f $(ls /boot/config/plugins/tailscale-cli/tailscale-package/tailscale_*.tgz 2>/dev/null | grep -v "${TAILSCALE_VERSION}")

#Install/Update Tailsale
if [ ! -z "$(pgrep --ns $$ tailscaled)" ]; then
  logger "tailscale-cli: Stopping Tailscale"
  tailscale down 2>/dev/null
  kill -SIGTERM $(pgrep --ns $$ tailscaled) 2>/dev/null
fi
tar -C /usr/local/sbin --strip-components=1 -xf /boot/config/plugins/tailscale-cli/tailscale-package/tailscale_${TAILSCALE_VERSION}_amd64.tgz tailscale_${TAILSCALE_VERSION}_amd64/tailscaled tailscale_${TAILSCALE_VERSION}_amd64/tailscale
logger "tailscale-cli: Installation from Tailscale version: ${TAILSCALE_VERSION} done"

#Start Tailscale if enabled
if [ "$(echo "${SETTINGS}" | grep "TAILSCALE_ENABLED=" | cut -d '=' -f2-)" == "true" ]; then
  TSD_PARAMS="$(echo "${SETTINGS}" | grep "TAILSCALED_params=" | cut -d '=' -f2-)"
  if [ ! -z "${TSD_PARAMS}" ]; then
    TSD_PARAMS=" ${TSD_PARAMS}"
  fi
  logger "tailscale-cli: Starting Tailscale"
  echo "/usr/local/sbin/tailscaled -statedir=/boot/config/plugins/tailscale-cli/state${TSD_PARAMS} >/dev/null 2>&1" | at now -M >/dev/null 2>&1
else
  logger "tailscale-cli: WARNING: Tailscale disabled"
fi