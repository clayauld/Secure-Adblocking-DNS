#! /bin/bash
echo
echo "This script installs the required components to set up an Nginx tranparent proxy for DNS-over-TLS and Pi-Hole"
echo "PLEASE BE AWARE THIS WILL OVERWRITE YOUR CURRENT NGINX CONFIG!!"
echo "However, it will back up your old config in case you need to revert."
echo
curl -s https://raw.githubusercontent.com/clayauld/Secure-Adblocking-DNS/master/nginx/nginx.conf > /etc/nginx/ngxin.conf
mkdir /etc/nginx/streams
curl -s https://raw.githubusercontent.com/clayauld/Secure-Adblocking-DNS/master/nginx/streams/DoT_dns > /etc/nginx/streams/DoT_dns
systemctl restart nginx
curl -s https://raw.githubusercontent.com/clayauld/Secure-Adblocking-DNS/master/nginx/transparent-proxy.service > /lib/systemd/system/transparent-proxy.service
curl -s https://raw.githubusercontent.com/clayauld/Secure-Adblocking-DNS/master/nginx/transparent-proxy.sh > /usr/local/bin/transparent-proxy
sudo systemctl daemon-reload
sudo systemctl enable transparent-proxy.service
echo Finished!
echo