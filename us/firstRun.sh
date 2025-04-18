#!/bin/bash

# Script to load initial Canadian ham radio licensee data into CANADA_LIC table
# File: load_canada_lic.sh
# Assumes data file is semicolon-separated: callsign;first_name;surname;address_line;city;prov_cd;postal_code;qual_a;qual_b;qual_c;qual_d;qual_e;club_name;club_name_2;club_address;club_city;club_prov_cd;club_postal_code
# Database credentials are read from .env file

# Exit on error
set -e

# Load .env file
if [ -f "../.env" ]; then
    export $(grep -v '^#' ../.env | xargs)
else
    echo "Error: .env file not found"
    exit 1
fi

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

ZIPFILE='l_amat.zip'
ZIPURL='https://data.fcc.gov/download/pub/uls/complete/l_amat.zip'

echo "Downloading US data..."
curl --progress-bar -s -o "$ZIPFILE" "$ZIPURL" || { echo "Error: Failed to download zip file"; exit 1; }

if verify_zip_checksum "$ZIPFILE"; then
    echo "Data unchanged. Skipping import."
    rm -f "$ZIPFILE"
    exit 0
fi

echo "Data changed. Proceeding with import."
store_zip_checksum "$ZIPFILE"

echo "Unzipping data..."
unzip -o "$ZIPFILE" -d l_amat || { echo "Error: Failed to unzip file"; exit 1; }

# Configuration
DB_USER="$DB_USER"
DB_PASS="$DB_PASS"
DB_NAME="$DB_NAME"
DB_HOST="$DB_HOST"
BASEDIR="$(pwd)"


run_sql() {
    local file="$1"
    local table="$2"
    echo "Loading $file into $table..."
    mysql --local-infile=1 -u"$DB_USER" -p"$DB_PASS" -h"$DB_HOST" "$DB_NAME" <<EOF
LOAD DATA LOCAL INFILE '${BASEDIR}/l_amat/${file}' INTO TABLE ${table} FIELDS TERMINATED BY '|' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n';
EOF

    if [ $? -eq 0 ]; then
        echo "$file loaded successfully into $table."
    else
        echo "Error loading $file into $table. Check mysql_error.log for details."
        exit 1
    fi
}

# Execute SQL script
echo "Importing US data..."
run_sql 'AM.dat' 'PUBACC_AM' 2>> mysql_error.log
run_sql 'CO.dat' 'PUBACC_CO' 2>> mysql_error.log
run_sql 'EN.dat' 'PUBACC_EN' 2>> mysql_error.log
run_sql 'HD.dat' 'PUBACC_HD' 2>> mysql_error.log
run_sql 'HS.dat' 'PUBACC_HS' 2>> mysql_error.log
run_sql 'LA.dat' 'PUBACC_LA' 2>> mysql_error.log
run_sql 'SC.dat' 'PUBACC_SC' 2>> mysql_error.log
run_sql 'SF.dat' 'PUBACC_SF' 2>> mysql_error.log

if [ $? -eq 0 ]; then
    echo "US data imported successfully."
else
    echo "Error importing US data. Check mysql_error.log for details."
    exit 1
fi

echo "Cleaning up..."
rm -f $ZIPFILE 
rm -rf l_amat
echo "Done."

