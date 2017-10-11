# mamp-wp-installer
This is the helpful shell script tools for installing or removing WordPress on MAMP by a command line for MacOS. If you want to use them, please install MAMP (https://www.mamp.info/en/),  first. I tested the tool on MacOS 10.12.6.

# How to install

git clone https://github.com/kimipooh/mamp-wp-installer
cd mamp-wp-installer

Move to mamp-wp-install.csh and mamp-wp-delete.csh to a path directory, such as /usr/local/bin .

# How to set an initial settings.

Please check your MAMP php folder (/Applications/MAMP/bin/php/php[version]/bin). The default setting is for php5.6.30 on MAMP 4.0

Please change "set path" to your php path in mamp-wp-install.csh and mamp-wp-delete.csh.
set path = (/Applications/MAMP/bin/php/php5.6.30/bin $path)

If you change a host, such as localhost instead of localhost:8888 (default), please change "set wp_url" value in mamp-wp-install.csh and mamp-wp-delete.csh .

# How to use

## Installation a WordPress

mamp-wp-install.csh  demo ja

Install the latest WordPress (locale:ja) to /Applications/MAMP/htdocs/demo/ folder and create "demo" database to the mysql on MAMP.

If the WP-CLI command isn't installed, the tool tries to download the latest version and install it to /usr/local/bin/wp .

If /Applications/MAMP/htdocs/demo/ already exist, the installation process stops with the warning message.

## Delete a WordPress

mamp-wp-delete.csh  demo

1. Export the dump (sql) data of "demo" database to the mysql on MAMP to Applications/MAMP/htdocs. 
2. Delete "demo" database to the mysql on MAMP.
3. Delete /Applications/MAMP/htdocs/demo/ folder.

If the WP-CLI command isn't installed, the tool tries to download the latest version and install it to /usr/local/bin/wp .
