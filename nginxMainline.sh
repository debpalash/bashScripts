#!/bin/sh
Echo " Install the prerequisites: "
sudo apt install curl gnupg2 ca-certificates lsb-release ubuntu-keyring

Echo " Import an official nginx signing key so apt could verify the packages authenticity. Fetch the key:"

curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
    | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
    
echo "Verify that the downloaded file contains the proper key:"
gpg --dry-run --quiet --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg

echo "If you would like to use mainline nginx packages, run the following command instead:"

echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
http://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list
echo "Set up repository pinning to prefer our packages over distribution-provided ones:"
echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
    | sudo tee /etc/apt/preferences.d/99nginx

echo " now installing nginx mainline..."
sudo apt update
sudo apt install nginx
