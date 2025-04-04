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
basedir="$(pwd)"

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

run_sql() {
    local dat_file="$1"
    local sql_file="$2"
    file="$basedir/$dat_file"
    if [ -f "$file" ]
    then
        sed "s|{{ DIR }}/FCCULS-mysql/amat|$basedir|g" "$sql_file" | mysql --local-infile "$db"
        echo "$file imported"
    else
        echo "$file does not exist in this batch"
    fi
}

    run_sql "AM.dat" "update_AM.sql"
    run_sql "CO.dat" "update_CO.sql"
    run_sql "EN.dat" "update_EN.sql"
    run_sql "HD.dat" "update_HD.sql"
    run_sql "HS.dat" "update_HS.sql"
    run_sql "LA.dat" "update_LA.sql"
    run_sql "SC.dat" "update_SC.sql"
    run_sql "SF.dat" "update_SF.sql"



echo ""
echo "done importing this batch"

#### Remove old FCC data files.

echo ""
echo "cleaning up"
echo ""
rm -f l_am_$day.zip *.dat counts
echo "files removed"
echo ""
