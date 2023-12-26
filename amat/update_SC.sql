-- ULS Update SQL Script
-- Built by Rial F. Sloan II, N0OTZ
-- Dailies can be downloaded from http://wireless.fcc.gov/uls/index.htm?job=transaction&page=daily
-- 
/* _SC Fields
record_type
unique_system_identifier
uls_file_number
ebf_number
callsign
special_condition_type
special_condition_code
status_code
status_date
*/
CREATE TEMPORARY TABLE temp_sc LIKE PUBACC_SC;
-- SHOW INDEX FROM temp_sc;
-- DROP INDEX `PRIMARY` ON temp_sc;
LOAD DATA LOCAL INFILE '{{ DIR }}/FCCULS-mysql/amat/SC.dat' INTO TABLE temp_sc FIELDS TERMINATED BY '|' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\n';
-- SHOW COLUMNS FROM PUBACC_SC;
INSERT INTO PUBACC_SC 
	SELECT * FROM temp_sc 
	ON DUPLICATE KEY UPDATE record_type = VALUES(record_type),
		-- unique_system_identifier = VALUES(unique_system_identifier),
		uls_file_number = VALUES(uls_file_number),
		ebf_number = VALUES(ebf_number),
		callsign = VALUES(callsign),
		special_condition_type = VALUES(special_condition_type),
		special_condition_code = VALUES(special_condition_code),
		status_code = VALUES(status_code),
		status_date = VALUES(status_date);
DROP TEMPORARY TABLE temp_sc;
