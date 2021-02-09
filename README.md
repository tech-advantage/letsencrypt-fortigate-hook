# letsencrypt-fortigate-hook
Post-hook to update Fortigate certificates list

## setup
* replace `ADMIN_INTERFACE_IP` with the IP address of your Fortigate, where HTTPS access is enabled
* replace `REST_API_TOKEN` with the API token you've created for the bot user
* copy the script to the `/etc/letsencrypt/renewal-hooks/post` directory and `chmod 0744` it. The IP address of the machine running the renewal should be authorized in the bot user declaration.
