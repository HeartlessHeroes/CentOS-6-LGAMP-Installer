#!/bin/bash

clear

echo 'Going to install the GLAMP stack on your machine, here we go...'
echo '------------------------'
read -p "MySQL Password: " mysqlPassword
read -p "Retype password: " mysqlPasswordRetype

echo '------------------------'
echo -p "Git username" gitUsername
echo -p "Git email" gitEmail

yum install -y httpd php mysql mysql-server git

chkconfig mysql-server on
chkconfig httpd on
chkconfig add git

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
