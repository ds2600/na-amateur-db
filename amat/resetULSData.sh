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

echo ""
echo "getting new data from FCC ULS"
echo ""
wget http://wireless.fcc.gov/uls/data/complete/l_amat.zip
echo ""
echo "expanding data"
echo ""
unzip l_amat.zip

#### Clean up old data from Database

echo ""
echo "clearing old data out of database"
mysql -e 'truncate table PUBACC_AM' ULSDATA
echo "PUBACC_AM truncated"
mysql -e 'truncate table PUBACC_CO' ULSDATA
echo "PUBACC_CO truncated"
mysql -e 'truncate table PUBACC_EN' ULSDATA
echo "PUBACC_EN truncated"
mysql -e 'truncate table PUBACC_HD' ULSDATA
echo "PUBACC_HD truncated"
mysql -e 'truncate table PUBACC_HS' ULSDATA
echo "PUBACC_HS truncated"
mysql -e 'truncate table PUBACC_LA' ULSDATA
echo "PUBACC_LA truncated"
mysql -e 'truncate table PUBACC_SC' ULSDATA
echo "PUBACC_SC truncated"
mysql -e 'truncate table PUBACC_SF' ULSDATA
echo "PUBACC_SF truncated"

#### import the new data

echo ""
echo "importing new data"
mysql ULSDATA < loadULSDATA.sql
echo "... done"

#### Remove old FCC data files.

echo ""
echo "cleaning up"
rm -f l_amat.zip *.dat counts
