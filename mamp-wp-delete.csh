#!/bin/csh -f 

### START environments ###
### PLEASE check the following arguments for your MAMP ###
set wp_dbuser = "root"
set wp_dbpass = "root"
set wp_login_user="admin"
set wp_login_pass="admin"
set WP = '/usr/local/bin/wp'
### END environments ###

set wp_dbname = "$1"

set php_path = `ls -d /Applications/MAMP/bin/php/php* | head -1`
set path = (${php_path}/bin $path)

if ( "$wp_dbname" == "" ) then
 echo "Please input database name."
 exit
endif

set mamp_status = "`ps -ef| grep /Applications/MAMP/Library/bin/mysqld_safe | grep -v 'grep' `"
if ( "$mamp_status" == "" ) then
  echo "Please run MAMP and start servers, first."
  open -a MAMP
  exit
endif

set wp_path = "/Applications/MAMP/htdocs/$wp_dbname"

# Check for Update to WP CLI
# Check for Update to WP CLI
if ( ! -f  "$WP" ) then
echo "Downloading and Install WP-CLI command to /usr/local/bin/wp"
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar 
 if ( ! -d "/usr/local/bin" ) then
  sudo mkdir -p /usr/local/bin
 endif
sudo mv wp-cli.phar /usr/local/bin/wp
rehash
endif

$WP cli update --yes

# Check requirement commands
echo 'Remove the following site'
which php
echo "WordPress Path: $wp_path"
echo "WordPress User: $wp_login_user"
echo "WordPress Pass: $wp_login_pass"
echo "DB: $wp_dbname"
echo ''
echo -n 'Are you ready? [yes/no]: '
while(1)
  set check = $<
  if("$check" == "yes") then
     break
  endif
end

echo ''
echo 'Export  WordPress DB to ~/MAMP/htdocs/$wp_dbname.sql'
echo ''

cd  $wp_path
$WP db export ${wp_dbname}.sql
mv ${wp_dbname}.sql ../


echo ''
echo 'Deleting WordPress'
echo ''

$WP db drop --yes
rm -rf $wp_path


