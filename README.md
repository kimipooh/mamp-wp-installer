# mamp-wp-installer
This is the helpful shell script tools for installing or removing WordPress on MAMP by a command line for MacOS. If you want to use them, please install MAMP (https://www.mamp.info/en/),  first. I tested the tool on macOS 10.15. macOS 10.15 requires the additional rules regarding ExtendedKeyUsage (EKU) and the validity period less than 825 days. In detail, please see https://support.apple.com/en-us/HT210176 . Thus, I fixed mamp-enable-ssh.csh file.
 

これは MacOS用のMAMPにおいて、コマンドから WordPress の初期インストールや削除を手助けするツールです。そのため、MAMPがインストールされていなければ動作しません。また MacOS 10.15で動作検証しています。macOS 10.15 では、追加ルールとして「ExtendedKeyUsage (EKU)への対応」「証明書期日は 825日以下」にすることを求めています。詳細：https://support.apple.com/en-us/HT210176 。そのため、mamp-enable-ssl.csh の一部を書き換えました。

# How to install （インストール方法）

1. git clone https://github.com/kimipooh/mamp-wp-installer
2. cd mamp-wp-installer

Move to mamp-wp-install.csh and mamp-wp-delete.csh to a path directory, such as /usr/local/bin .

上記のように git コマンドでダウンロードするか、https://github.com/kimipooh/mamp-wp-installer よりダウンロードしてください。そしてその中にある、「mamp-wp-install.csh」「mamp-wp-delete.csh」をパスの通っている /usr/local/bin 等にコピーしてください。

# How to set an initial settings.（初期設定）

In case of mamp-wp-install-with-ssl.csh, mamp-wp-install.csh, and mamp-wp-delete.csh, please check from "START environments" to "END environments" in the tool.  At least, please check the e-mail address (Default is sample@example.com).
If you changed a host, such as localhost instead of localhost:8888 (default), please change "set wp_url" value.

「mamp-wp-install-with-ssl.csh」「mamp-wp-install.csh」「mamp-wp-delete.csh」の 「START environments」から 「END environments」の初期値をチェックしてください。少なくても「メールアドレス」はチェックしてください（デフォルトは、sample@example.com）。
MAMPのデフォルト URLは、 http://localhost:8888 ですが、 http://localhost などURLを変更した場合には、URLの初期値を変更しておいてください。

# How to use （利用方法）

## Installation a WordPress （WordPress のインストール）

mamp-wp-install.csh  demo ja

First argument is the database name on MAMP.
Second argument is the WordPress locale. If you set "en", the latest WordPress for English locale is installed. Default is "en".

Install the latest WordPress (locale:ja) to /Applications/MAMP/htdocs/demo/ folder and create "demo" database to the mysql on MAMP.

If /Applications/MAMP/htdocs/demo/ already exist, the installation process stops with the warning message.

If the WP-CLI command isn't installed, the tool tries to download the latest version and install it to /usr/local/bin/wp .

第１引数は、MAMP上のデータベース名になります。
第２引数は、インストールする WordPress のロケールです。もし「ja」を設定すれば、日本語版 WordPress がインストールされます。デフォルトは en です。<br />
WordPress の新バージョンがでた場合、英語版以外は存在しない可能性があります。

mamp-wp-install.csh  demo ja

の場合には、MAMPのデータベース名「demo」と /Applications/MAMP/htdocs/demo/ フォルダに 日本語版WordPress がインストールされます。

もし、/Applications/MAMP/htdocs/demo/ フォルダ がすでにあった場合には、警告メッセージとともに、処理が終了します。
もし、/usr/local/bin/wp に WP-CLI をインストールしていない場合には、自動的に最新の WP-CLI をダウンロードし、インストールします。

## Delete a WordPress （WordPress の削除）

mamp-wp-delete.csh  demo

1. Export the dump (sql) data of "demo" database to the mysql on MAMP to "/Applications/MAMP/htdocs/demo.sql". (If you don't need it, please remove it manually.) 
2. Delete "demo" database to the mysql on MAMP.
3. Delete /Applications/MAMP/htdocs/demo/ folder.

If the WP-CLI command isn't installed, the tool tries to download the latest version and install it to /usr/local/bin/wp .

1. MAMPの demo データベースを、 「/Applications/MAMP/htdocs/demo.sql」にエクスポート（バックアップ）します（あとで消して下さい）。
2. MAMP の demo データベースを削除します。
3. /Applications/MAMP/htdocs/demo/ フォルダを削除します。

もし、/usr/local/bin/wp に WP-CLI をインストールしていない場合には、自動的に最新の WP-CLI をダウンロードし、インストールします。

# Additional functions （追加機能）

## Enable SSL (https) on MAMP for macOS only (macOS 専用 - MAMP で SSLを有効にする）

Firstly, you need to change Apache port 8888 to 80 before you enable SSL on MAMP.
If you have already installed a WordPerss in MAMP, you need to migrate the WordPress URL (http://localhost:8888/*** to http://localhost/*** ). I don't explain it. 

最初に MAMPで SSLを利用したい場合には、MAMP設定で Apache port を 80 に変更する必要があります。もしすでに WordPress を MAMP上でインストールしていた場合には、URLが変更になりますので、引っ越しが必要です。その方法はここでは説明しません。

On Terminal app.

./mamp-enable-ssl.csh 

The Passphrase will be required at several times by this tool for creating the CA and SSL certification files.
Please input an unique password. And input Enter about a cetification information, such as "State or Province Name", "Locality Name", and so on, without any information. 

The tool will automatically create and enable /Applications/MAMP/conf/apache/httpd-ssl.conf file for the SSL settings. SSL certification files are in  /Applications/MAMP/conf/apache/ssl folder.

Then, open /Applications/MAMP/conf/apache/conf/ssl/ssl.crt file and add (install) to "Keychain Access". And open "Keychain Access" app in Application > Untilities folder. Search as "localhost" and open the added "localhost" certification file. And then, set "Always trusted" in the trusted section.

Run MAMP and open https://localhost . If "No protected" is displayed by a web browser, clear cookie and cache or open the guest mode (Chrome) or Private mode.

If you disable SSL on MAMP, please comment out httpd-ssl.conf (# Include /Applications/MAMP/conf/apache/httpd-ssl.conf) in /Applications/MAMP/conf/apache/httpd.conf.

日本語の利用方法については
https://kitaney-wordpress.blogspot.com/2017/10/mamp-ssl-macos-high-sierra.html
で詳しく説明しているので、そちらを御覧ください。

## How to use it with Virtual Host (Virtual Host を使うには)

Unfortunately, Firefox displays the warning even if inter-CA is importing to the certification file. 
Firstly, if you don't do mamp-enable-ssl.csh yet, do it.
Then,

残念ながら Firefox については自己証明書の場合、中間証明書をいれてもエラーが出てしまいます。<br />
もし、mamp-enable-ssl.csh を実行（MAMPのSSL化）をしていないなら、それを先にしてください。
あとは下記を参考にしてみてください。

mamp-create-ssl-for-vhosts.csh  domain/subdomain.

ex. 
mamp-create-ssl-for-vhosts.csh  example.com

SSLCertificateFile
/Applications/MAMP/conf/apache/ssl/vhosts/example.com.crt
SSLCertificateKeyFile
/Applications/MAMP/conf/apache/ssl/vhosts/example.com.key

Please add the following settings in /Applications/MAMP/conf/apache/httpd-ssl.conf

1. Add the following value before <VirtualHost>.
NameVirtualHost *:443

2. Add the Virtual Host setting.

<VirtualHost *:443>
     DocumentRoot "/Applications/MAMP/htdocs/example.com"
     ServerName example.com
     SSLEngine on
     SSLCertificateFile /Applications/MAMP/conf/apache/ssl/vhosts/example.com.crt
     SSLCertificateKeyFile /Applications/MAMP/conf/apache/ssl/vhosts/example.com_nopass.key
</VirtualHost>


## How to install a WordPress with SSL (https) on MAMP (MAMP で SSL対応の WordPress をインストールする方法）

Basically, you can use "mamp-wp-install.csh" by changing "set wp_url" value (to https://localhost/$wp_dataname).
I prepare mamp-wp-install-with-ssl.csh command.

mamp-wp-install-with-ssl.csh  demo 

# Version History

* 1.0 Release
* 1.1 Fixed README
* 1.2 Added some enviroment for some value.
* 1.3 Added some enviroment for some value.
* 1.4 MAMP 4.2.1 and macOS High Sierra (10.13) supported. Added some enviroment.
* 1.5 Added the tool for enabling SSL on MAMP (mamp-enable-ssl.csh)
* 1.6 Added the function for automatically setting up the php path from MAMP. Arranged the environments which a user can customize.
* 1.7 Added mamp-create-ssl-for-vhosts.csh tool for Virtual Host.
* 1.8 Change php path to latest version on MAMP.

# バージョン履歴

* 1.0 リリース
* 1.1 READMEの修正
* 1.2 いくつかの設定値を変数に変更
* 1.3 いくつかの設定値を変数に変更
* 1.4 MAMP 4.2.1 に対応。macOS High Sierra (10.13) で動作確認。環境設定項目を追加。
* 1.5 MAMPで SSLを利用できるようにするツールを追加（ mamp-enable-ssl.csh）。
* 1.6 MAMPでアクティブな php バージョンを自動検出しパスに追加する機能を追加。またユーザーが変更可能な環境設定を整理して見やすくした。
* 1.7 Virtual Host に対応したツール「mamp-create-ssl-for-vhosts.csh」の公開
* 1.8 php パスを一番古いバージョンから新しいバージョンへ変更（wpが php5.4 だとうまく動かなくなっていたので）