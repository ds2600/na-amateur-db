-- ULS Update SQL Script
-- Built by Rial F. Sloan II, N0OTZ
-- Dailies can be downloaded from http://wireless.fcc.gov/uls/index.htm?job=transaction&page=daily
-- 
/* _EN Fields
record_type
unique_system_identifier
uls_file_number
ebf_number
call_sign
entity_type
licensee_id
entity_name
first_name
mi
last_name
suffix
phone
fax
email
street_address
city
state
zip_code
po_box
attention_line
sgin
frn
applicant_type_code
applicant_type_other
status_code
status_date
*/
CREATE TEMPORARY TABLE temp_en LIKE PUBACC_EN;
-- SHOW INDEX FROM temp_en;
DROP INDEX `PRIMARY` ON temp_en;
LOAD DATA LOCAL INFILE '{{ DIR }}/FCCULS-mysql/amat/EN.dat' INTO TABLE temp_en FIELDS TERMINATED BY '|' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\n';
-- SHOW COLUMNS FROM PUBACC_EN;
INSERT INTO PUBACC_EN 
	SELECT * FROM temp_en 
	ON DUPLICATE KEY UPDATE record_type = VALUES(record_type),
		-- unique_system_identifier = VALUES(unique_system_identifier),
		uls_file_number = VALUES(uls_file_number),
		ebf_number = VALUES(ebf_number),
		call_sign = VALUES(call_sign),
		entity_type = VALUES(entity_type),
		licensee_id = VALUES(licensee_id),
		entity_name = VALUES(entity_name),
		first_name = VALUES(first_name),
		mi = VALUES(mi),
		last_name = VALUES(last_name),
		suffix = VALUES(suffix),
		phone = VALUES(phone),
		fax = VALUES(fax),
		email = VALUES(email),
		street_address = VALUES(street_address),
		city = VALUES(city),
		state = VALUES(state),
		zip_code = VALUES(zip_code),
		po_box = VALUES(po_box),
		attention_line = VALUES(attention_line),
		sgin = VALUES(sgin),
		frn = VALUES(frn),
		applicant_type_code = VALUES(applicant_type_code),
		applicant_type_other = VALUES(applicant_type_other),
		status_code = VALUES(status_code),
		status_date = VALUES(status_date);
DROP TEMPORARY TABLE temp_en;
