-- Attenzione: verificare la sintassi per ADD, ALTER e DROP CONSTRAINT
ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN ADD COLUMN CONSENTED_TOKEN VARCHAR(6);
ALTER TABLE IDN_OAUTH2_TOKEN_BINDING DROP PRIMARY KEY (TOKEN_ID);
ALTER TABLE IDN_OAUTH2_TOKEN_BINDING ADD CONSTRAINT UNIQUE(TOKEN_ID,TOKEN_BINDING_TYPE,TOKEN_BINDING_VALUE);
DROP SEQUENCE IF EXISTS IDN_OAUTH2_ACCESS_TOKEN_AUDIT_PK_SEQ;
CREATE SEQUENCE IDN_OAUTH2_ACCESS_TOKEN_AUDIT_PK_SEQ;

ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN_AUDIT ADD COLUMN ID INTEGER DEFAULT NEXTVAL('IDN_OAUTH2_ACCESS_TOKEN_AUDIT_PK_SEQ');
ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN_AUDIT ADD CONSTRAINT PRIMARY KEY(ID);

ALTER TABLE IDN_OAUTH2_DEVICE_FLOW ADD COLUMN QUANTIFIER INTEGER NOT NULL DEFAULT 0;
ALTER TABLE IDN_OAUTH2_DEVICE_FLOW DROP CONSTRAINT UNIQUE (USER_CODE);
ALTER TABLE IDN_OAUTH2_DEVICE_FLOW ADD CONSTRAINT USRCDE_QNTFR_CONSTRAINT UNIQUE (USER_CODE, QUANTIFIER);

DROP SEQUENCE IF EXISTS IDN_OAUTH2_SCOPE_BINDING_PK_SEQ;
CREATE SEQUENCE IDN_OAUTH2_SCOPE_BINDING_PK_SEQ;
ALTER TABLE IDN_OAUTH2_SCOPE_BINDING ADD COLUMN ID INTEGER DEFAULT NEXTVAL('IDN_OAUTH2_SCOPE_BINDING_PK_SEQ');
ALTER TABLE IDN_OAUTH2_SCOPE_BINDING ADD CONSTRAINT PRIMARY KEY(ID);
ALTER TABLE IDN_SCIM_GROUP ADD CONSTRAINT UNIQUE(TENANT_ID, ROLE_NAME, ATTR_NAME);

DROP SEQUENCE IF EXISTS IDN_AUTH_USER_SESSION_MAPPING_PK_SEQ;
CREATE SEQUENCE IDN_AUTH_USER_SESSION_MAPPING_PK_SEQ;
ALTER TABLE IDN_AUTH_USER_SESSION_MAPPING ADD COLUMN ID INTEGER DEFAULT NEXTVAL('IDN_AUTH_USER_SESSION_MAPPING_PK_SEQ');
ALTER TABLE IDN_AUTH_USER_SESSION_MAPPING ADD CONSTRAINT PRIMARY KEY(ID);
DROP SEQUENCE IF EXISTS IDN_AUTH_USER_SESSION_MAPPING_PK_SEQ;
CREATE SEQUENCE IDN_AUTH_USER_SESSION_MAPPING_PK_SEQ;
ALTER TABLE IDN_AUTH_USER_SESSION_MAPPING ADD COLUMN ID INTEGER DEFAULT NEXTVAL('IDN_AUTH_USER_SESSION_MAPPING_PK_SEQ');
ALTER TABLE IDN_AUTH_USER_SESSION_MAPPING ADD CONSTRAINT PRIMARY KEY (ID);

ALTER TABLE WF_BPS_PROFILE ALTER COLUMN USERNAME TYPE VARCHAR(100);

