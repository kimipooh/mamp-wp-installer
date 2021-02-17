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

cd /Applications/MAMP/conf/apache

# Create CA and  openssl.cnf
if ( ! -d "ssl" ) then
  echo "Please create CA using mamp-enable-ssl.csh."
  exit
endif

cd ssl

if ( ! -d "interCA" ) then
  mkdir -p interCA
  mkdir -p interCA/private
  mkdir -p interCA/newcerts
  touch interCA/index.txt interCA/serial
  echo "01" > interCA/serial
endif

cd interCA

 sed "s|localhost|interCA|g" ../openssl.cnf > openssl.cnf


$OPENSSL req -config openssl.cnf -new -newkey rsa:2048 -sha256 -keyout private/ssl.key -out ssl.csr 

cd ..

$OPENSSL ca -config openssl.cnf -md sha256 -in interCA/ssl.csr -keyfile private/ssl.key -out interCA/ssl.crt -days 3650 -extensions v3_ca -batch -policy policy_anything


