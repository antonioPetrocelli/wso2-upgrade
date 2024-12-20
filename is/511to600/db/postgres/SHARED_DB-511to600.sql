-- Attenzione: verificare la sintassi per ADD, ALTER e DROP CONSTRAINT

ALTER TABLE REG_LOG ALTER COLUMN REG_USER_ID VARCHAR (255) NOT NULL;
ALTER TABLE REG_RESOURCE ALTER COLUMN REG_CREATOR VARCHAR(255) NOT NULL;
ALTER TABLE REG_RESOURCE ALTER COLUMN REG_LAST_UPDATOR VARCHAR(255);
ALTER TABLE REG_RESOURCE_HISTORY ALTER COLUMN REG_CREATOR VARCHAR(255) NOT NULL;
ALTER TABLE REG_RESOURCE_HISTORY ALTER COLUMN REG_LAST_UPDATOR VARCHAR(255);

ALTER TABLE REG_COMMENT ALTER COLUMN REG_USER_ID VARCHAR(255) NOT NULL;
DROP SEQUENCE IF EXISTS REG_RESOURCE_COMMENT_PK_SEQ;
CREATE SEQUENCE REG_RESOURCE_COMMENT_PK_SEQ;
ALTER TABLE REG_RESOURCE_COMMENT ADD COLUMN ID INTEGER DEFAULT NEXTVAL('REG_RESOURCE_COMMENT_PK_SEQ');
ALTER TABLE REG_RESOURCE_COMMENT ADD CONSTRAINT PRIMARY KEY(ID);
ALTER TABLE REG_RATING ALTER COLUMN REG_USER_ID VARCHAR(255) NOT NULL;
DROP SEQUENCE IF EXISTS REG_RESOURCE_RATING_PK_SEQ;
CREATE SEQUENCE REG_RESOURCE_RATING_PK_SEQ;
ALTER TABLE REG_RESOURCE_RATING ADD COLUMN ID INTEGER DEFAULT NEXTVAL('REG_RESOURCE_RATING_PK_SEQ');
ALTER TABLE REG_RESOURCE_RATING ADD CONSTRAINT PRIMARY KEY(ID);
	
ALTER TABLE REG_TAG ALTER COLUMN REG_USER_ID VARCHAR(255) NOT NULL;
DROP SEQUENCE IF EXISTS REG_RESOURCE_TAG_PK_SEQ;
CREATE SEQUENCE REG_RESOURCE_TAG_PK_SEQ;
ALTER TABLE REG_RESOURCE_TAG ADD COLUMN ID INTEGER DEFAULT NEXTVAL('REG_RESOURCE_TAG_PK_SEQ');
ALTER TABLE REG_RESOURCE_TAG ADD CONSTRAINT PRIMARY KEY(ID);
DROP SEQUENCE IF EXISTS REG_RESOURCE_PROPERTY_PK_SEQ;
CREATE SEQUENCE REG_RESOURCE_PROPERTY_PK_SEQ;
ALTER TABLE REG_RESOURCE_PROPERTY ADD COLUMN ID INTEGER DEFAULT NEXTVAL('REG_RESOURCE_PROPERTY_PK_SEQ');
ALTER TABLE REG_RESOURCE_PROPERTY ADD CONSTRAINT PRIMARY KEY(ID);
ALTER TABLE UM_TENANT ALTER COLUMN UM_ORG_UUID VARCHAR(36) DEFAULT NULL;
	
