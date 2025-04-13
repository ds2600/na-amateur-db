#!/bin/bash

set -e

# Load .env file
if [ -f "../.env" ]; then
    export $(grep -v '^#' ../.env | xargs)
else
    echo "Error: .env file not found"
    exit 1
fi

DB_USER="$DB_USER"
DB_PASS="$DB_PASS"
DB_NAME="$DB_NAME"
DB_HOST="$DB_HOST"

if ([ -z "$DB_USER" ] || [ -z "$DB_PASS" ] || [ -z "$DB_NAME" ] || [ -z "$DB_HOST" ]); then
    echo "Error: Database credentials are not set in the .env file"
    exit 1
fi

run_sql_file() {
    local sql_file="$1"
    if [ -f "$sql_file" ]; then
        echo "Executing $sql_file..."
        mysql -u "$DB_USER" -p"$DB_PASS" -h "$DB_HOST" "$DB_NAME" < "$sql_file"
        if [ $? -eq 0 ]; then
            echo "Successfully executed $sql_file"
        else
            echo "Error executing $sql_file"
            exit 1
        fi
    else
        echo "Error: $sql_file not found"
        exit 1
    fi
}

sql_files=(
    "us/CREATE_ZIP_CODES.sql"
    "us/CREATE_AMAT.sql"
    "ca/CREATE_AMAT.sql"
)

for sql_file in "${sql_files[@]}"; do
    run_sql_file "$sql_file"
done

echo "All SQL files executed successfully."
