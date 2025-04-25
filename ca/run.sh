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

DATA_FILE="amateur_delim/amateur_delim.txt"
DB_USER="$DB_USER"
DB_PASS="$DB_PASS"
DB_NAME="$DB_NAME"
DB_HOST="$DB_HOST"
BASEDIR="$(dirname "$(realpath "$0")")"

echo "Checking for CANADA_LIC table..."
TABLE_CHECK=$(mysql -u"$DB_USER" -p"$DB_PASS" -h"$DB_HOST" "$DB_NAME" -e "SHOW TABLES LIKE 'CANADA_LIC';" | grep CANADA_LIC | wc -l)
if [ "$TABLE_CHECK" -eq 0 ]; then
    # Check if CANADA_LIC table exists and create if it doesn't
    CREATE_SQL="$BASEDIR/CREATE_AMAT.sql"
    if [ ! -f "$CREATE_SQL" ]; then
        echo "Error: $CREATE_SQL not found"
        exit 1
    fi
    echo "Creating CANADA_LIC table..."
    mysql -u"$DB_USER" -p"$DB_PASS" -h"$DB_HOST" "$DB_NAME" < "$CREATE_SQL" || { echo "Error: Failed to create table"; exit 1; }
else
    echo "CANADA_LIC table already exists."
fi

ZIPFILE='amateur_delim.zip'
ZIPPATH="$BASEDIR/$ZIPFILE"
ZIPURL='https://apc-cap.ic.gc.ca/datafiles/amateur_delim.zip'

echo "Downloading Canadian data..."
curl --progress-bar -s -o "$ZIPFILE" "$ZIPURL" || { echo "Error: Failed to download zip file"; exit 1; }

yesterday=`date -d "1 day ago" +%a`
day=${yesterday,,}


if verify_zip_checksum "$ZIPPATH"; then
    echo "Data unchanged. Skipping import."
    echo "$(date),$day,skipping" >> latestRuns.txt
    rm -f "$ZIPPATH"
    exit 0
fi
echo "$(date),$day,running" >> latestRuns.txt

echo "Data changed. Proceeding with import."
store_zip_checksum "$ZIPFILE"


echo "Unzipping data..."
unzip -o "$ZIPPATH" -d amateur_delim || { echo "Error: Failed to unzip file"; exit 1; }

# Configuration

# Verify data file exists
FILE="$BASEDIR/$DATA_FILE"
if [ ! -f "$FILE" ]; then
    echo "Error: $FILE does not exist"
    exit 1
fi

# SQL to load data (embedded)
SQL_SCRIPT=$(cat << EOF

TRUNCATE TABLE CANADA_LIC;
-- Create temporary table for loading
CREATE TEMPORARY TABLE temp_canada_lic (
  callsign char(10),
  first_name varchar(20),
  surname varchar(20),
  street_address varchar(60),
  city varchar(20),
  province char(2),
  postal_code char(7),
  qual_a char(1),
  qual_b char(1),
  qual_c char(1),
  qual_d char(1),
  qual_e char(1),
  club_name varchar(50),
  club_name_2 varchar(50),
  club_address varchar(60),
  club_city varchar(20),
  club_province char(2),
  club_postal_code char(7)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Load data into temporary table
LOAD DATA LOCAL INFILE '$FILE'
INTO TABLE temp_canada_lic
FIELDS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(callsign, first_name, surname, street_address, city, province, postal_code, qual_a, qual_b, qual_c, qual_d, qual_e, club_name, club_name_2, club_address, club_city, club_province, club_postal_code);

-- Insert into main table
INSERT INTO CANADA_LIC (
  callsign, first_name, surname, street_address, city, province, postal_code,
  qual_a, qual_b, qual_c, qual_d, qual_e, club_name, club_name_2,
  club_address, club_city, club_province, club_postal_code
)
SELECT
  callsign, first_name, surname, street_address, city, province, postal_code,
  qual_a, qual_b, qual_c, qual_d, qual_e, club_name, club_name_2,
  club_address, club_city, club_province, club_postal_code
FROM temp_canada_lic;

-- Drop temporary table
DROP TEMPORARY TABLE temp_canada_lic;
EOF
)

# Execute SQL script
echo "Importing Canadian data from $FILE..."
mysql --local-infile=1 -u"$DB_USER" -p"$DB_PASS" -h"$DB_HOST" "$DB_NAME" <<< "$SQL_SCRIPT" 2> mysql_error.log

if [ $? -eq 0 ]; then
    echo "Canadian data imported successfully."
else
    echo "Error importing Canadian data. Check mysql_error.log for details."
    exit 1
fi

echo "Cleaning up..."
rm -f amateur_delim.zip
rm -rf amateur_delim
echo "Done."