ALTER TABLE UM_USER DROP CONSTRAINT UNIQUE(UM_USER_ID, UM_TENANT_ID);
ALTER TABLE UM_USER ADD CONSTRAINT UNIQUE(UM_USER_ID);
ALTER TABLE UM_USER ADD CONSTRAINT UNIQUE(UM_USER_NAME, UM_TENANT_ID);
CREATE UNIQUE INDEX INDEX_UM_USERNAME_UM_TENANT_ID ON UM_USER(UM_USER_NAME, UM_TENANT_ID);
DROP SEQUENCE IF EXISTS UM_SHARED_USER_ROLE_PK_SEQ;
CREATE SEQUENCE UM_SHARED_USER_ROLE_PK_SEQ;
ALTER TABLE UM_SHARED_USER_ROLE ADD COLUMN ID INTEGER DEFAULT NEXTVAL('UM_SHARED_USER_ROLE_PK_SEQ');
ALTER TABLE UM_SHARED_USER_ROLE ADD CONSTRAINT PRIMARY KEY(ID);
DROP TABLE IF EXISTS UM_GROUP_UUID_DOMAIN_MAPPER;
DROP SEQUENCE IF EXISTS UM_GROUP_UUID_DOMAIN_MAPPER_PK_SEQ;
CREATE SEQUENCE UM_GROUP_UUID_DOMAIN_MAPPER_PK_SEQ;
CREATE TABLE IF NOT EXISTS UM_GROUP_UUID_DOMAIN_MAPPER (
			UM_ID INTEGER DEFAULT NEXTVAL('UM_HYBRID_REMEMBER_ME_PK_SEQ'),
			UM_GROUP_ID VARCHAR(255) NOT NULL,
			UM_DOMAIN_ID INTEGER NOT NULL,
			UM_TENANT_ID INTEGER DEFAULT 0,
			PRIMARY KEY (UM_ID),
			UNIQUE (UM_GROUP_ID),
			FOREIGN KEY (UM_DOMAIN_ID, UM_TENANT_ID) REFERENCES UM_DOMAIN(UM_DOMAIN_ID, UM_TENANT_ID) ON DELETE CASCADE
);

CREATE INDEX UUID_GRP_UID_TID ON UM_GROUP_UUID_DOMAIN_MAPPER(UM_GROUP_ID, UM_TENANT_ID);

-- ################################
-- ORGANIZATION MANAGEMENT TABLES
-- ################################

DROP TABLE IF EXISTS UM_ORG;
CREATE TABLE UM_ORG (
			UM_ID VARCHAR(36) NOT NULL,
			UM_ORG_NAME VARCHAR(255) NOT NULL,
			UM_ORG_DESCRIPTION VARCHAR(1024),
			UM_CREATED_TIME TIMESTAMP NOT NULL,
			UM_LAST_MODIFIED TIMESTAMP NOT NULL,
			UM_STATUS VARCHAR(255) DEFAULT 'ACTIVE' NOT NULL,
			UM_PARENT_ID VARCHAR(36),
			UM_ORG_TYPE VARCHAR(100) NOT NULL,
			PRIMARY KEY (UM_ID),
			FOREIGN KEY (UM_PARENT_ID) REFERENCES UM_ORG(UM_ID) ON DELETE CASCADE
);

