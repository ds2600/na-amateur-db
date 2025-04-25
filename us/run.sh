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

UPDATE=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --update)
            UPDATE=true
            shift
            ;;
        *)
            break
            ;;
    esac
done

user="{{ DB_USER }}"
host="{{ DB_HOST }}"
db="ULSDATA"
password="{{ DB_PASSWORD }}"
basedir="$(dirname "$(realpath "$0")")"
cd "$basedir" || exit 1

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

process_day() {
    local day="$1"
    echo "Processing day: $day"
    ZIPFILE="l_am_$day.zip"
    ZIPPATH="$basedir/$ZIPFILE"
    curl -O https://data.fcc.gov/download/pub/uls/daily/$ZIPFILE

    if verify_zip_checksum "$ZIPPATH"; then
        echo "Data unchanged. Skipping import."
        echo "$(date),$day,skipping" >> "$basedir/latestRuns.txt"
        rm -f "$ZIPPATH"
        exit 0
    fi
    echo "$(date),$day,running" >> "$basedir/latestRuns.txt"
    echo "Data changed. Proceeding with import."
    store_zip_checksum "$ZIPFILE"
    echo "expanding data"
    unzip -o $ZIPPATH
    echo "importing new data"

    run_sql "AM.dat" "update_AM.sql"
    run_sql "CO.dat" "update_CO.sql"
    run_sql "EN.dat" "update_EN.sql"
    run_sql "HD.dat" "update_HD.sql"
    run_sql "HS.dat" "update_HS.sql"
    run_sql "LA.dat" "update_LA.sql"
    run_sql "SC.dat" "update_SC.sql"
    run_sql "SF.dat" "update_SF.sql"

    echo "done importing $day batch"
    echo "cleaning up"
    rm -f $ZIPPATH *.dat counts
    echo "files removed"

}

if $UPDATE; then
    yesterday=$(date -d "1 day ago" +%Y-%m-%d)
    latest_sunday=$(date -d "last Sunday" +%Y-%m-%d)
    current_date=$latest_sunday
    while [[ "$current_date" < "$yesterday" ]]; do
        current_date=$(date -d "$current_date + 1 day" +%Y-%m-%d)
        day=$(date -d "$current_date" +%a | tr '[:upper:]' '[:lower:]')
        process_day "$day"
    done
else
    process_day "$day"
fi

