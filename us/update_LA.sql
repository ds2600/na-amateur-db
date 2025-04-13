-- ULS Update SQL Script
-- Built by Rial F. Sloan II, N0OTZ
-- Dailies can be downloaded from http://wireless.fcc.gov/uls/index.htm?job=transaction&page=daily
-- 
/* _LA Fields
record_type
unique_system_identifier
callsign
attachment_code
attachment_desc
attachment_date
attachment_filename
action_performed
*/
CREATE TEMPORARY TABLE temp_la LIKE PUBACC_LA;
-- SHOW INDEX FROM temp_la;
-- DROP INDEX `PRIMARY` ON temp_la;
LOAD DATA LOCAL INFILE '{{ DIR }}/FCCULS-mysql/amat/LA.dat' INTO TABLE temp_la FIELDS TERMINATED BY '|' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\n';
-- SHOW COLUMNS FROM PUBACC_LA;
INSERT INTO PUBACC_LA 
	SELECT * FROM temp_la 
	ON DUPLICATE KEY UPDATE record_type = VALUES(record_type),
		-- unique_system_identifier = VALUES(unique_system_identifier),
		callsign = VALUES(callsign),
		attachment_code = VALUES(attachment_code),
		attachment_desc = VALUES(attachment_desc),
		attachment_date = VALUES(attachment_date),
		attachment_filename = VALUES(attachment_filename),
		action_performed = VALUES(action_performed);
DROP TEMPORARY TABLE temp_la;
