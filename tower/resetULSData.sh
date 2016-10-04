#!/bin/bash

# Info
#
# before running this script, create a database named ULSDATA on your mysql host.
#
# edit your .my.cnf to include your mysql host, username, password (see below)
#
# [client]
# host=127.0.0.1
# user=mysql_user
# password="mysql_password"
#


#### Get new FCC data

echo "getting new data from FCC ULS"
echo ""
wget http://wireless.fcc.gov/uls/data/complete/r_tower.zip

echo ""
echo "expanding data"
echo ""
unzip r_tower.zip

#### Clean up old data from Database

echo "clearing old data out of database"
echo ""
mysql -e 'truncate table TOWER_PUBACC_CO' ULSDATA
echo "                         TOWER_PUBACC_CO truncated"
mysql -e 'truncate table TOWER_PUBACC_EN' ULSDATA
echo "                         TOWER_PUBACC_EN truncated"
mysql -e 'truncate table TOWER_PUBACC_HS' ULSDATA
echo "                         TOWER_PUBACC_HS truncated"
mysql -e 'truncate table TOWER_PUBACC_RA' ULSDATA
echo "                         TOWER_PUBACC_RA truncated"
mysql -e 'truncate table TOWER_PUBACC_RE' ULSDATA
echo "                         TOWER_PUBACC_RE truncated"
mysql -e 'truncate table TOWER_PUBACC_SC' ULSDATA
echo "                         TOWER_PUBACC_SC truncated"

#### import the new data

echo "importing new data (this can take awhile depending on the speed of your computer and the receiving mysql server)"
echo ""
mysql ULSDATA < loadULSDATA_tower.sql

echo "done"

#### Remove old FCC data files.

echo "cleaning up"
echo ""

rm -f r_tower.zip
echo "r_tower.zip removed"
rm -f *.dat
echo "*.dat removed"
rm -f counts
echo "counts removed"
echo ""