DROP SEQUENCE IF EXISTS IDN_OAUTH2_CIBA_REQUEST_SCOPES_PK_SEQ;
CREATE SEQUENCE IDN_OAUTH2_CIBA_REQUEST_SCOPES_PK_SEQ;
ALTER TABLE IDN_OAUTH2_CIBA_REQUEST_SCOPES ADD COLUMN ID INTEGER DEFAULT NEXTVAL('IDN_OAUTH2_CIBA_REQUEST_SCOPES_PK_SEQ');
ALTER TABLE IDN_OAUTH2_CIBA_REQUEST_SCOPES ADD CONSTRAINT PRIMARY KEY (ID);
ALTER TABLE IDN_FED_AUTH_SESSION_MAPPING ADD COLUMN ID SERIAL;
ALTER TABLE IDN_FED_AUTH_SESSION_MAPPING ADD COLUMN TENANT_ID INTEGER NOT NULL DEFAULT 0;
ALTER TABLE IDN_FED_AUTH_SESSION_MAPPING ADD CONSTRAINT UNIQUE (IDP_SESSION_ID, TENANT_ID);
ALTER TABLE IDN_FED_AUTH_SESSION_MAPPING ALTER CONSTRAINT PRIMARY KEY (ID);
INSERT INTO IDN_CONFIG_TYPE (ID, NAME, DESCRIPTION) VALUES ('669b99ca-cdb0-44a6-8cae-babed3b585df', 'Publisher', 'A resource type to keep the event publisher configurations'), ('73f6d9ca-62f4-4566-bab9-2a930ae51ba8', 'BRANDING_PREFERENCES', 'A resource type to keep the tenant branding preferences'), ('899c69b2-8bf7-46b5-9666-f7f99f90d6cc', 'fido-config', 'A resource type to store FIDO authenticator related preferences');

DROP TABLE IF EXISTS IDN_OAUTH2_USER_CONSENT;
DROP SEQUENCE IF EXISTS IND_OAUTH2_USER_CONSENT_PK_SEQ;
CREATE SEQUENCE IDN_OAUTH2_USER_CONSENT_PK_SEQ;
CREATE TABLE IDN_OAUTH2_USER_CONSENT (
        ID INTEGER DEFAULT NEXTVAL('IDN_OAUTH2_USER_CONSENT_PK_SEQ'),
        USER_ID VARCHAR(255) NOT NULL,
        APP_ID CHAR(36) NOT NULL,
        TENANT_ID INTEGER NOT NULL DEFAULT -1,
        CONSENT_ID VARCHAR(255) NOT NULL,
        PRIMARY KEY (ID),
        FOREIGN KEY (APP_ID) REFERENCES SP_APP (UUID) ON DELETE CASCADE,
        UNIQUE (USER_ID, APP_ID, TENANT_ID),
        UNIQUE (CONSENT_ID)
);

DROP TABLE IF EXISTS IDN_OAUTH2_USER_CONSENTED_SCOPES;
DROP SEQUENCE IF EXISTS IDN_OAUTH2_USER_CONSENTED_SCOPES_PK_SEQ;
CREATE SEQUENCE IDN_OAUTH2_USER_CONSENTED_SCOPES_PK_SEQ;
CREATE TABLE IDN_OAUTH2_USER_CONSENTED_SCOPES (
        ID INTEGER DEFAULT NEXTVAL('IDN_OAUTH2_USER_CONSENTED_SCOPES_PK_SEQ'),
        CONSENT_ID VARCHAR(255) NOT NULL,
        TENANT_ID INTEGER NOT NULL DEFAULT -1,
        SCOPE VARCHAR(255) NOT NULL,
        CONSENT BOOLEAN NOT NULL DEFAULT TRUE,
        PRIMARY KEY (ID),
        FOREIGN KEY (CONSENT_ID) REFERENCES IDN_OAUTH2_USER_CONSENT (CONSENT_ID) ON DELETE CASCADE,
        UNIQUE (CONSENT_ID, SCOPE)
);

DROP TABLE IF EXISTS IDN_SECRET_TYPE;
CREATE TABLE IDN_SECRET_TYPE (
        ID VARCHAR(255) NOT NULL,
        NAME VARCHAR(255) NOT NULL,
        DESCRIPTION VARCHAR(1023) NULL,
        PRIMARY KEY (ID),
        CONSTRAINT SECRET_TYPE_NAME_CONSTRAINT UNIQUE (NAME)
);

INSERT INTO IDN_SECRET_TYPE (ID, NAME, DESCRIPTION) VALUES
('1358bdbf-e0cc-4268-a42c-c3e0960e13f0', 'ADAPTIVE_AUTH_CALL_CHOREO', 'Secret type to uniquely identify secrets relevant to callChoreo adaptive auth function');

