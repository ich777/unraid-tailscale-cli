# Unraid Tailscale CLI Plugin

This is just a plugin which installs Tailscale and runs it.  

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

The plugin will check on boot for new versions from Tailscale (a scheduled cron job once a day to check for updates is planed as a upcoming feature).