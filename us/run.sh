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

generate_zip_checksum() {
    local zipfile="$1"
    sha256sum "$zipfile" | awk '{print $1}'
}

store_zip_checksum() {
    local zipfile="$1"
    local outfile="${zipfile}.sha256"

    generate_zip_checksum "$zipfile" > "$outfile"
    echo "Stored checksum in $outfile"
}

verify_zip_checksum() {
    local zipfile="$1"
    local outfile="${zipfile}.sha256"

    if [[ ! -f "$outfile" ]]; then
        echo "No stored checksum file found: $outfile" >&2
        false
        return
    fi

    local current
    current=$(generate_zip_checksum "$zipfile")
    local stored
    stored=$(<"$outfile")

    if [[ "$current" == "$stored" ]]; then
        true
    else
        false
    fi
}


#### Get new FCC data

echo "Getting yesterday's data from FCC ULS"
ZIPFILE="l_am_$day.zip"
curl -O https://data.fcc.gov/download/pub/uls/daily/$ZIPFILE

if verify_zip_checksum "$ZIPFILE"; then
    echo "Data unchanged. Skipping import."
    echo "$(date),$day,skipping" >> latestRuns.txt
    rm -f "$ZIPFILE"
    exit 0
fi
echo "$(date),$day,running" >> latestRuns.txt

echo "Data changed. Proceeding with import."
store_zip_checksum "$ZIPFILE"

echo "expanding data"
unzip -o $ZIPFILE

echo "importing new data"

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



echo "done importing this batch"

#### Remove old FCC data files.

echo "cleaning up"
rm -f l_am_$day.zip *.dat counts
echo "files removed"
