CREATE TABLE IF NOT EXISTS DM_DEVICE_TYPE (
     ID   INT auto_increment NOT NULL,
     NAME VARCHAR(300) DEFAULT NULL,
     PRIMARY KEY (ID)
);

CREATE TABLE IF NOT EXISTS DM_GROUP (
  ID                  INTEGER AUTO_INCREMENT NOT NULL,
  GROUP_NAME          VARCHAR(100) DEFAULT NULL,
  DESCRIPTION         TEXT         DEFAULT NULL,
  DATE_OF_CREATE      BIGINT       DEFAULT NULL,
  DATE_OF_LAST_UPDATE BIGINT       DEFAULT NULL,
  OWNER               VARCHAR(45)  DEFAULT NULL,
  TENANT_ID           INTEGER      DEFAULT 0,
  PRIMARY KEY (ID)
);

CREATE TABLE IF NOT EXISTS DM_DEVICE_CERTIFICATE (
      ID                    INTEGER auto_increment NOT NULL,
      SERIAL_NUMBER            VARCHAR(500) DEFAULT NULL,
    	CERTIFICATE                  BLOB DEFAULT NULL,
    	TENANT_ID INTEGER DEFAULT 0,
    	PRIMARY KEY (ID)
);

CREATE TABLE IF NOT EXISTS DM_DEVICE (
     ID                    INTEGER auto_increment NOT NULL,
     DESCRIPTION           TEXT DEFAULT NULL,
     NAME                  VARCHAR(100) DEFAULT NULL,
     DEVICE_TYPE_ID        INT(11) DEFAULT NULL,
     DEVICE_IDENTIFICATION VARCHAR(300) DEFAULT NULL,
     TENANT_ID INTEGER DEFAULT 0,
     PRIMARY KEY (ID),
     CONSTRAINT fk_DM_DEVICE_DM_DEVICE_TYPE2 FOREIGN KEY (DEVICE_TYPE_ID )
     REFERENCES DM_DEVICE_TYPE (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS DM_DEVICE_GROUP_MAP (
  ID        INTEGER AUTO_INCREMENT NOT NULL,
  DEVICE_ID INTEGER DEFAULT NULL,
  GROUP_ID  INTEGER DEFAULT NULL,
  TENANT_ID INTEGER DEFAULT 0,
  PRIMARY KEY (ID),
  CONSTRAINT fk_DM_DEVICE_GROUP_MAP_DM_DEVICE2 FOREIGN KEY (DEVICE_ID)
  REFERENCES DM_DEVICE (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT fk_DM_DEVICE_GROUP_MAP_DM_GROUP2 FOREIGN KEY (GROUP_ID)
  REFERENCES DM_GROUP (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS DM_OPERATION (
    ID INTEGER AUTO_INCREMENT NOT NULL,
    TYPE VARCHAR(50) NOT NULL,
    CREATED_TIMESTAMP TIMESTAMP NOT NULL,
    RECEIVED_TIMESTAMP TIMESTAMP NULL,
    OPERATION_CODE VARCHAR(1000) NOT NULL,
    PRIMARY KEY (ID)
);

CREATE TABLE IF NOT EXISTS DM_CONFIG_OPERATION (
    OPERATION_ID INTEGER NOT NULL,
    OPERATION_CONFIG  BLOB DEFAULT NULL,
    PRIMARY KEY (OPERATION_ID),
    CONSTRAINT fk_dm_operation_config FOREIGN KEY (OPERATION_ID) REFERENCES
    DM_OPERATION (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS DM_COMMAND_OPERATION (
    OPERATION_ID INTEGER NOT NULL,
    ENABLED BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (OPERATION_ID),
    CONSTRAINT fk_dm_operation_command FOREIGN KEY (OPERATION_ID) REFERENCES
    DM_OPERATION (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS DM_POLICY_OPERATION (
    OPERATION_ID INTEGER NOT NULL,
    ENABLED INTEGER NOT NULL DEFAULT 0,
    OPERATION_DETAILS BLOB DEFAULT NULL,
    PRIMARY KEY (OPERATION_ID),
    CONSTRAINT fk_dm_operation_policy FOREIGN KEY (OPERATION_ID) REFERENCES
    DM_OPERATION (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS DM_PROFILE_OPERATION (
    OPERATION_ID INTEGER NOT NULL,
    ENABLED INTEGER NOT NULL DEFAULT 0,
    OPERATION_DETAILS BLOB DEFAULT NULL,
    PRIMARY KEY (OPERATION_ID),
    CONSTRAINT fk_dm_operation_profile FOREIGN KEY (OPERATION_ID) REFERENCES
    DM_OPERATION (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS DM_ENROLMENT (
    ID INTEGER AUTO_INCREMENT NOT NULL,
    DEVICE_ID INTEGER NOT NULL,
    OWNER VARCHAR(50) NOT NULL,
    OWNERSHIP VARCHAR(45) DEFAULT NULL,
    STATUS VARCHAR(50) NULL,
    DATE_OF_ENROLMENT TIMESTAMP DEFAULT NULL,
    DATE_OF_LAST_UPDATE TIMESTAMP DEFAULT NULL,
    TENANT_ID INT NOT NULL,
    PRIMARY KEY (ID),
    CONSTRAINT fk_dm_device_enrolment FOREIGN KEY (DEVICE_ID) REFERENCES
    DM_DEVICE (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS DM_ENROLMENT_OP_MAPPING (
    ID INTEGER AUTO_INCREMENT NOT NULL,
    ENROLMENT_ID INTEGER NOT NULL,
    OPERATION_ID INTEGER NOT NULL,
    STATUS VARCHAR(50) NULL,
    PRIMARY KEY (ID),
    CONSTRAINT fk_dm_device_operation_mapping_device FOREIGN KEY (ENROLMENT_ID) REFERENCES
    DM_ENROLMENT (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_dm_device_operation_mapping_operation FOREIGN KEY (OPERATION_ID) REFERENCES
    DM_OPERATION (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS DM_DEVICE_OPERATION_RESPONSE (
    ID INTEGER AUTO_INCREMENT NOT NULL,
    ENROLMENT_ID INTEGER NOT NULL,
    OPERATION_ID INTEGER NOT NULL,
    OPERATION_RESPONSE BLOB DEFAULT NULL,
    PRIMARY KEY (ID),
    CONSTRAINT fk_dm_device_operation_response_enrollment FOREIGN KEY (ENROLMENT_ID) REFERENCES
    DM_ENROLMENT (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_dm_device_operation_response_operation FOREIGN KEY (OPERATION_ID) REFERENCES
    DM_OPERATION (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- POLICY RELATED TABLES --

CREATE  TABLE IF NOT EXISTS DM_PROFILE (
  ID INT NOT NULL AUTO_INCREMENT ,
  PROFILE_NAME VARCHAR(45) NOT NULL ,
  TENANT_ID INT NOT NULL ,
  DEVICE_TYPE_ID INT NOT NULL ,
  CREATED_TIME DATETIME NOT NULL ,
  UPDATED_TIME DATETIME NOT NULL ,
  PRIMARY KEY (ID) ,
  CONSTRAINT DM_PROFILE_DEVICE_TYPE
    FOREIGN KEY (DEVICE_TYPE_ID )
    REFERENCES DM_DEVICE_TYPE (ID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);





CREATE  TABLE IF NOT EXISTS DM_POLICY (
  ID INT(11) NOT NULL AUTO_INCREMENT ,
  NAME VARCHAR(45) DEFAULT NULL ,
  DESCRIPTION VARCHAR(1000) NULL,
  TENANT_ID INT(11) NOT NULL ,
  PROFILE_ID INT(11) NOT NULL ,
  OWNERSHIP_TYPE VARCHAR(45) NULL,
  COMPLIANCE VARCHAR(100) NULL,
  PRIORITY INT NOT NULL,
  ACTIVE INT(2) NOT NULL,
  UPDATED INT(1) NULL,
  PRIMARY KEY (ID) ,
  CONSTRAINT FK_DM_PROFILE_DM_POLICY
    FOREIGN KEY (PROFILE_ID )
    REFERENCES DM_PROFILE (ID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);




CREATE  TABLE IF NOT EXISTS DM_DEVICE_POLICY (
  ID INT(11) NOT NULL AUTO_INCREMENT ,
  DEVICE_ID INT(11) NOT NULL ,
  ENROLMENT_ID INT(11) NOT NULL,
  DEVICE BLOB NOT NULL,
  POLICY_ID INT(11) NOT NULL ,
  PRIMARY KEY (ID) ,
  CONSTRAINT FK_POLICY_DEVICE_POLICY
    FOREIGN KEY (POLICY_ID )
    REFERENCES DM_POLICY (ID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT FK_DEVICE_DEVICE_POLICY
    FOREIGN KEY (DEVICE_ID )
    REFERENCES DM_DEVICE (ID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);




CREATE  TABLE IF NOT EXISTS DM_DEVICE_TYPE_POLICY (
  ID INT(11) NOT NULL ,
  DEVICE_TYPE_ID INT(11) NOT NULL ,
  POLICY_ID INT(11) NOT NULL ,
  PRIMARY KEY (ID) ,
  CONSTRAINT FK_DEVICE_TYPE_POLICY
    FOREIGN KEY (POLICY_ID )
    REFERENCES DM_POLICY (ID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT FK_DEVICE_TYPE_POLICY_DEVICE_TYPE
    FOREIGN KEY (DEVICE_TYPE_ID )
    REFERENCES DM_DEVICE_TYPE (ID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);





CREATE  TABLE IF NOT EXISTS DM_PROFILE_FEATURES (
  ID INT(11) NOT NULL AUTO_INCREMENT,
  PROFILE_ID INT(11) NOT NULL,
  FEATURE_CODE VARCHAR(100) NOT NULL,
  DEVICE_TYPE_ID INT NOT NULL,
  TENANT_ID INT(11) NOT NULL ,
  CONTENT BLOB NULL DEFAULT NULL,
  PRIMARY KEY (ID),
  CONSTRAINT FK_DM_PROFILE_DM_POLICY_FEATURES
    FOREIGN KEY (PROFILE_ID)
    REFERENCES DM_PROFILE (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);




CREATE  TABLE IF NOT EXISTS DM_ROLE_POLICY (
  ID INT(11) NOT NULL AUTO_INCREMENT ,
  ROLE_NAME VARCHAR(45) NOT NULL ,
  POLICY_ID INT(11) NOT NULL ,
  PRIMARY KEY (ID) ,
  CONSTRAINT FK_ROLE_POLICY_POLICY
    FOREIGN KEY (POLICY_ID )
    REFERENCES DM_POLICY (ID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);




CREATE  TABLE IF NOT EXISTS DM_USER_POLICY (
  ID INT NOT NULL AUTO_INCREMENT ,
  POLICY_ID INT NOT NULL ,
  USERNAME VARCHAR(45) NOT NULL ,
  PRIMARY KEY (ID) ,
  CONSTRAINT DM_POLICY_USER_POLICY
    FOREIGN KEY (POLICY_ID )
    REFERENCES DM_POLICY (ID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


 CREATE  TABLE IF NOT EXISTS DM_DEVICE_POLICY_APPLIED (
  ID INT NOT NULL AUTO_INCREMENT ,
  DEVICE_ID INT NOT NULL ,
  ENROLMENT_ID INT(11) NOT NULL,
  POLICY_ID INT NOT NULL ,
  POLICY_CONTENT BLOB NULL ,
  TENANT_ID INT NOT NULL,
  APPLIED TINYINT(1) NULL ,
  CREATED_TIME TIMESTAMP NULL ,
  UPDATED_TIME TIMESTAMP NULL ,
  APPLIED_TIME TIMESTAMP NULL ,
  PRIMARY KEY (ID) ,
  CONSTRAINT FK_DM_POLICY_DEVCIE_APPLIED
    FOREIGN KEY (DEVICE_ID )
    REFERENCES DM_DEVICE (ID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);



CREATE TABLE IF NOT EXISTS DM_CRITERIA (
  ID INT NOT NULL AUTO_INCREMENT,
  TENANT_ID INT NOT NULL,
  NAME VARCHAR(50) NULL,
  PRIMARY KEY (ID)
);



CREATE TABLE IF NOT EXISTS DM_POLICY_CRITERIA (
  ID INT NOT NULL AUTO_INCREMENT,
  CRITERIA_ID INT NOT NULL,
  POLICY_ID INT NOT NULL,
  PRIMARY KEY (ID),
  CONSTRAINT FK_CRITERIA_POLICY_CRITERIA
    FOREIGN KEY (CRITERIA_ID)
    REFERENCES DM_CRITERIA (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT FK_POLICY_POLICY_CRITERIA
    FOREIGN KEY (POLICY_ID)
    REFERENCES DM_POLICY (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS DM_POLICY_CRITERIA_PROPERTIES (
  ID INT NOT NULL AUTO_INCREMENT,
  POLICY_CRITERION_ID INT NOT NULL,
  PROP_KEY VARCHAR(45) NULL,
  PROP_VALUE VARCHAR(100) NULL,
  CONTENT BLOB NULL COMMENT 'This is used to ',
  PRIMARY KEY (ID),
  CONSTRAINT FK_POLICY_CRITERIA_PROPERTIES
    FOREIGN KEY (POLICY_CRITERION_ID)
    REFERENCES DM_POLICY_CRITERIA (ID)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS DM_POLICY_COMPLIANCE_STATUS (
  ID INT NOT NULL AUTO_INCREMENT,
  DEVICE_ID INT NOT NULL,
  ENROLMENT_ID INT(11) NOT NULL,
  POLICY_ID INT NOT NULL,
  TENANT_ID INT NOT NULL,
  STATUS INT NULL,
  LAST_SUCCESS_TIME TIMESTAMP NULL,
  LAST_REQUESTED_TIME TIMESTAMP NULL,
  LAST_FAILED_TIME TIMESTAMP NULL,
  ATTEMPTS INT NULL,
  PRIMARY KEY (ID)
);


CREATE TABLE IF NOT EXISTS DM_POLICY_CHANGE_MGT (
  ID INT NOT NULL AUTO_INCREMENT,
  POLICY_ID INT NOT NULL,
  DEVICE_TYPE_ID INT NOT NULL,
  TENANT_ID INT(11) NOT NULL,
  PRIMARY KEY (ID)
);


CREATE TABLE IF NOT EXISTS DM_POLICY_COMPLIANCE_FEATURES (
  ID INT NOT NULL AUTO_INCREMENT,
  COMPLIANCE_STATUS_ID INT NOT NULL,
  TENANT_ID INT NOT NULL,
  FEATURE_CODE VARCHAR(100) NOT NULL,
  STATUS INT NULL,
  PRIMARY KEY (ID),
  CONSTRAINT FK_COMPLIANCE_FEATURES_STATUS
    FOREIGN KEY (COMPLIANCE_STATUS_ID)
    REFERENCES DM_POLICY_COMPLIANCE_STATUS (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS DM_ENROLMENT (
    ID INTEGER AUTO_INCREMENT NOT NULL,
    DEVICE_ID INTEGER NOT NULL,
    OWNER VARCHAR(50) NOT NULL,
    OWNERSHIP VARCHAR(45) DEFAULT NULL,
    STATUS VARCHAR(50) NULL,
    DATE_OF_ENROLMENT TIMESTAMP DEFAULT NULL,
    DATE_OF_LAST_UPDATE TIMESTAMP DEFAULT NULL,
    TENANT_ID INT NOT NULL,
    PRIMARY KEY (ID),
    CONSTRAINT fk_dm_device_enrolment FOREIGN KEY (DEVICE_ID) REFERENCES
    DM_DEVICE (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS DM_APPLICATION (
    ID INTEGER AUTO_INCREMENT NOT NULL,
    NAME VARCHAR(150) NOT NULL,
    APP_IDENTIFIER VARCHAR(150) NOT NULL,
    PLATFORM VARCHAR(50) DEFAULT NULL,
    CATEGORY VARCHAR(50) NULL,
    VERSION VARCHAR(50) NULL,
    TYPE VARCHAR(50) NULL,
    LOCATION_URL VARCHAR(100) DEFAULT NULL,
    IMAGE_URL VARCHAR(100) DEFAULT NULL,
    APP_PROPERTIES BLOB NULL,
    MEMORY_USAGE INTEGER(10) NULL,
    TENANT_ID INTEGER NOT NULL,
    PRIMARY KEY (ID)
);

CREATE TABLE IF NOT EXISTS DM_DEVICE_APPLICATION_MAPPING (
    ID INTEGER AUTO_INCREMENT NOT NULL,
    DEVICE_ID INTEGER NOT NULL,
    APPLICATION_ID INTEGER NOT NULL,
    TENANT_ID INTEGER NOT NULL,
    PRIMARY KEY (ID),
    CONSTRAINT fk_dm_device FOREIGN KEY (DEVICE_ID) REFERENCES
    DM_DEVICE (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_dm_application FOREIGN KEY (APPLICATION_ID) REFERENCES
    DM_APPLICATION (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- POLICY RELATED TABLES  FINISHED --

-- NOTIFICATION TABLE --
CREATE TABLE IF NOT EXISTS DM_NOTIFICATION (
    NOTIFICATION_ID INTEGER AUTO_INCREMENT NOT NULL,
    DEVICE_ID INTEGER NOT NULL,
    OPERATION_ID INTEGER NOT NULL,
    TENANT_ID INTEGER NOT NULL,
    STATUS VARCHAR(10) NULL,
    DESCRIPTION VARCHAR(100) NULL,
    PRIMARY KEY (NOTIFICATION_ID),
    CONSTRAINT fk_dm_device_notification FOREIGN KEY (DEVICE_ID) REFERENCES
    DM_DEVICE (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_dm_operation_notification FOREIGN KEY (OPERATION_ID) REFERENCES
    DM_OPERATION (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);
-- NOTIFICATION TABLE END --

DROP TABLE IF EXISTS DM_DEVICE_INFO;

CREATE TABLE IF NOT EXISTS DM_DEVICE_INFO (
  ID INTEGER AUTO_INCREMENT NOT NULL,
  DEVICE_ID INT NULL,
  KEY_FIELD VARCHAR(45) NULL,
  VALUE_FIELD VARCHAR(100) NULL,
  PRIMARY KEY (ID),
  CONSTRAINT DM_DEVICE_INFO_DEVICE
    FOREIGN KEY (DEVICE_ID)
    REFERENCES DM_DEVICE (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);



DROP TABLE IF EXISTS DM_DEVICE_LOCATION;

CREATE TABLE IF NOT EXISTS DM_DEVICE_LOCATION (
  ID INTEGER AUTO_INCREMENT NOT NULL,
  DEVICE_ID INT NULL,
  LATITUDE DOUBLE NULL,
  LONGITUDE DOUBLE NULL,
  STREET1 VARCHAR(45) NULL,
  STREET2 VARCHAR(45) NULL,
  CITY VARCHAR(45) NULL,
  ZIP VARCHAR(10) NULL,
  STATE VARCHAR(45) NULL,
  COUNTRY VARCHAR(45) NULL,
  PRIMARY KEY (ID),
  CONSTRAINT DM_DEVICE_LOCATION_DEVICE
    FOREIGN KEY (DEVICE_ID)
    REFERENCES DM_DEVICE (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


CREATE TABLE IF NOT EXISTS DM_DEVICE_DETAIL (
  ID INT NOT NULL AUTO_INCREMENT,
  DEVICE_ID INT NOT NULL,
  IMEI VARCHAR(100) NULL,
  IMSI VARCHAR(100) NULL,
  DEVICE_MODEL VARCHAR(45) NULL,
  VENDOR VARCHAR(45) NULL,
  OS_VERSION VARCHAR(45) NULL,
  BATTERY_LEVEL DECIMAL(4) NULL,
  INTERNAL_TOTAL_MEMORY DECIMAL(5) NULL,
  INTERNAL_AVAILABLE_MEMORY DECIMAL(5) NULL,
  EXTERNAL_TOTAL_MEMORY DECIMAL(5) NULL,
  EXTERNAL_AVAILABLE_MEMORY DECIMAL(5) NULL,
  OPERATOR VARCHAR(45) NULL,
  CONNECTION_TYPE VARCHAR(10) NULL,
  MOBILE_SIGNAL_STRENGTH DECIMAL(5) NULL,
  SSID VARCHAR(45) NULL,
  CPU_USAGE DECIMAL(5) NULL,
  TOTAL_RAM_MEMORY DECIMAL(5) NULL,
  AVAILABLE_RAM_MEMORY DECIMAL(5) NULL,
  PLUGGED_IN INT(1) NULL,
  PRIMARY KEY (ID),
  CONSTRAINT FK_DM_DEVICE_DETAILS_DEVICE
    FOREIGN KEY (DEVICE_ID)
    REFERENCES DM_DEVICE (ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);
