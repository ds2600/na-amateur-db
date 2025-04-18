# North American Amateur Radio Database 

This is a fork of the original [FCCULS-mysql](https://github.com/n00tz/FCCULS-mysql) repo by n00tz.

This fork (for now) only covers amateur radio call sign information.

My goal is to adjust the code to be a little easier to use and add the Canadian data to the database as well.


## What is it?
The FCC ULS database provides daily updated files in a flat file format, this format is not easy to work with. This project imports the data into a structured SQL database to make searching and indexing easier. 

I've recently added the Canadian ISED call sign data as well. I have no idea how often they update, I've attempted to compensate for that. 

## Zip Code table

To make some reporting more complete, the database should include more complete demographic information than what the FCC database includes. I found a freely available database with city, state, zip, lat/long, county, country, timezone, and population details. Running a query with inner join on zip code (which is included on most FCC records) will allow the other metadata to be included.

import the zipcode table using initialize/ULSDATA_zipcodes.sql

## How to use it

**Coming Soon**
