#!/bin/bash -e
clear

echo "============================================"
echo "WordPress Install Script"
echo "============================================"

#download wordpress
curl -O https://wordpress.org/latest.tar.gz

numero=0
limit=2

while test $numero != $limit
   	do 
	dbname="wp$numero"
	echo "Database Name: $dbname "
	
	echo "============================================"
	echo "CREATING DATABASE $dbname"
	echo "============================================"

	echo "CREATE DATABASE IF NOT EXISTS $dbname"  | mysql -u root
	dbuser="root"
	dbpass=""
	

	#unzip wordpress
	tar -zxf latest.tar.gz
	#change dir to wordpress
	mv wordpress $dbname
	chown -R www-data:www-data $dbname
	cd $dbname

	#create wp config
	cp wp-config-sample.php wp-config.php
	#set database details with perl find and replace
	perl -pi -e "s/database_name_here/$dbname/g" wp-config.php
	perl -pi -e "s/username_here/$dbuser/g" wp-config.php
	perl -pi -e "s/password_here/$dbpass/g" wp-config.php

	#set WP salts
	perl -i -pe'
	  BEGIN {
	    @chars = ("a" .. "z", "A" .. "Z", 0 .. 9);
	    push @chars, split //, "!@#$%^&*()-_ []{}<>~\`+=,.;:/?|";
	    sub salt { join "", map $chars[ rand @chars ], 1 .. 64 }
	  }
	  s/put your unique phrase here/salt()/ge
	' wp-config.php

	echo "============================================"
	echo "CREATING UPLOAD DIR and setting permissions"
	echo "============================================"
	#create uploads folder and set permissions
	mkdir wp-content/uploads
	chmod 775 wp-content/uploads

	chown -R www-data:www-data wp-content

	numero=$(($numero + 1))
	
	#coming back to the parent dir
	cd ..
done

echo "Cleaning..."
#remove zip file
rm latest.tar.gz
#remove bash script
#rm wp.sh
echo "========================="
echo "Installation is complete."
echo "========================="
