# mamp-wp-installer
This is the helpful shell script tools for installing or removing WordPress on MAMP by a command line for MacOS. If you want to use them, please install MAMP (https://www.mamp.info/en/),  first. I tested the tool on MacOS 10.12.6.

これは MacOS用のMAMPにおいて、コマンドから WordPress の初期インストールや削除を手助けするツールです。そのため、MAMPがインストールされていなければ動作しません。また MacOS 10.12.6で動作検証しています。

# How to install （インストール方法）

git clone https://github.com/kimipooh/mamp-wp-installer
cd mamp-wp-installer

Move to mamp-wp-install.csh and mamp-wp-delete.csh to a path directory, such as /usr/local/bin .

上記のように git コマンドでダウンロードするか、https://github.com/kimipooh/mamp-wp-installer よりダウンロードしてください。そしてその中にある、「mamp-wp-install.csh」「mamp-wp-delete.csh」をパスの通っている /usr/local/bin 等にコピーしてください。

# How to set an initial settings.（初期設定）

Please check your MAMP php folder (/Applications/MAMP/bin/php/php[version]/bin). The default setting is for php5.6.30 on MAMP 4.0

Please change "set path" to your php path in mamp-wp-install.csh and mamp-wp-delete.csh.
set path = (/Applications/MAMP/bin/php/php5.6.30/bin $path)

If you change a host, such as localhost instead of localhost:8888 (default), please change "set wp_url" value in mamp-wp-install.csh and mamp-wp-delete.csh .

まずは、MAMPの phpフォルダをチェックしてください。
以下 /Applications は 「アプリケーション」フォルダを意味します。
/Applications/MAMP/bin/php/php[version]/bin

デフォルトは、 MAMA 4.0 に搭載されている php5.6.30 にセットしています。

もしこれが異なる場合には、「mamp-wp-install.csh」「mamp-wp-delete.csh」ファイルを開いて、
set path = (/Applications/MAMP/bin/php/php5.6.30/bin $path)
の箇所の php5.6.30 をお使いのバージョンに変更してください。

また、MAMPのデフォルト URLは、 http://localhost:8888 ですが、 http://localhost などURLを変更したい場合には、「mamp-wp-install.csh」「mamp-wp-delete.csh」ファイルを開いて、
「set wp_url」のURLを変更してください。

# How to use （利用方法）

## Installation a WordPress （WordPress のインストール）

mamp-wp-install.csh  demo ja

First argument is the database name on MAMP.
Second argument is the WordPress locale. If you set "en", the latest WordPress for English locale is installed. Default is "ja".

Install the latest WordPress (locale:ja) to /Applications/MAMP/htdocs/demo/ folder and create "demo" database to the mysql on MAMP.

If /Applications/MAMP/htdocs/demo/ already exist, the installation process stops with the warning message.

If the WP-CLI command isn't installed, the tool tries to download the latest version and install it to /usr/local/bin/wp .

第１引数は、MAMP上のデータベース名になります。
第２引数は、インストールする WordPress のロケールです。もし「en」を設定すれば、英語版 WordPress がインストールされます。デフォルトは ja です。

mamp-wp-install.csh  demo ja

の場合には、MAMPのデータベース名「demo」と /Applications/MAMP/htdocs/demo/ フォルダに WordPress がインストールされます。

もし、/Applications/MAMP/htdocs/demo/ フォルダ がすでにあった場合には、警告メッセージとともに、処理が終了します。

もし、/usr/local/bin/wp に WP-CLI がインストールしていない場合には、自動的に最新の WP-CLI をダウンロードし、インストールします。

## Delete a WordPress （WordPress の削除）

mamp-wp-delete.csh  demo

1. Export the dump (sql) data of "demo" database to the mysql on MAMP to "/Applications/MAMP/htdocs/demo.sql". (If you don't need it, please remove it manually.) 
2. Delete "demo" database to the mysql on MAMP.
3. Delete /Applications/MAMP/htdocs/demo/ folder.

If the WP-CLI command isn't installed, the tool tries to download the latest version and install it to /usr/local/bin/wp .

1. MAMPの demo データベースが、 「/Applications/MAMP/htdocs/demo.sql」にエクスポート（バックアップ）します（あとで消して下さい）。
2. MAMP の demo データベースを削除します。
3. /Applications/MAMP/htdocs/demo/ フォルダを削除します。

もし、/usr/local/bin/wp に WP-CLI がインストールしていない場合には、自動的に最新の WP-CLI をダウンロードし、インストールします。
