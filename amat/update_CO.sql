-- ULS Update SQL Script
-- Built by Rial F. Sloan II, N0OTZ
-- Dailies can be downloaded from http://wireless.fcc.gov/uls/index.htm?job=transaction&page=daily
-- 
/* _CO Fields
record_type
unique_system_identifier
uls_file_num
callsign
comment_date
description
status_code
status_date
*/
CREATE TEMPORARY TABLE temp_co LIKE PUBACC_CO;
-- SHOW INDEX FROM temp_co;
-- DROP INDEX `PRIMARY` ON temp_co;
LOAD DATA INFILE '/home/n00tz/ULSDATA/amat/CO.dat' INTO TABLE temp_co FIELDS TERMINATED BY '|' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\n';
-- SHOW COLUMNS FROM PUBACC_CO;
INSERT INTO PUBACC_CO
	SELECT * FROM temp_co 
	ON DUPLICATE KEY UPDATE record_type = VALUES(record_type),
		-- unique_system_identifier = VALUES(unique_system_identifier),
		uls_file_num = VALUES(uls_file_num),
		callsign = VALUES(callsign),
		comment_date = VALUES(comment_date),
		description = VALUES(description),
		status_code = VALUES(status_code),
		status_date = VALUES(status_date);
DROP TEMPORARY TABLE temp_co;
