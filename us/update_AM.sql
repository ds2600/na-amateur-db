-- ULS Update SQL Script
-- Built by Rial F. Sloan II, N0OTZ
-- Dailies can be downloaded from http://wireless.fcc.gov/uls/index.htm?job=transaction&page=daily
-- 
/*  _AM Fields
record_type,
unique_system_identifier,
uls_file_num,
ebf_number,
callsign,
operator_class,
group_code,
region_code,
trustee_callsign,
trustee_indicator,
physician_certification,
ve_signature,
systematic_callsign_change,
vanity_callsign_change,
vanity_relationship,
previous_callsign,
previous_operator_class,
trustee_name,
*/
CREATE TEMPORARY TABLE temp_am LIKE PUBACC_AM;
-- SHOW INDEX FROM temp_am;
DROP INDEX `PRIMARY` ON temp_am;
LOAD DATA LOCAL INFILE '{{ DIR }}/FCCULS-mysql/amat/AM.dat' INTO TABLE temp_am FIELDS TERMINATED BY '|' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\n';
-- SHOW COLUMNS FROM PUBACC_AM;
INSERT INTO PUBACC_AM
	SELECT * FROM temp_am 
	ON DUPLICATE KEY UPDATE record_type = VALUES(record_type),
		-- unique_system_identifier = VALUES(unique_system_identifier),
		uls_file_num = VALUES(uls_file_num),
		ebf_number = VALUES(ebf_number),
		callsign = VALUES(callsign),
		operator_class = VALUES(operator_class),
		group_code = VALUES(group_code),
		region_code = VALUES(region_code),
		trustee_callsign = VALUES(trustee_callsign),
		trustee_indicator = VALUES(trustee_indicator),
		physician_certification = VALUES(physician_certification),
		ve_signature = VALUES(ve_signature),
		systematic_callsign_change = VALUES(systematic_callsign_change),
		vanity_callsign_change = VALUES(vanity_callsign_change),
		vanity_relationship = VALUES(vanity_relationship),
		previous_callsign = VALUES(previous_callsign),
		previous_operator_class = VALUES(previous_operator_class),
		trustee_name = VALUES(trustee_name);
DROP TEMPORARY TABLE temp_am;