DROP TABLE IF EXISTS IDN_SECRET;
CREATE TABLE IDN_SECRET (
        ID VARCHAR(255) NOT NULL,
        TENANT_ID INT NOT NULL,
        SECRET_NAME VARCHAR(255) NOT NULL,
        SECRET_VALUE VARCHAR(8000) NOT NULL,
        CREATED_TIME TIMESTAMP NOT NULL,
        LAST_MODIFIED TIMESTAMP NOT NULL,
        TYPE_ID VARCHAR(255) NOT NULL,
        DESCRIPTION VARCHAR(1023) NULL,
        PRIMARY KEY (ID),
        FOREIGN KEY (TYPE_ID) REFERENCES IDN_SECRET_TYPE(ID) ON DELETE CASCADE,
        UNIQUE (SECRET_NAME, TENANT_ID, TYPE_ID)
);

DROP TABLE IF EXISTS SP_SHARED_APP;
DROP SEQUENCE IF EXISTS SP_SHARED_APP_PK_SEQ;
CREATE SEQUENCE SP_SHARED_APP_PK_SEQ;
CREATE TABLE SP_SHARED_APP(
        ID INTEGER DEFAULT NEXTVAL('SP_SHARED_APP_PK_SEQ'),
        MAIN_APP_ID CHAR(36) NOT NULL,
        OWNER_ORG_ID CHAR(36) NOT NULL,
        SHARED_APP_ID CHAR(36) NOT NULL,
        SHARED_ORG_ID CHAR(36) NOT NULL,
        PRIMARY KEY (ID),
        FOREIGN KEY (MAIN_APP_ID) REFERENCES SP_APP(UUID) ON DELETE CASCADE,
        FOREIGN KEY (SHARED_APP_ID) REFERENCES SP_APP(UUID) ON DELETE CASCADE,
        UNIQUE (MAIN_APP_ID, OWNER_ORG_ID, SHARED_ORG_ID),
        UNIQUE (SHARED_APP_ID)
);

DROP INDEX IDX_AT_CK_AU ON IDN_OAUTH2_ACCESS_TOKEN(CONSUMER_KEY_ID, AUTHZ_USER, TOKEN_STATE, USER_TYPE);
DROP INDEX IDX_AT_AU_TID_UD_TS_CKID ON IDN_OAUTH2_ACCESS_TOKEN(AUTHZ_USER, TENANT_ID, USER_DOMAIN, TOKEN_STATE, CONSUMER_KEY_ID);
DROP INDEX IDX_AT_AU_CKID_TS_UT ON IDN_OAUTH2_ACCESS_TOKEN(AUTHZ_USER, CONSUMER_KEY_ID, TOKEN_STATE, USER_TYPE);
CREATE INDEX IDX_IDN_AUTH_SSTR_ST_OP_ID_TM ON IDN_AUTH_SESSION_STORE (OPERATION, SESSION_TYPE, SESSION_ID, TIME_CREATED);
CREATE INDEX IDX_IDN_AUTH_SSTR_ET_ID ON IDN_AUTH_SESSION_STORE (EXPIRY_TIME, SESSION_ID);
CREATE INDEX IDX_AUTH_SAI_UN_AID_SID ON IDN_AUTH_SESSION_APP_INFO (APP_ID, LOWER(SUBJECT), SESSION_ID);
DROP INDEX IDX_IOP_TID_CK ON IDN_OIDC_PROPERTY(TENANT_ID,CONSUMER_KEY);
CREATE INDEX IDX_IOP_CK ON IDN_OIDC_PROPERTY(CONSUMER_KEY);
CREATE INDEX IDX_TK_VALUE_TYPE ON IDN_OAUTH2_TOKEN_BINDING (TOKEN_BINDING_VALUE, TOKEN_BINDING_TYPE);
CREATE INDEX IDX_SP_APP_NAME_CI ON SP_APP (LOWER(APP_NAME));

