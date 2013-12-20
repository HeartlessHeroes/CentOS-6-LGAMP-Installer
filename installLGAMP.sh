#!/bin/bash

clear

echo 'Going to install the LGAMP stack on your machine, here we go...'
echo '------------------------'
read -p "MySQL Password: " mysqlPassword
read -p "Retype password: " mysqlPasswordRetype

echo '------------------------'
echo -p "Git username" gitUsername
echo -p "Git email" gitEmail

wget http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm -ivh epel-release*
yum repolist
rm -f epel-release*

yum install -y httpd php mysql mysql-server git phpmyadmin

chkconfig mysql-server on
chkconfig httpd on

/etc/init.d/mysqld restart

while [[ "$mysqlPassword" = "" && "$mysqlPassword" != "$mysqlPasswordRetype" ]]; do
  echo -n "Please enter the desired mysql root password: "
  stty -echo
  read -r mysqlPassword
  echo
  echo -n "Retype password: "
  read -r mysqlPasswordRetype
  stty echo
  echo
  if [ "$mysqlPassword" != "$mysqlPasswordRetype" ]; then
    echo "Passwords do not match!"
  fi
done

/usr/bin/mysqladmin -u root password $mysqlPassword

git config --global user.name=$gitUsername
git config --global user.email=$gitEmail

service httpd start
service mysqld start

clear
echo 'Okay.... Apache, PHP, MySQL and Git are installed and running.'
echo 'Please change 127.0.0.1 to your IP address in this file /etc/httpd/conf.d/phpMyAdmin.config'