#!/bin/bash
# One-Off Import of ULSDATA
# Used to catch up if updateULSData missed a day.

echo ""
echo "expanding data"
echo ""
unzip l_am_*.zip

echo ""
echo "importing new data"
echo ""

user="{{ DB_USER }}"
host="{{ DB_HOST }}"
db="ULSDATA" #Database Name
password="{{ DB_PASSWORD"
basedir="$(pwd)"


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


# file="$basedir/AM.dat"
# if [ -f "$file" ]
# then
#         mysql --local-infile ULSDATA < update_AM.sql
#         echo "$file imported"
# else
#         echo "$file does not exist in this batch"
# fi

# file="$basedir/CO.dat"
# if [ -f "$file" ]
# then
#         mysql --local-infile ULSDATA < update_CO.sql
#         echo "$file imported"
# else
#         echo "$file does not exist in this batch"
# fi

# file="$basedir/EN.dat"
# if [ -f "$file" ]
# then
#         mysql --local-infile ULSDATA < update_EN.sql
#         echo "$file imported"
# else
#         echo "$file does not exist in this batch"
# fi

# file="$basedir/HD.dat"
# if [ -f "$file" ]
# then
#         mysql --local-infile ULSDATA < update_HD.sql
#         echo "$file imported"
# else
#         echo "$file does not exist in this batch"
# fi

# file="$basedir/HS.dat"
# if [ -f "$file" ]
# then
#         mysql --local-infile ULSDATA < update_HS.sql
#         echo "$file imported"
# else
#         echo "$file does not exist in this batch"
# fi

# file="$basedir/LA.dat"
# if [ -f "$file" ]
# then
#         mysql --local-infile ULSDATA < update_LA.sql
#         echo "$file imported"
# else
#         echo "$file does not exist in this batch"
# fi

# file="$basedir/SC.dat"
# if [ -f "$file" ]
# then
#         mysql --local-infile ULSDATA < update_SC.sql
#         echo "$file imported"
# else
#         echo "$file does not exist in this batch"
# fi

# file="$basedir/SF.dat"
# if [ -f "$file" ]
# then
#         mysql --local-infile ULSDATA < update_SF.sql
#         echo "$file imported"
# else
#         echo "$file does not exist in this batch"
# fi

echo ""
echo "done importing this batch"

#### Remove old FCC data files.

echo ""
echo "cleaning up"
echo ""
rm -f l_am_* *.dat counts
echo "files not removed"
echo ""
