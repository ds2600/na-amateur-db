-- ULS Update SQL Script
-- Built by Rial F. Sloan II, N0OTZ
-- Dailies can be downloaded from http://wireless.fcc.gov/uls/index.htm?job=transaction&page=daily
-- 
/* _HD Fields
record_type
unique_system_identifier
uls_file_number
ebf_number
call_sign
license_status
radio_service_code
grant_date
expired_date
cancellation_date
eligibility_rule_num
applicant_type_code_reserved
alien
alien_government
alien_corporation
alien_officer
alien_control
revoked
convicted
adjudged
involved_reserved
common_carrier
non_common_carrier
private_comm
fixed
mobile
radiolocation
satellite
developmental_or_sta
interconnected_service
certifier_first_name
certifier_mi
certifier_last_name
certifier_suffix
certifier_title
gender
african_american
native_american
hawaiian
asian
white
ethnicity
effective_date
last_action_date
auction_id
reg_stat_broad_serv
band_manager
type_serv_broad_serv
alien_ruling
licensee_name_change
*/
CREATE TEMPORARY TABLE temp_hd LIKE PUBACC_HD;
-- SHOW INDEX FROM temp_hd;
DROP INDEX `PRIMARY` ON temp_hd;
LOAD DATA LOCAL INFILE '{{ DIR }}/FCCULS-mysql/amat/HD.dat' INTO TABLE temp_hd FIELDS TERMINATED BY '|' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\n';
-- SHOW COLUMNS FROM PUBACC_HD;
INSERT INTO PUBACC_HD 
	SELECT * FROM temp_hd 
	ON DUPLICATE KEY UPDATE record_type = VALUES(record_type),
		-- unique_system_identifier = VALUES(unique_system_identifier),
		uls_file_number = VALUES(uls_file_number),
		ebf_number = VALUES(ebf_number),
		call_sign = VALUES(call_sign),
		license_status = VALUES(license_status),
		radio_service_code = VALUES(radio_service_code),
		grant_date = VALUES(grant_date),
		expired_date = VALUES(expired_date),
		cancellation_date = VALUES(cancellation_date),
		eligibility_rule_num = VALUES(eligibility_rule_num),
		applicant_type_code_reserved = VALUES(applicant_type_code_reserved),
		alien = VALUES(alien),
		alien_government = VALUES(alien_government),
		alien_corporation = VALUES(alien_corporation),
		alien_officer = VALUES(alien_officer),
		alien_control = VALUES(alien_control),
		revoked = VALUES(revoked),
		convicted = VALUES(convicted),
		adjudged = VALUES(adjudged),
		involved_reserved = VALUES(involved_reserved),
		common_carrier = VALUES(common_carrier),
		non_common_carrier = VALUES(non_common_carrier),
		private_comm = VALUES(private_comm),
		fixed = VALUES(fixed),
		mobile = VALUES(mobile),
		radiolocation = VALUES(radiolocation),
		satellite = VALUES(satellite),
		developmental_or_sta = VALUES(developmental_or_sta),
		interconnected_service = VALUES(interconnected_service),
		certifier_first_name = VALUES(certifier_first_name),
		certifier_mi = VALUES(certifier_mi),
		certifier_last_name = VALUES(certifier_last_name),
		certifier_suffix = VALUES(certifier_suffix),
		certifier_title = VALUES(certifier_title),
		gender = VALUES(gender),
		african_american = VALUES(african_american),
		native_american = VALUES(native_american),
		hawaiian = VALUES(hawaiian),
		asian = VALUES(asian),
		white = VALUES(white),
		ethnicity = VALUES(ethnicity),
		effective_date = VALUES(effective_date),
		last_action_date = VALUES(last_action_date),
		auction_id = VALUES(auction_id),
		reg_stat_broad_serv = VALUES(reg_stat_broad_serv),
		band_manager = VALUES(band_manager),
		type_serv_broad_serv = VALUES(type_serv_broad_serv),
		alien_ruling = VALUES(alien_ruling),
		licensee_name_change = VALUES(licensee_name_change);
DROP TEMPORARY TABLE temp_hd;
