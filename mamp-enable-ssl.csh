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


set HTTPD_CONF = /Applications/MAMP/conf/apache/httpd.conf
set HTTPD_SSL_CONF_O = /Applications/MAMP/conf/apache/extra/httpd-ssl.conf
set HTTPD_SSL_CONF = /Applications/MAMP/conf/apache/httpd-ssl.conf

# Enable ssl setting
cp -p $HTTPD_CONF  ${HTTPD_CONF}.org

set H_TEMP = /tmp/$0:t.$$
sed 's|#Include /Applications/MAMP/conf/apache/extra/httpd-ssl.conf|Include /Applications/MAMP/conf/apache/httpd-ssl.conf $HTTPD_CONF|g' | sed 's|#LoadModule socache_shmcb_module modules/mod_socache_shmcb.so|LoadModule socache_shmcb_module modules/mod_socache_shmcb.so|g'  > $H_TEMP
cat $H_TEMP > $HTTPD_CONF
rm -f $H_TEMP

# Setting ssl
# Default is https://localhost

cp -p $HTTPD_SSL_CONF_O $HTTPD_SSL_CONF

set H_TEMP = /tmp/$0:t.$$
sed 's|/Applications/MAMP/Library/htdocs|/Applications/MAMP/htdocs|g' $HTTPD_SSL_CONF > $H_TEMP
sed 's|www.example.com|localhost|g' $H_TEMP > ${H_TEMP}-2
mv ${H_TEMP}-2 ${H_TEMP}
sed 's|/Applications/MAMP/Library/logs/error_log|/Applications/MAMP/logs/ssl_error_log|g' $H_TEMP > ${H_TEMP}-2
mv ${H_TEMP}-2 ${H_TEMP}
sed 's|/Applications/MAMP/Library/logs/access_log|/Applications/MAMP/logs/ssl_access_log|g' $H_TEMP > ${H_TEMP}-2  
mv ${H_TEMP}-2 ${H_TEMP}
sed 's|server.key|ssl/server_nopass.key|g' $H_TEMP > ${H_TEMP}-2  
mv ${H_TEMP}-2 ${H_TEMP}
sed 's|server.crt|ssl/server.crt|g' $H_TEMP > ${H_TEMP}-2  
mv ${H_TEMP}-2 ${H_TEMP}
sed 's|#SSLCACertificateFile "/Applications/MAMP/conf/apache/ssl.crt/ca-bundle.crt"|SSLCACertificateFile "/Applications/MAMP/conf/apache/ssl/ssl.crt"|g' $H_TEMP > ${H_TEMP}-2  
mv ${H_TEMP}-2 ${H_TEMP}
sed 's|SSLMutex  "file:/Applications/MAMP/Library/logs/ssl_mutex"|Mutex default|g' $H_TEMP > ${H_TEMP}-2
mv ${H_TEMP}-2 ${H_TEMP}

cat $H_TEMP  > $HTTPD_SSL_CONF
rm -f $H_TEMP

# Create Certification files.
# Reference: https://www.geotrust.co.jp/support/ssl/csr/apache_openssl_new.html
cd /Applications/MAMP/conf/apache

# Create CA and  openssl.cnf
if ( -d ssl ) then
  rm -rf ssl
endif

mkdir -p ssl
cd ssl

mkdir -p certs crl newcerts private
touch index.txt serial
echo "01" > serial
touch openssl.cnf
cat << EOF >> openssl.cnf
[ new_oids ]
tsa_policy1 = 1.2.3.4.1
tsa_policy2 = 1.2.3.4.5.6
tsa_policy3 = 1.2.3.4.5.7

[ ca ]
default_ca      = CA_default

[ CA_default ]
database        = ./index.txt
new_certs_dir   = .
certificate     = ssl.crt
serial          = ./serial
private_key     = ./private/ssl.key
default_days    = 365
default_crl_days= 30
default_md      = sha256
policy          = policy_anything
x509_extensions = usr_cert


[ policy_anything ]
countryName             = optional
stateOrProvinceName     = optional
localityName            = optional
organizationName        = optional
organizationalUnitName  = optional
commonName              = supplied
emailAddress            = optional

[ req ]
default_bits		= 2048
default_keyfile 	= server.crt
distinguished_name	= req_distinguished_name
attributes		= req_attributes
string_mask = utf8only
x509_extensions = v3_ca
req_extensions = v3_req

[ req_distinguished_name ]
countryName			= Country Name (2 letter code)
countryName_default		= JP
countryName_min			= 2
countryName_max			= 2
stateOrProvinceName		= State or Province Name (full name
stateOrProvinceName_default	= LOCAL
localityName			= Locality Name (eg, city)
localityName_default		= LOCAL
0.organizationName		= Organization Name (eg, company)
0.organizationName_default	= MAMP
organizationalUnitName		= Organizational Unit Name
organizationalUnitName_default	= MAMP
commonName			= Common Name (eg, YOUR name)
commonName_default		= localhost
commonName_max			= 64
emailAddress			= Email Address
emailAddress_max		= 64
[ req_attributes ]
challengePassword		= A challenge password
challengePassword_min		= 4
challengePassword_max		= 20
unstructuredName		= An optional company name
[ usr_cert ]
basicConstraints=CA:FALSE
extendedKeyUsage = serverAuth
nsComment			= "OpenSSL Generated Certificate"
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer:always
subjectAltName = @alt_names
[ v3_req ]
extendedKeyUsage = serverAuth
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[ alt_names ]
DNS.1 = localhost
[ v3_ca ]
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid:always,issuer
basicConstraints = CA:true
[ crl_ext ]
authorityKeyIdentifier=keyid:always
[ proxy_cert_ext ]
basicConstraints=CA:FALSE
nsComment			= "OpenSSL Generated Certificate"
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer
proxyCertInfo=critical,language:id-ppl-anyLanguage,pathlen:3,policy:foo
[ tsa ]
[ tsa_config1 ]
EOF


#$OPENSSL req -config openssl.cnf -new -x509 -newkey rsa:2048 -out ssl.crt -keyout private/ssl.key -days 3650 
$OPENSSL req -config openssl.cnf -new -x509 -newkey rsa:2048 -out ssl.crt -keyout private/ssl.key -days 365 -sha256
$OPENSSL req -config openssl.cnf -new -keyout server.key -out server.csr -sha256

$OPENSSL ca -config openssl.cnf  -out server.crt -infiles server.csr

$OPENSSL rsa -in server.key -out server_nopass.key
