CREATE TABLE `TOWER_PUBACC_CO` (
  `record_type` char(2) DEFAULT NULL,
  `content_indicator` char(3) DEFAULT NULL,
  `file_number` char(8) DEFAULT NULL,
  `registration_number` char(7) DEFAULT NULL,
  `unique_system_identifier` decimal(9,0) NOT NULL,
  `coordinate_type` char(1) NOT NULL,
  `latitude_degrees` int(11) DEFAULT NULL,
  `latitude_minutes` int(11) DEFAULT NULL,
  `latitude_seconds` decimal(4,1) DEFAULT NULL,
  `latitude_direction` char(1) DEFAULT NULL,
  `latitude_total_seconds` decimal(8,1) DEFAULT NULL,
  `longitude_degrees` int(11) DEFAULT NULL,
  `longitude_minutes` int(11) DEFAULT NULL,
  `longitude_seconds` decimal(4,1) DEFAULT NULL,
  `longitude_direction` char(1) DEFAULT NULL,
  `longitude_total_seconds` decimal(8,1) DEFAULT NULL,
  `array_tower_position` int(11) DEFAULT NULL,
  `array_total_tower` int(11) DEFAULT NULL,
  PRIMARY KEY (`unique_system_identifier`,`coordinate_type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `TOWER_PUBACC_EN` (
  `record_type` char(2) DEFAULT NULL,
  `content_indicator` char(3) DEFAULT NULL,
  `file_number` char(8) DEFAULT NULL,
  `registration_number` char(7) NOT NULL,
  `unique_system_identifier` decimal(9,0) NOT NULL,
  `entity_type` char(1) NOT NULL,
  `entity_type_code` char(1) DEFAULT NULL,
  `entity_type_other` varchar(80) DEFAULT NULL,
  `licensee_id` char(9) DEFAULT NULL,
  `entity_name` varchar(200) DEFAULT NULL,
  `first_name` varchar(20) DEFAULT NULL,
  `mi` char(1) DEFAULT NULL,
  `last_name` varchar(20) DEFAULT NULL,
  `suffix` char(3) DEFAULT NULL,
  `phone` varchar(10) DEFAULT NULL,
  `fax` varchar(10) DEFAULT NULL,
  `internet_address` varchar(50) DEFAULT NULL,
  `street_address` varchar(35) DEFAULT NULL,
  `street_address2` varchar(35) DEFAULT NULL,
  `po_box` varchar(20) DEFAULT NULL,
  `city` varchar(20) DEFAULT NULL,
  `state` char(2) DEFAULT NULL,
  `zip_code` char(9) DEFAULT NULL,
  `attention` varchar(35) DEFAULT NULL,
  `frn` char(10) DEFAULT NULL,
  PRIMARY KEY (`unique_system_identifier`,`entity_type`,`registration_number`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `TOWER_PUBACC_HS` (
  `record_type` char(2) DEFAULT NULL,
  `content_indicator` char(3) DEFAULT NULL,
  `file_number` char(8) DEFAULT NULL,
  `registration_number` char(7) DEFAULT NULL,
  `unique_system_identifier` decimal(9,0) NOT NULL,
  `date` char(10) DEFAULT NULL,
  `description` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `TOWER_PUBACC_RA` (
  `RECORD_TYPE` char(2) DEFAULT NULL,
  `CONTENT_INDICATOR` char(3) DEFAULT NULL,
  `FILE_NUMBER` char(8) DEFAULT NULL,
  `REGISTRATION_NUMBER` char(7) NOT NULL,
  `UNIQUE_SYSTEM_IDENTIFIER` decimal(9,0) NOT NULL,
  `APPLICATION_PURPOSE` char(2) DEFAULT NULL,
  `PREVIOUS_PURPOSE` char(2) DEFAULT NULL,
  `INPUT_SOURCE_CODE` char(1) DEFAULT NULL,
  `STATUS_CODE` char(1) DEFAULT NULL,
  `DATE_ENTERED` char(10) DEFAULT NULL,
  `DATE_RECEIVED` char(10) DEFAULT NULL,
  `DATE_ISSUED` char(10) DEFAULT NULL,
  `DATE_CONSTRUCTED` char(10) DEFAULT NULL,
  `DATE_DISMANTLED` char(10) DEFAULT NULL,
  `DATE_ACTION` char(10) DEFAULT NULL,
  `ARCHIVE_FLAG_CODE` char(1) DEFAULT NULL,
  `VERSION` int(11) DEFAULT NULL,
  `SIGNATURE_FIRST_NAME` varchar(20) DEFAULT NULL,
  `SIGNATURE_MIDDLE_INITIAL` char(1) DEFAULT NULL,
  `SIGNATURE_LAST_NAME` varchar(20) DEFAULT NULL,
  `SIGNATURE_SUFFIX` varchar(3) DEFAULT NULL,
  `SIGNATURE_TITLE` varchar(40) DEFAULT NULL,
  `INVALID_SIGNATURE` char(1) DEFAULT NULL,
  `STRUCTURE_STREET_ADDRESS` varchar(80) DEFAULT NULL,
  `STRUCTURE_CITY` varchar(20) DEFAULT NULL,
  `STRUCTURE_STATE_CODE` char(2) DEFAULT NULL,
  `COUNTY_CODE` char(5) DEFAULT NULL,
  `ZIP_CODE` varchar(9) DEFAULT NULL,
  `HEIGHT_OF_STRUCTURE` decimal(5,1) DEFAULT NULL,
  `GROUND_ELEVATION` decimal(6,1) DEFAULT NULL,
  `OVERALL_HEIGHT_ABOVE_GROUND` decimal(6,1) DEFAULT NULL,
  `OVERALL_HEIGHT_AMSL` decimal(6,1) DEFAULT NULL,
  `STRUCTURE_TYPE` char(7) DEFAULT NULL,
  `DATE_FAA_DETERMINATION_ISSUED` char(10) DEFAULT NULL,
  `FAA_STUDY_NUMBER` varchar(20) DEFAULT NULL,
  `FAA_CIRCULAR_NUMBER` varchar(10) DEFAULT NULL,
  `SPECIFICATION_OPTION` int(11) DEFAULT NULL,
  `PAINTING_AND_LIGHTING` varchar(100) DEFAULT NULL,
  `MARK_LIGHT_CODE` varchar(2) DEFAULT NULL,
  `MARK_LIGHT_OTHER` varchar(30) DEFAULT NULL,
  `FAA_EMI_FLAG` char(1) DEFAULT NULL,
  `NEPA_FLAG` char(1) DEFAULT NULL,
  PRIMARY KEY (`UNIQUE_SYSTEM_IDENTIFIER`,`REGISTRATION_NUMBER`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `TOWER_PUBACC_RE` (
  `record_type` char(2) DEFAULT NULL,
  `content_indicator` char(3) DEFAULT NULL,
  `file_number` char(8) DEFAULT NULL,
  `registration_number` char(7) DEFAULT NULL,
  `unique_system_identifier` decimal(9,0) NOT NULL,
  `remark_type` char(3) NOT NULL,
  `date_keyed` char(10) DEFAULT NULL,
  `sequence_number` int(11) NOT NULL,
  `remark_text` varchar(255) NOT NULL,
  PRIMARY KEY (`unique_system_identifier`,`remark_text`,`sequence_number`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `TOWER_PUBACC_SC` (
  `record_type` char(2) DEFAULT NULL,
  `content_indicator` char(3) DEFAULT NULL,
  `file_number` char(8) DEFAULT NULL,
  `registration_number` char(7) DEFAULT NULL,
  `unique_system_identifier` decimal(9,0) NOT NULL,
  `date_keyed` char(10) DEFAULT NULL,
  `sequence_number` int(11) DEFAULT NULL,
  `remark_text` varchar(255) DEFAULT NULL,
  KEY `unique_system_identifier` (`unique_system_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `zipcodes` (
  `zip` int(5) NOT NULL,
  `rec_type` varchar(15) DEFAULT NULL,
  `primary_city` varchar(64) DEFAULT NULL,
  `acceptable_cities` varchar(255) DEFAULT NULL,
  `unacceptable_cities` varchar(255) DEFAULT NULL,
  `state` varchar(2) DEFAULT NULL,
  `county` varchar(64) NOT NULL,
  `timezone` varchar(64) DEFAULT NULL,
  `area_codes` varchar(64) NOT NULL,
  `latitude` decimal(10,0) NOT NULL,
  `longitude` decimal(10,0) NOT NULL,
  `world_region` varchar(2) DEFAULT NULL,
  `country` varchar(2) DEFAULT NULL,
  `ecommissioned` tinyint(1) DEFAULT NULL,
  `estimated_population` int(10) unsigned DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`zip`,`county`,`area_codes`,`latitude`,`longitude`),
  UNIQUE KEY `zip` (`zip`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
