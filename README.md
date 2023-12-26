# FCCULS-mysql2

This is a fork of the original [FCCULS-mysql](https://github.com/n00tz/FCCULS-mysql) repo by n00tz. 

My goal is just to simplify the actual initial and ongoing process to make it easier for anyone to implement.

## What is it?
The [FCC ULS databases](https://www.fcc.gov/wireless/data) are available as a download in a flat file format. Querying flat files isn't very easy, so to more easily manipulate the data and present it in a workable format we will import it into a relational database server.

If you have an operating MySQL database server (MySQL, Percona, MariaDB) the code in this repo will assist you in getting the FCC data in a self-hosted SQL queryable format.

## Zip Code table

To make some reporting more complete, the database should include more complete demographic information than what the FCC database includes. I found a freely available database with city, state, zip, lat/long, county, country, timezone, and population details. Running a query with inner join on zip code (which is included on most FCC records) will allow the other metadata to be included.

import the zipcode table using initialize/ULSDATA_zipcodes.sql


## Amateur Operator tables

The full details of the FCC ULS database for Amateur Operator information.

#### Amateur Operator table structure
bootstrap amateur operator tables using initialize/ULSDATA_amat_SCHEMA.sql


## Amateur Tower tables

The full details of the FCC ULS database for Tower information

#### Tower table structure
bootstrap tower tables using initialize/ULSDATA_tower_SCHEMA.sql
