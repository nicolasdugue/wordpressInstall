#!/bin/bash -e
clear

echo "============================================"
echo "WordPress CLEANING Script"
echo "============================================"

numero=0
limit=2

while test $numero != $limit
   	do 
	dbname="wp$numero"
	echo "Database Name: $dbname "
	
	echo "============================================"
	echo "REMOVING DATABASE $dbname"
	echo "============================================"

	echo "DROP DATABASE IF EXISTS $dbname"  | mysql -u root
	dbuser="root"
	dbpass=""
	

	rm -r $dbname

	numero=$(($numero + 1))
	
done
echo "========================="
echo "cleaning complete."
echo "========================="
