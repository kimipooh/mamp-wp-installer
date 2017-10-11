#!/bin/csh -f 
# setting environments
set wp_dbname = "$1"
set wp_dbuser = "root"
set wp_dbpass = "root"

set WP = '/usr/local/bin/wp'

set path = (/Applications/MAMP/bin/php/php5.6.30/bin $path)

if ( "$wp_dbname" == "" ) then
 echo "Please input database name."
 exit
endif

set wp_url = "http://localhost:8888/$wp_dbname"
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

wp cli update --yes

# Check requirement commands
echo 'Remove the following site'
echo $wp_path
echo "DB: $wp_dbname"
echo $wp_url
echo ''
echo -n 'Are you ready? [yes/no]: '
while(1)
  set check = $<
  if("$check" == "yes") then
     break
  else
     echo "Exit process."
     exit
  endif
end

echo ''
echo 'Export  WordPress DB to ~/MAMP/htdocs/$wp_dbname.sql'
echo ''

cd  $wp_path
wp db export ${wp_dbname}.sql
mv ${wp_dbname}.sql ../


echo ''
echo 'Deleting WordPress'
echo ''

wp db drop --yes
rm -rf $wp_path


