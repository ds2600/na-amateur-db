-- ULS Update SQL Script
-- Built by Rial F. Sloan II, N0OTZ
-- Dailies can be downloaded from http://wireless.fcc.gov/uls/index.htm?job=transaction&page=daily
-- 
/* _HS Fields
record_type
unique_system_identifier
uls_file_number
callsign
log_date
code
*/
CREATE TEMPORARY TABLE temp_hs LIKE PUBACC_HS;
-- SHOW INDEX FROM temp_hs;
-- DROP INDEX `PRIMARY` ON temp_hs;
LOAD DATA INFILE '/home/n00tz/ULSDATA/amat/HS.dat' INTO TABLE temp_hs FIELDS TERMINATED BY '|' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\n';
-- SHOW COLUMNS FROM PUBACC_HS;
INSERT INTO PUBACC_HS 
	SELECT * FROM temp_hs 
	ON DUPLICATE KEY UPDATE record_type = VALUES(record_type),
		-- unique_system_identifier = VALUES(unique_system_identifier),
		uls_file_number = VALUES(uls_file_number),
		callsign = VALUES(callsign),
		log_date = VALUES(log_date),
		code = VALUES(code);
DROP TEMPORARY TABLE temp_hs;
