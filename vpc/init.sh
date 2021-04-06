#!/bin/bash
sudo su
yum update
yum install httpd –y
service httpd start
chkconfig httpd on
cd /var/www/html || exit
echo "<html><h1>This is WebServer from private subnet</h1></html>" > index.html