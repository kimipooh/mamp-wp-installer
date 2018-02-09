#!/bin/csh -f 

# Before install brew install openssl on HomeBrew
set openssl_brew = /usr/local/opt/openssl/bin/openssl
set openssl_local = /usr/local/bin/openssl

if ( -f $openssl_brew ) then
  set OPENSSL = $openssl_brew
else if ( -f $openssl_local ) then
  set OPENSSL = $openssl_local
else
 echo "Please install 'openssl' command using Homebrew or MacPots".
 exit
endif

set opt = "$1"

if ( "$opt" == "" ) then
 echo "Please input the site domain name (ex. hogehoge.com)."
 exit 1
endif

# Create Certification files.
# Reference: https://www.geotrust.co.jp/support/ssl/csr/apache_openssl_new.html
cd /Applications/MAMP/conf/apache

# Create CA and  openssl.cnf
if ( ! -d "ssl" ) then
  echo "Please create CA certification using mamp-enable-ssl.csh"
  exit
endif

cd ssl

if ( ! -d "vhosts" ) then
  mkdir -p vhosts
endif

set openssl_temp = "/tmp/$$.openssl-temp.cnf"
sed "s|localhost|$opt|g" openssl.cnf | sed "s|server.crt|${opt}.crt|g"> $openssl_temp

if ( -f "vhosts/${opt}.key" ) then
set index_temp = "/tmp/$$.index"
egrep -v 'CN='"${opt}"'$' index.txt > $index_temp
cat $index_temp > index.txt
rm -f $index_temp
endif

$OPENSSL req -config $openssl_temp -new -keyout vhosts/${opt}.key -out vhosts/${opt}.csr -sha256
$OPENSSL ca -config $openssl_temp  -out vhosts/${opt}.crt -infiles vhosts/${opt}.csr
$OPENSSL rsa -in vhosts/${opt}.key -out vhosts/${opt}_nopass.key

rm -f $openssl_temp 
