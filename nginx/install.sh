#! /bin/bash
echo
echo "This script installs the transparent-proxy.service to systemd and transparent-proxy script to /usr/local/bin"
echo
curl -s https://raw.githubusercontent.com/clayauld/Secure-Adblocking-DNS/master/nginx/transparent-proxy.service > /lib/systemd/system/transparent-proxy.service
curl -s https://raw.githubusercontent.com/clayauld/Secure-Adblocking-DNS/master/nginx/transparent-proxy.sh > /usr/local/bin/transparent-proxy
sudo systemctl daemon-reload
sudo systemctl enable transparent-proxy.service
echo Finished!
echo