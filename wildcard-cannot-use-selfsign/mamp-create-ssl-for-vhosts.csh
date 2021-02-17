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
set wildcard = "$2"

if ( "$opt" == "" ) then
 echo "Please input the site domain name (ex. hogehoge.com)."
 exit 1
endif

# Create Certification files.
# Reference: https://www.geotrust.co.jp/support/ssl/csr/apache_openssl_new.html
cd /Applications/MAMP/conf/apache

if ( ! -d "ssl" ) then
  echo "Please create CA using mamp-enable-ssl.csh".
  exit
endif

cd ssl 

if ( ! -d "vhosts" ) then
 mkdir -p vhosts
endif

set openssl_temp = "/tmp/$$.openssl-temp.cnf"

if ( "$wildcard" == "--wildcard" ) then
  sed "s|localhost|*.$opt|g" openssl.cnf | sed "s|server.crt|wildcard.${opt}.crt|g"  > $openssl_temp

  set interCA_flag = ""
  if ( -d "interCA" ) then
    cd interCA
    set interCA_flag = "../"
  endif
  if ( -f "${interCA_flag}vhosts/wildcard.${opt}.key" ) then
   	set index_temp = "/tmp/$$.index"
   	egrep -v 'CN='*."${opt}"'$' index.txt > $index_temp
   	cat $index_temp > index.txt
   	rm -f $index_temp
  endif
  if ( $interCA_flag != "" ) then
    cd ..
  endif


# openssl.cnf （$openssl_temp）には、CA認証局（証明書認証）である ssl.crt | private/ssl.key 情報があり、このCA認証局で証明書を認証するため、オプションにはCA認証局関連は含まれていない。
# サーバー証明書要求（CSR）＋サーバー秘密鍵（KEY）の生成
  $OPENSSL req -config $openssl_temp -new -keyout vhosts/wildcard.${opt}.key -out vhosts/wildcard.${opt}.csr -sha256
# サーバー証明書（中間証明書で署名） / mamp-create-ssl-middle-certificate-file.csh で生成しておくこと
if ( -d "interCA" ) then
 cd interCA
  $OPENSSL ca -config $openssl_temp -md sha256 -in ../vhosts/wildcard.${opt}.csr  -out ../vhosts/wildcard.${opt}.crt -keyfile private/ssl.key -cert ssl.crt -batch -policy policy_anything 
cd .. 
else
  echo "Please create interCA using mamp-create-ssl-middle-certificate-file.csh".
  exit
endif
# サーバー証明書のパスワードを排除（Apache起動時にパスワード不要にする）
  $OPENSSL rsa -in vhosts/wildcard.${opt}.key -out vhosts/wildcard.${opt}_nopass.key

else
  sed "s|localhost|$opt|g" openssl.cnf | sed "s|server.crt|${opt}.crt|g"> $openssl_temp

  if ( -f "${opt}.key" ) then
	set index_temp = "/tmp/$$.index"
	egrep -v 'CN='"${opt}"'$' index.txt > $index_temp
	cat $index_temp > index.txt
	rm -f $index_temp
  endif

  $OPENSSL req -config $openssl_temp -new -keyout ${opt}.key -out ${opt}.csr -sha256
  $OPENSSL ca -config $openssl_temp  -out ${opt}.crt -infiles ${opt}.csr
  $OPENSSL rsa -in ${opt}.key -out ${opt}_nopass.key

endif

rm -f $openssl_temp 
