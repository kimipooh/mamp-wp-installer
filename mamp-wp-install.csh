#!/bin/csh -f 

### START environments ###
### PLEASE check the following arguments for your MAMP ###
set wp_dbuser = "root"
set wp_dbpass = "root"
set wp_db_host = "localhost:8889"
set wp_login_user="admin"
set wp_login_pass="admin"
set wp_login_email="sample@example.com"
set WP = '/usr/local/bin/wp'
set wp_base_url = "http://localhost:8888"
### END environments ###

set wp_dbname = "$1"
set lang = "$2"
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

set wp_url = "${wp_base_url}/$wp_dbname"
set wp_path = "/Applications/MAMP/htdocs/$wp_dbname"

if ( -d "$wp_path" ) then
 echo "$wp_path folder already exists."
 echo "Please check and remove $wp_path folder, first"
 exit
endif 

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
echo 'Please check the settings.'
echo 'Current path is '
which php
echo "WordPress Path: $wp_path"
echo "WordPress User: $wp_login_user"
echo "WordPress Pass: $wp_login_pass"
echo "WordPress User E-mail: $wp_login_email"
echo ""
echo "Language: $lang (empty value is English)"
echo ""
echo "DB Name: $wp_dbname"
echo "DB User: $wp_dbuser"
echo "DB Pass: $wp_dbpass"
echo "Site URL: $wp_url"
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
echo 'Installing WordPress'
echo ''

mkdir -p $wp_path
cd  $wp_path

# Download WordPress in Japanese.
if ($lang == "" || $lang == "en") then
  $WP core download 
else
  $WP core download --force --locale=$lang
endif

# Setting up wp-config.php
#cp wp-config-sample.php wp-config.php
$WP core config --dbname="$wp_dbname" --dbuser="$wp_dbuser" --dbpass="$wp_dbpass" --dbhost="$wp_db_host"
# Create DB
$WP db create

# Install WordPress 
$WP core install --url=$wp_url --title=sample --admin_user="$wp_login_user" --admin_password="$wp_login_pass" --admin_email="$wp_login_email" 

$WP plugin update --all
#$WP plugin activate wp-multibyte-patch

# Install Plugins
#$WP plugin install google-apps-login

# Create Administrator
#$WP user create admin --role=administrator  --user_pass=admin

# Update language files
$WP core language update

open $wp_url