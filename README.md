# Unraid Tailscale CLI Plugin

This is just a plugin which installs Tailscale and run it.  

## Installation

Navigate to Plugins -> Install Plugin, paste the following link into `Enter URL of remote plugin file or local plugin file` and click `Install`:
```
https://git.minenet.at/ich777/unraid-tailscale-cli/raw/branch/master/tailscale-cli.plg
```


## Registration

After installing the plugin you'll have to open a Unraid Terminal and login to your Tailnet with: `tailscale login` and follow the prompts to register your Server on your Tailnet.  
  
If you want to use another login server, like for instance if you are running Headscale, you have to run the command `tailscale login --login-server https://example.yourdomain.org` and follow the prompts to register your Server on your Tailnet.  


## Access Unraid WebUI

To be able to reach your Unraid WebUI you have to navigate to Setings -> Network Settings -> (Interface Extra), at `Include listening interfaces` add: `tailscale0` and click `Apply`


## Updates

The plugin will check on boot for new versions from Tailscale and scheduled on 5:30  

**Note:** _If you want to change the time from the scheduled update check edit the file: `/boot/config/plugins/tailscale-cli/tailscale.cron` with your preferred schedule, open up a Unraid Terminal and issue `update_cron` (you'll get no output from the command) to update the schedules._