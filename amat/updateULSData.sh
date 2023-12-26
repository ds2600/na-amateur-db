#!/bin/bash

# Info
#
# before running this script, create a database named ULSDATA on your mysql -h $host -u $user -p$password host.
#
# edit your .my.cnf to include your mysql -h $host -u $user -p$password host, username, password (see below)
#
# [client]
# host=127.0.0.1
# user=mysql_user
# password="mysql_password"
#

user="{{ DB_USER }}"
host="{{ DB_HOST }}"
db="ULSDATA"
password="{{ DB_PASSWORD }}"
basedir="{{ DIR }}/FCCULS-mysql/amat"

yesterday=`date -d "1 day ago" +%a`
day=${yesterday,,}

#### Get new FCC data

echo ""
echo "Getting yesterday's data from FCC ULS"
echo ""
wget -U "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:120.0) Gecko/20100101 Firefox/120.0" https://data.fcc.gov/download/pub/uls/daily/l_am_$day.zip

echo ""
echo "expanding data"
echo ""
unzip l_am_$day.zip

#### import the new data

echo ""
echo "importing new data"
echo ""

file="AM.dat"
if [ -f "$file" ]
then
	mysql -h $host -u $user -p$password ULSDATA < {{ DIR }}/FCCULS-mysql/amat/update_AM.sql
	echo "$file imported"
else
	echo "$file does not exist in this batch"
fi

file="CO.dat"
if [ -f "$file" ]
then
        mysql -h $host -u $user -p$password ULSDATA < {{ DIR }}/FCCULS-mysql/amat/update_CO.sql
        echo "$file imported"
else
        echo "$file does not exist in this batch"
fi

file="EN.dat"
if [ -f "$file" ]
then
        mysql -h $host -u $user -p$password ULSDATA < {{ DIR }}/FCCULS-mysql/amat/update_EN.sql
        echo "$file imported"
else
        echo "$file does not exist in this batch"
fi

file="HD.dat"
if [ -f "$file" ]
then
        mysql -h $host -u $user -p$password ULSDATA < {{ DIR }}/FCCULS-mysql/amat/update_HD.sql
        echo "$file imported"
else
        echo "$file does not exist in this batch"
fi

file="HS.dat"
if [ -f "$file" ]
then
        mysql -h $host -u $user -p$password ULSDATA < {{ DIR }}/FCCULS-mysql/amat/update_HS.sql
        echo "$file imported"
else
        echo "$file does not exist in this batch"
fi

file="LA.dat"
if [ -f "$file" ]
then
        mysql -h $host -u $user -p$password ULSDATA < {{ DIR }}/FCCULS-mysql/amat/update_LA.sql
        echo "$file imported"
else
        echo "$file does not exist in this batch"
fi

file="SC.dat"
if [ -f "$file" ]
then
        mysql -h $host -u $user -p$password ULSDATA < {{ DIR }}/FCCULS-mysql/amat/update_SC.sql
        echo "$file imported"
else
        echo "$file does not exist in this batch"
fi

file="SF.dat"
if [ -f "$file" ]
then
        mysql -h $host -u $user -p$password ULSDATA < {{ DIR }}/FCCULS-mysql/amat/update_SF.sql
        echo "$file imported"
else
        echo "$file does not exist in this batch"
fi

echo ""
echo "done importing this batch"

#### Remove old FCC data files.

echo ""
echo "cleaning up"
echo ""
rm -f l_am_$day.zip *.dat counts
echo "files removed"
echo ""
