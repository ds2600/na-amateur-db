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
basedir="{{ DIR }}/ULSDATA/amat"


file="AM.dat"
if [ -f "$file" ]
then
        mysql -h $host -u $user -p$password ULSDATA < update_AM.sql
        echo "$file imported"
else
        echo "$file does not exist in this batch"
fi

file="CO.dat"
if [ -f "$file" ]
then
        mysql -h $host -u $user -p$password ULSDATA < update_CO.sql
        echo "$file imported"
else
        echo "$file does not exist in this batch"
fi

file="EN.dat"
if [ -f "$file" ]
then
        mysql -h $host -u $user -p$password ULSDATA < update_EN.sql
        echo "$file imported"
else
        echo "$file does not exist in this batch"
fi

file="HD.dat"
if [ -f "$file" ]
then
        mysql -h $host -u $user -p$password ULSDATA < update_HD.sql
        echo "$file imported"
else
        echo "$file does not exist in this batch"
fi

file="HS.dat"
if [ -f "$file" ]
then
        mysql -h $host -u $user -p$password ULSDATA < update_HS.sql
        echo "$file imported"
else
        echo "$file does not exist in this batch"
fi

file="LA.dat"
if [ -f "$file" ]
then
        mysql -h $host -u $user -p$password ULSDATA < update_LA.sql
        echo "$file imported"
else
        echo "$file does not exist in this batch"
fi

file="SC.dat"
if [ -f "$file" ]
then
        mysql -h $host -u $user -p$password ULSDATA < update_SC.sql
        echo "$file imported"
else
        echo "$file does not exist in this batch"
fi

file="SF.dat"
if [ -f "$file" ]
then
        mysql -h $host -u $user -p$password ULSDATA < update_SF.sql
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
rm -f l_am_* *.dat counts
echo "files removed"
echo ""
