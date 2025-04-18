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

```bash

# Install dependencies
sudo apt update
sudo apt install mysql-client curl unzip

# Clone the repo
git clone https://github.com/ds2600/na-amateur-db.git && cd na-amateur-db

# Create the .env file with your database parameters. You don't need to have a database created yet.
cp .env.example .env

# Make the shell scripts executable
chmod +x initialize.sh us/firstRun.sh us/run.sh ca/run.sh

# Run intialization script - this should be run on a Sunday after the FCC updates their data
./initialize.sh

# Add the following to your crontab
0 12 * * * /path/to/na-amateur-db/us/run.sh
0 12 * * * /path/to/na-amateur-db/ca/run.sh
```
