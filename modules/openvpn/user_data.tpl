Content-Type: multipart/mixed; boundary="===============BOUNDARY=="
MIME-Version: 1.0


--===============BOUNDARY==
Content-Type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0

#cloud-config

public_hostname=${public_hostname}
admin_user=${admin_user}
admin_pw=${admin_pswd}
license=${license_key}
reroute_gw=${reroute_gw}
reroute_dns=${reroute_dns}



--===============BOUNDARY==
MIME-Version: 1.0
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash

echo "INSTALL PACKAGE DEPENDENCIES"
apt update -y
apt install -y unzip
apt install -y libwww-perl libdatetime-perl

# INSTALL CERTBOT
apt install certbot
sudo certbot certonly -d vpn.prod.infra.lacuna-tech.io

# INSTALL CLOUDWATCH MONITORING SCRIPTS
echo "INSTALL CLOUDWATCH MONITORING SCRIPTS"
echo "--> DOWNLOAD CLOUDWATCH MONITORING SCRIPTS"
curl "https://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.1.zip" -o "/root/CloudWatchMonitoringScripts-1.2.1.zip"
echo "--> UNZIP CLOUDWATCH MONITORING SCRIPTS"
unzip "/root/CloudWatchMonitoringScripts-1.2.1.zip" -d /root
rm "/root/CloudWatchMonitoringScripts-1.2.1.zip"
echo "--> SET CRONTAB ENTRY FOR INSTANCE DATA"
crontab -l | { cat; echo "* * * * * /root/aws-scripts-mon/mon-put-instance-data.pl --mem-util --auto-scaling=only --from-cron"; } | crontab -

# INSTALL AWS-CLI
echo "INSTALL AWS-CLI"
echo "--> DOWNLOAD AWSCLI-BUNDLE.zip"
curl -n "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "/root/awscli-bundle.zip"
echo "--> UNZIP AWSCLI-BUNDLE.zip"
unzip "/root/awscli-bundle.zip" -d /root
echo "--> INSTALL AWS BINARY"
/root/awscli-bundle/install -i /usr/local/aws -b /usr/bin/aws
rm "/root/awscli-bundle.zip"
rm -rf "/root/awscli-bundle"


set -e
set -u
set -o pipefail


DOMAIN="vpn.prod.infra.lacuna-tech.io"

if diff -q /etc/letsencrypt/live/$DOMAIN/cert.pem \
        /usr/local/openvpn_as/etc/web-ssl/server.crt; then
        echo "Cert does not need updating"
        exit 0
fi

cp -f -v /etc/letsencrypt/live/$DOMAIN/cert.pem \
        /usr/local/openvpn_as/etc/web-ssl/server.crt

cp -f -v /etc/letsencrypt/live/$DOMAIN/privkey.pem \
        /usr/local/openvpn_as/etc/web-ssl/server.key

cd /usr/local/openvpn_as/scripts

./sacli --key "cs.cert" \
        --value_file "/etc/letsencrypt/live/$DOMAIN/cert.pem" \
        ConfigPut

./sacli --key "cs.ca_bundle" \
        --value_file "/etc/letsencrypt/live/$DOMAIN/chain.pem" \
        ConfigPut

./sacli --key "cs.priv_key" \
        --value_file "/etc/letsencrypt/live/$DOMAIN/privkey.pem" \
        ConfigPut


echo "--> RESTART OPENVPN ACCESS SERVER TO SAVE AND APPLY CHANGES"

# RESTART OPENVPN ACCESS SERVER TO SAVE AND APPLY CONFIGURATION CHANGES
/usr/local/openvpn_as/scripts/sacli start
systemctl restart openvpnas

--===============BOUNDARY==
