-- ULS Update SQL Script
-- Built by Rial F. Sloan II, N0OTZ
-- Dailies can be downloaded from http://wireless.fcc.gov/uls/index.htm?job=transaction&page=daily
-- 
/* _SF Fields
record_type
unique_system_identifier
uls_file_number
ebf_number
callsign
lic_freeform_cond_type
unique_lic_freeform_id
sequence_number
lic_freeform_condition
status_code
status_date
*/
CREATE TEMPORARY TABLE temp_sf LIKE PUBACC_SF;
-- SHOW INDEX FROM temp_sf;
-- DROP INDEX `PRIMARY` ON temp_sf;
LOAD DATA INFILE '/home/n00tz/ULSDATA/amat/SF.dat' INTO TABLE temp_sf FIELDS TERMINATED BY '|' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\n';
-- SHOW COLUMNS FROM PUBACC_SF;
INSERT INTO PUBACC_SF 
	SELECT * FROM temp_sf 
	ON DUPLICATE KEY UPDATE record_type = VALUES(record_type),
		-- unique_system_identifier = VALUES(unique_system_identifier),
		uls_file_number = VALUES(uls_file_number),
		ebf_number = VALUES(ebf_number),
		callsign = VALUES(callsign),
		lic_freeform_cond_type = VALUES(lic_freeform_cond_type),
		unique_lic_freeform_id = VALUES(unique_lic_freeform_id),
		sequence_number = VALUES(sequence_number),
		lic_freeform_condition = VALUES(lic_freeform_condition),
		status_code = VALUES(status_code),
		status_date = VALUES(status_date);
DROP TEMPORARY TABLE temp_sf;