ALTER TABLE CM_RECEIPT_SP_ASSOC ALTER COLUMN ID INTEGER DEFAULT NEXTVAL('CM_RECEIPT_SP_ASSOC_PK_SEQ');
ALTER TABLE CM_RECEIPT_SP_ASSOC ALTER COLUMN SP_DESCRIPTION VARCHAR(1024);
DROP SEQUENCE IF EXISTS CM_SP_PURPOSE_PURPOSE_CAT_ASSC_PK_SEQ;
CREATE SEQUENCE CM_SP_PURPOSE_PURPOSE_CAT_ASSC_PK_SEQ;
ALTER TABLE CM_SP_PURPOSE_PURPOSE_CAT_ASSC ADD COLUMN ID INTEGER DEFAULT NEXTVAL('CM_SP_PURPOSE_PURPOSE_CAT_ASSC_PK_SEQ');
ALTER TABLE CM_SP_PURPOSE_PURPOSE_CAT_ASSC ADD CONSTRAINT PRIMARY KEY (ID);
DROP SEQUENCE IF EXISTS CM_PURPOSE_PII_CAT_ASSOC_PK_SEQ;
CREATE SEQUENCE CM_PURPOSE_PII_CAT_ASSOC_PK_SEQ;
ALTER TABLE CM_PURPOSE_PII_CAT_ASSOC ADD COLUMN ID INTEGER DEFAULT NEXTVAL('CM_PURPOSE_PII_CAT_ASSOC_PK_SEQ');
ALTER TABLE CM_PURPOSE_PII_CAT_ASSOC ADD CONSTRAINT PRIMARY KEY (ID);
DROP SEQUENCE IF EXISTS CM_SP_PURPOSE_PII_CAT_ASSOC_PK_SEQ;
CREATE SEQUENCE CM_SP_PURPOSE_PII_CAT_ASSOC_PK_SEQ;
ALTER TABLE CM_SP_PURPOSE_PII_CAT_ASSOC ADD COLUMN ID INTEGER DEFAULT NEXTVAL('CM_SP_PURPOSE_PII_CAT_ASSOC_PK_SEQ');
ALTER TABLE CM_SP_PURPOSE_PII_CAT_ASSOC ADD COLUMN IS_CONSENTED BOOLEAN DEFAULT TRUE;
ALTER TABLE CM_SP_PURPOSE_PII_CAT_ASSOC ADD CONSTRAINT PRIMARY KEY (ID);

DROP SEQUENCE IF EXISTS CM_CONSENT_RECEIPT_PROPERTY_PK_SEQ;
CREATE SEQUENCE CM_CONSENT_RECEIPT_PROPERTY_PK_SEQ;
ALTER TABLE CM_CONSENT_RECEIPT_PROPERTY ADD COLUMN ID INTEGER DEFAULT NEXTVAL('CM_CONSENT_RECEIPT_PROPERTY_PK_SEQ');
ALTRE TABLE CM_CONSENT_RECEIPT_PROPERTY ADD CONSTRAINT PRIMARY KEY (ID);
DROP TABLE IF EXISTS AM_API_POLICY_MAPPING;

CREATE TABLE IF NOT EXISTS AM_API_POLICY_MAPPING (
                API_POLICY_MAPPING_ID SERIAL,
                API_UUID VARCHAR(256) NOT NULL,
                REVISION_UUID VARCHAR(45),
                POLICY_UUID VARCHAR(45) NOT NULL,
                POLICY_ORDER INTEGER NOT NULL,
                DIRECTION VARCHAR(10) NOT NULL,
                PARAMETERS VARCHAR(1024) NOT NULL,
                FOREIGN KEY (API_UUID) REFERENCES AM_API(API_UUID) ON DELETE CASCADE,
                FOREIGN KEY (POLICY_UUID) REFERENCES AM_OPERATION_POLICY(POLICY_UUID) ON DELETE CASCADE,
                PRIMARY KEY(API_POLICY_MAPPING_ID)
        );
DROP TABLE IF EXISTS AM_CORRELATION_CONFIGS;
CREATE TABLE IF NOT EXISTS AM_CORRELATION_CONFIGS (
                COMPONENT_NAME  VARCHAR(45)     NOT NULL,
                ENABLED         VARCHAR(45)     NOT NULL,
                PRIMARY KEY (COMPONENT_NAME)
        );
DROP TABLE IF EXISTS AM_CORRELATION_PROPERTIES;
CREATE TABLE IF NOT EXISTS AM_CORRELATION_PROPERTIES(
                PROPERTY_NAME   VARCHAR(45)     NOT NULL,
                COMPONENT_NAME  VARCHAR(45)     NOT NULL,
                PROPERTY_VALUE  VARCHAR(1023)   NOT NULL,
                PRIMARY KEY (PROPERTY_NAME, COMPONENT_NAME),
                FOREIGN KEY (COMPONENT_NAME) REFERENCES AM_CORRELATION_CONFIGS(COMPONENT_NAME) ON DELETE CASCADE
        );
CREATE INDEX IDX_IOAT_TSH_TS ON IDN_OAUTH2_ACCESS_TOKEN(TOKEN_SCOPE_HASH,TOKEN_STATE);