INSERT INTO UM_ORG (UM_ID, UM_ORG_NAME, UM_ORG_DESCRIPTION, UM_CREATED_TIME, UM_LAST_MODIFIED, UM_STATUS, UM_ORG_TYPE)
VALUES ('10084a8d-113f-4211-a0d5-efe36b082211', 'Super', 'This is the super organization.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'ACTIVE', 'TENANT')
ON CONFLICT DO NOTHING;

DROP TABLE IF EXISTS UM_ORG_ATTRIBUTE;
DROP SEQUENCE IF EXISTS UM_ORG_ATTRIBUTE_PK_SEQ;
CREATE SEQUENCE UM_ORG_ATTRIBUTE_PK_SEQ;
CREATE TABLE UM_ORG_ATTRIBUTE (
			UM_ID INTEGER DEFAULT NEXTVAL('UM_ORG_ATTRIBUTE_PK_SEQ'),
			UM_ORG_ID VARCHAR(36) NOT NULL,
			UM_ATTRIBUTE_KEY VARCHAR(255) NOT NULL,
			UM_ATTRIBUTE_VALUE VARCHAR(512),
			PRIMARY KEY (UM_ID),
			UNIQUE (UM_ORG_ID, UM_ATTRIBUTE_KEY),
			FOREIGN KEY (UM_ORG_ID) REFERENCES UM_ORG(UM_ID) ON DELETE CASCADE
);

DROP TABLE IF EXISTS UM_ORG_ROLE;
CREATE TABLE UM_ORG_ROLE (
			UM_ROLE_ID VARCHAR(255) NOT NULL,
			UM_ROLE_NAME VARCHAR(255) NOT NULL,
			UM_ORG_ID VARCHAR(36) NOT NULL,
			PRIMARY KEY(UM_ROLE_ID),
			CONSTRAINT FK_UM_ORG_ROLE_UM_ORG FOREIGN KEY (UM_ORG_ID) REFERENCES UM_ORG (UM_ID) ON DELETE CASCADE
);

DROP TABLE IF EXISTS UM_ORG_PERMISSION;
DROP SEQUENCE IF EXISTS UM_ORG_PERMISSION_PK_SEQ;
CREATE SEQUENCE UM_ORG_PERMISSION_PK_SEQ;
CREATE TABLE UM_ORG_PERMISSION(
			UM_ID INTEGER DEFAULT NEXTVAL('UM_ORG_PERMISSION_PK_SEQ'),
			UM_RESOURCE_ID VARCHAR(255) NOT NULL,
			UM_ACTION VARCHAR(255) NOT NULL,
			UM_TENANT_ID INTEGER DEFAULT 0,
			PRIMARY KEY(UM_ID)
);

DROP TABLE IF EXISTS UM_ORG_ROLE_USER;
CREATE TABLE UM_ORG_ROLE_USER (
			UM_USER_ID VARCHAR(255) NOT NULL,
			UM_ROLE_ID VARCHAR(255) NOT NULL,
			CONSTRAINT FK_UM_ORG_ROLE_USER_UM_ORG_ROLE FOREIGN KEY (UM_ROLE_ID) REFERENCES UM_ORG_ROLE(UM_ROLE_ID) ON DELETE CASCADE
);

DROP TABLE IF EXISTS UM_ORG_ROLE_GROUP;
CREATE TABLE UM_ORG_ROLE_GROUP(
			UM_GROUP_ID VARCHAR(255) NOT NULL,
			UM_ROLE_ID VARCHAR(255) NOT NULL,
			CONSTRAINT FK_UM_ORG_ROLE_GROUP_UM_ORG_ROLE FOREIGN KEY (UM_ROLE_ID) REFERENCES UM_ORG_ROLE(UM_ROLE_ID) ON DELETE CASCADE
);

DROP TABLE IF EXISTS UM_ORG_ROLE_PERMISSION;
CREATE TABLE UM_ORG_ROLE_PERMISSION(
			UM_PERMISSION_ID INTEGER NOT NULL,
			UM_ROLE_ID VARCHAR(255) NOT NULL,
			CONSTRAINT FK_UM_ORG_ROLE_PERMISSION_UM_ORG_ROLE FOREIGN KEY (UM_ROLE_ID) REFERENCES UM_ORG_ROLE(UM_ROLE_ID) ON DELETE CASCADE,
			CONSTRAINT FK_UM_ORG_ROLE_PERMISSION_UM_ORG_PERMISSION FOREIGN KEY (UM_PERMISSION_ID) REFERENCES UM_ORG_PERMISSION(UM_ID) ON DELETE CASCADE
);

DROP TABLE IF EXISTS UM_ORG_HIERARCHY;
CREATE TABLE UM_ORG_HIERARCHY (
			UM_PARENT_ID VARCHAR(36) NOT NULL,
			UM_ID VARCHAR(36) NOT NULL,
			DEPTH INTEGER,
			PRIMARY KEY (UM_PARENT_ID, UM_ID),
			FOREIGN KEY (UM_PARENT_ID) REFERENCES UM_ORG(UM_ID) ON DELETE CASCADE,
			FOREIGN KEY (UM_ID) REFERENCES UM_ORG(UM_ID) ON DELETE CASCADE
);

INSERT INTO UM_ORG_HIERARCHY (UM_PARENT_ID, UM_ID, DEPTH)
VALUES ('10084a8d-113f-4211-a0d5-efe36b082211', '10084a8d-113f-4211-a0d5-efe36b082211', 0)
ON CONFLICT DO NOTHING;	
