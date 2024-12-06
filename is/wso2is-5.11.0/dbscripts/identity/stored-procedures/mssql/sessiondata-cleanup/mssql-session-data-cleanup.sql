CREATE PROCEDURE CLEANUP_SESSION_DATA AS
BEGIN

-- ------------------------------------------
-- DECLARE VARIABLES
-- ------------------------------------------
DECLARE @deletedSessions INT;
DECLARE @deletedUserSessionMappings INT;
DECLARE @deletedOperationalUserSessionMappings INT;
DECLARE @deletedSessionAppInfo INT;
DECLARE @deletedOperationalSessionAppInfo INT;
DECLARE @deletedSessionMetadata INT;
DECLARE @deletedOperationalSessionMetadata INT;
DECLARE @deletedStoreOperations INT;
DECLARE @deletedDeleteOperations INT;
DECLARE @sessionCleanupCount INT;
DECLARE @sessionMappingsCleanupCount INT;
DECLARE @operationalSessionMappingsCleanupCount INT;
DECLARE @sessionAppInfoCleanupCount INT;
DECLARE @operationalSessionAppInfoCleanupCount INT;
DECLARE @sessionMetadataCleanupCount INT;
DECLARE @operationalSessionMetadataCleanupCount INT;
DECLARE @operationCleanupCount INT;
DECLARE @tracingEnabled INT;
DECLARE @sleepTime AS VARCHAR(12);
DECLARE @batchSize INT;
DECLARE @chunkLimit INT;

DECLARE @sessionCleanUpTempTableCount INT;
DECLARE @operationCleanUpTempTableCount INT;
DECLARE @cleanUpCompleted INT;
DECLARE @autocommit INT;
DECLARE @sessionCleanupTime bigint;
DECLARE @operationCleanupTime bigint;
DECLARE @OLD_SQL_SAFE_UPDATES INT;
DECLARE @SQL_SAFE_UPDATES INT;
-- ------------------------------------------
-- CONFIGURABLE VARIABLES
-- ------------------------------------------

SET @batchSize = 5000;
-- This defines the number of entries from IDN_AUTH_SESSION_STORE that are taken into a SNAPSHOT
SET @chunkLimit=1000000;
SET @deletedSessions = 0;
SET @deletedUserSessionMappings = 0;
SET @deletedOperationalUserSessionMappings = 0;
SET @deletedSessionAppInfo = 0;
SET @deletedOperationalSessionAppInfo = 0;
SET @deletedSessionMetadata = 0;
SET @deletedOperationalSessionMetadata = 0;
SET @deletedStoreOperations = 0;
SET @deletedDeleteOperations = 0;
SET @sessionCleanupCount = 1;
SET @sessionMappingsCleanupCount = 1;
SET @operationalSessionMappingsCleanupCount = 1;
SET @sessionAppInfoCleanupCount = 1;
SET @operationalSessionAppInfoCleanupCount = 1;
SET @sessionMetadataCleanupCount = 1;
SET @operationalSessionMetadataCleanupCount = 1;
SET @operationCleanupCount = 1;
SET @tracingEnabled = 1;	-- SET IF TRACE LOGGING IS ENABLED [DEFAULT : FALSE]
SET @sleepTime = '00:00:02.000';          -- Sleep time in seconds.
SET @autocommit = 0;

SET @sessionCleanUpTempTableCount = 1;
SET @operationCleanUpTempTableCount = 1;
SET @cleanUpCompleted = 1;

-- Session data older than 20160 minutes(14 days) will be removed.
SET @sessionCleanupTime = cast((DATEDIFF_BIG(millisecond, '1970-01-01 00:00:00', GETUTCDATE()) - (1209600000))AS DECIMAL) * 1000000
-- Operational data older than 720 minutes(12 h) will be removed.
SET @operationCleanupTime = cast((DATEDIFF_BIG(millisecond, '1970-01-01 00:00:00', GETUTCDATE()) - (720*60000))AS DECIMAL) * 1000000

SET @SQL_SAFE_UPDATES = 0;
SET @OLD_SQL_SAFE_UPDATES=@SQL_SAFE_UPDATES;


-- ------------------------------------------
-- REMOVE SESSION DATA
-- ------------------------------------------

SELECT 'CLEANUP_SESSION_DATA() STARTED .... !' AS 'INFO LOG',GETUTCDATE() AS 'STARTING TIMESTAMP';


-- CLEANUP ANY EXISTING TEMP TABLES
DROP TABLE IF EXISTS IDN_AUTH_SESSION_STORE_TMP;
DROP TABLE IF EXISTS TEMP_SESSION_BATCH;

-- RUN UNTILL
WHILE (@sessionCleanUpTempTableCount > 0)
BEGIN

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[IDN_AUTH_SESSION_STORE_TMP]') AND TYPE IN (N'U'))
BEGIN
CREATE TABLE IDN_AUTH_SESSION_STORE_TMP( SESSION_ID VARCHAR (100));
INSERT INTO IDN_AUTH_SESSION_STORE_TMP (SESSION_ID) SELECT TOP (@chunkLimit) SESSION_ID FROM IDN_AUTH_SESSION_STORE where TIME_CREATED < @sessionCleanupTime;
CREATE INDEX idn_auth_session_tmp_idx on IDN_AUTH_SESSION_STORE_TMP (SESSION_ID)
END

SELECT @sessionCleanUpTempTableCount = COUNT(1) FROM IDN_AUTH_SESSION_STORE_TMP;
SELECT 'TEMPORARY SESSION CLEANUP TASK SNAPSHOT TABLE CREATED...!!' AS 'INFO LOG', @sessionCleanUpTempTableCount;
SET @sessionCleanupCount = 1;

WHILE (@sessionCleanupCount > 0)
BEGIN

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[TEMP_SESSION_BATCH]') AND TYPE IN (N'U'))
BEGIN
CREATE TABLE TEMP_SESSION_BATCH( SESSION_ID VARCHAR (100));
INSERT INTO TEMP_SESSION_BATCH (SESSION_ID) SELECT TOP (@batchSize) SESSION_ID FROM IDN_AUTH_SESSION_STORE_TMP;
END

DELETE A
FROM IDN_AUTH_SESSION_STORE AS A
INNER JOIN TEMP_SESSION_BATCH AS B ON A.SESSION_ID = B.SESSION_ID;
SET @sessionCleanupCount = @@ROWCOUNT;

SELECT 'DELETED SESSION COUNT...!!' AS 'INFO LOG', @sessionCleanupCount;

-- Deleting user-session mappings from 'IDN_AUTH_USER_SESSION_MAPPING' table
IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'IDN_AUTH_USER_SESSION_MAPPING'))
BEGIN
    DELETE A
    FROM IDN_AUTH_USER_SESSION_MAPPING AS A
             INNER JOIN TEMP_SESSION_BATCH AS B ON A.SESSION_ID = B.SESSION_ID;
    SET @sessionMappingsCleanupCount = @@ROWCOUNT;
    SELECT 'DELETED USER-SESSION MAPPINGS ...!!' AS 'INFO LOG', @sessionMappingsCleanupCount;

    IF (@tracingEnabled=1)
    BEGIN
        SET @deletedUserSessionMappings = @deletedUserSessionMappings + @sessionMappingsCleanupCount;
        SELECT 'REMOVED USER-SESSION MAPPINGS: ' AS 'INFO LOG', @deletedUserSessionMappings AS 'NO OF DELETED ENTRIES', GETUTCDATE() AS 'TIMESTAMP';
    END;
END

-- Deleting session app info from 'IDN_AUTH_SESSION_APP_INFO' table
IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'IDN_AUTH_SESSION_APP_INFO'))
BEGIN
    DELETE A
    FROM IDN_AUTH_SESSION_APP_INFO AS A
             INNER JOIN TEMP_SESSION_BATCH AS B ON A.SESSION_ID = B.SESSION_ID;
    SET @sessionAppInfoCleanupCount = @@ROWCOUNT;
    SELECT 'DELETED SESSION APP INFO ...!!' AS 'INFO LOG', @sessionAppInfoCleanupCount;


    IF (@tracingEnabled=1)
    BEGIN
        SET @deletedSessionAppInfo = @deletedSessionAppInfo + @sessionAppInfoCleanupCount;
        SELECT 'REMOVED SESSION APP INFO: ' AS 'INFO LOG', @deletedSessionAppInfo AS 'NO OF DELETED ENTRIES', GETUTCDATE() AS 'TIMESTAMP';
    END;
END

-- Deleting session metadata from 'IDN_AUTH_SESSION_META_DATA' table
IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'IDN_AUTH_SESSION_META_DATA'))
BEGIN
    DELETE A
    FROM IDN_AUTH_SESSION_META_DATA AS A
             INNER JOIN TEMP_SESSION_BATCH AS B ON A.SESSION_ID = B.SESSION_ID;
    SET @sessionMetadataCleanupCount = @@ROWCOUNT;
    SELECT 'DELETED SESSION METADATA ...!!' AS 'INFO LOG', @sessionMetadataCleanupCount;

    IF (@tracingEnabled=1)
    BEGIN
        SET @deletedSessionMetadata = @deletedSessionMetadata + @sessionMetadataCleanupCount;
        SELECT 'REMOVED SESSION METADATA: ' AS 'INFO LOG', @deletedSessionMetadata AS 'NO OF DELETED ENTRIES', GETUTCDATE() AS 'TIMESTAMP';
    END;
END

DELETE A
FROM IDN_AUTH_SESSION_STORE_TMP AS A
INNER JOIN TEMP_SESSION_BATCH AS B
ON A.SESSION_ID = B.SESSION_ID;

SELECT 'END CLEANING UP IDS FROM TEMP SESSION DATA SNAPSHOT TABLE...!!' AS 'INFO LOG';

DROP TABLE TEMP_SESSION_BATCH;

IF (@tracingEnabled=1)
BEGIN
SET @deletedSessions = @deletedSessions + @sessionCleanupCount;
SELECT 'REMOVED SESSIONS: ' AS 'INFO LOG', @deletedSessions AS 'NO OF DELETED ENTRIES', GETUTCDATE() AS 'TIMESTAMP';
END;

END;

-- Sleep for some time letting other threads to run.
WAITFOR DELAY @sleepTime;

END;

-- DROP THE CHUNK TO MOVE ON TO THE NEXT CHUNK IN THE SNAPSHOT TABLE.
DROP TABLE IF EXISTS IDN_AUTH_SESSION_STORE_TMP;

IF (@tracingEnabled=1)
BEGIN
SELECT 'SESSION RECORDS REMOVED FROM IDN_AUTH_SESSION_STORE: ' AS 'INFO LOG', @deletedSessions AS 'TOTAL NO OF DELETED ENTRIES', GETUTCDATE() AS 'COMPLETED_TIMESTAMP';
SELECT 'SESSION RECORDS REMOVED FROM IDN_AUTH_USER_SESSION_MAPPING: ' AS 'INFO LOG', @deletedUserSessionMappings AS 'TOTAL NO OF DELETED ENTRIES',GETUTCDATE() AS 'COMPLETED_TIMESTAMP';
SELECT 'SESSION RECORDS REMOVED FROM IDN_AUTH_SESSION_APP_INFO: ' AS 'INFO LOG', @deletedSessionAppInfo AS 'TOTAL NO OF DELETED ENTRIES',GETUTCDATE() AS 'COMPLETED_TIMESTAMP';
SELECT 'SESSION RECORDS REMOVED FROM IDN_AUTH_SESSION_META_DATA: ' AS 'INFO LOG', @deletedSessionMetadata AS 'TOTAL NO OF DELETED ENTRIES',GETUTCDATE() AS 'COMPLETED_TIMESTAMP';
END;

SELECT 'SESSION_CLEANUP_TASK ENDED .... !' AS 'INFO LOG';

-- --------------------------------------------
-- REMOVE OPERATIONAL DATA
-- --------------------------------------------

SELECT 'OPERATION_CLEANUP_TASK STARTED .... !' AS 'INFO LOG', GETUTCDATE() AS 'STARTING TIMESTAMP';
SELECT 'BATCH DELETE STARTED .... ' AS 'INFO LOG';

DROP TABLE IF EXISTS IDN_AUTH_SESSION_STORE_TMP;
DROP TABLE IF EXISTS TEMP_SESSION_BATCH;

-- RUN UNTILL
WHILE (@operationCleanUpTempTableCount > 0)
BEGIN

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[IDN_AUTH_SESSION_STORE_TMP]') AND TYPE IN (N'U'))
BEGIN
CREATE TABLE IDN_AUTH_SESSION_STORE_TMP( SESSION_ID VARCHAR (100), SESSION_TYPE VARCHAR(100));
INSERT INTO IDN_AUTH_SESSION_STORE_TMP (SESSION_ID,SESSION_TYPE) SELECT TOP (@chunkLimit) SESSION_ID,SESSION_TYPE FROM IDN_AUTH_SESSION_STORE WHERE OPERATION = 'DELETE' AND TIME_CREATED < @operationCleanupTime;
CREATE INDEX idn_auth_session_tmp_idx on IDN_AUTH_SESSION_STORE_TMP (SESSION_ID)
END

SELECT @operationCleanUpTempTableCount = COUNT(1) FROM IDN_AUTH_SESSION_STORE_TMP;
SELECT 'TEMPORARY SESSION CLEANUP TASK SNAPSHOT TABLE CREATED...!!' AS 'INFO LOG', @operationCleanUpTempTableCount;
SET @operationCleanupCount = 1;

WHILE (@operationCleanupCount > 0)
BEGIN

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[TEMP_SESSION_BATCH]') AND TYPE IN (N'U'))
BEGIN
CREATE TABLE TEMP_SESSION_BATCH( SESSION_ID VARCHAR (100),SESSION_TYPE VARCHAR(100));
INSERT INTO TEMP_SESSION_BATCH (SESSION_ID,SESSION_TYPE) SELECT TOP (@batchSize) SESSION_ID,SESSION_TYPE FROM IDN_AUTH_SESSION_STORE_TMP;
END

DELETE A
FROM IDN_AUTH_SESSION_STORE AS A
INNER JOIN TEMP_SESSION_BATCH AS B
ON A.SESSION_ID = B.SESSION_ID AND A.SESSION_TYPE = B.SESSION_TYPE;;
SET @operationCleanupCount = @@ROWCOUNT;

SELECT 'DELETED STORE OPERATIONS COUNT...!!' AS 'INFO LOG', @operationCleanupCount;

-- Deleting session app info from 'IDN_AUTH_USER_SESSION_MAPPING' table
IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'IDN_AUTH_USER_SESSION_MAPPING'))
BEGIN
    DELETE A
    FROM IDN_AUTH_USER_SESSION_MAPPING AS A
             INNER JOIN TEMP_SESSION_BATCH AS B ON A.SESSION_ID = B.SESSION_ID;
    SET @operationalSessionMappingsCleanupCount = @@ROWCOUNT;
    SELECT 'DELETED OPERATION RELATED USER-SESSION MAPPINGS ...!!' AS 'INFO LOG', @operationalSessionMappingsCleanupCount;

    IF (@tracingEnabled=1)
    BEGIN
        SET @deletedOperationalUserSessionMappings = @operationalSessionMappingsCleanupCount + @deletedOperationalUserSessionMappings;
        SELECT 'REMOVED USER-SESSION MAPPING RECORDS: ' AS 'INFO LOG', @deletedOperationalUserSessionMappings AS 'NO OF DELETED STORE ENTRIES', GETUTCDATE() AS 'TIMESTAMP';
    END;
END

-- Deleting session app info from 'IDN_AUTH_SESSION_APP_INFO' table
IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'IDN_AUTH_SESSION_APP_INFO'))
BEGIN
    DELETE A
    FROM IDN_AUTH_SESSION_APP_INFO AS A
             INNER JOIN TEMP_SESSION_BATCH AS B ON A.SESSION_ID = B.SESSION_ID;
    SET @operationalSessionAppInfoCleanupCount = @@ROWCOUNT;
    SELECT 'DELETED SESSION APP INFO ...!!' AS 'INFO LOG', @operationalSessionAppInfoCleanupCount;

    IF (@tracingEnabled=1)
    BEGIN
        SET @deletedOperationalSessionAppInfo = @operationalSessionAppInfoCleanupCount + @deletedOperationalSessionAppInfo;
        SELECT 'REMOVED SESSION APP INFO RECORDS: ' AS 'INFO LOG', @deletedOperationalSessionAppInfo AS 'NO OF DELETED STORE ENTRIES', GETUTCDATE() AS 'TIMESTAMP';
    END;
END

-- Deleting session metadata from 'IDN_AUTH_SESSION_META_DATA' table
IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'IDN_AUTH_SESSION_META_DATA'))
BEGIN
    DELETE A
    FROM IDN_AUTH_SESSION_META_DATA AS A
             INNER JOIN TEMP_SESSION_BATCH AS B ON A.SESSION_ID = B.SESSION_ID;
    SET @operationalSessionMetadataCleanupCount = @@ROWCOUNT;
    SELECT 'DELETED SESSION METADATA ...!!' AS 'INFO LOG', @operationalSessionMetadataCleanupCount;

    IF (@tracingEnabled=1)
    BEGIN
        SET @deletedOperationalSessionMetadata = @operationalSessionMetadataCleanupCount + @deletedOperationalSessionMetadata;
        SELECT 'REMOVED SESSION METADATA RECORDS: ' AS 'INFO LOG', @deletedOperationalSessionMetadata AS 'NO OF DELETED STORE ENTRIES', GETUTCDATE() AS 'TIMESTAMP';
    END;
END

IF (@tracingEnabled=1)
BEGIN
SET @deletedDeleteOperations = @operationCleanupCount + @deletedDeleteOperations;
SELECT 'REMOVED DELETE OPERATION RECORDS: ' AS 'INFO LOG', @deletedDeleteOperations AS 'NO OF DELETED DELETE ENTRIES', GETUTCDATE() AS 'TIMESTAMP';
END;

DELETE A
FROM IDN_AUTH_SESSION_STORE_TMP AS A
INNER JOIN TEMP_SESSION_BATCH AS B
ON A.SESSION_ID = B.SESSION_ID AND A.SESSION_TYPE = B.SESSION_TYPE;;

SELECT 'ENDED CLEANING UP IDS FROM TEMP OPERATIONAL DATA SNAPSHOT TABLE...!!' AS 'INFO LOG';

IF (@tracingEnabled=1)
BEGIN
SET @deletedStoreOperations = @operationCleanupCount + @deletedStoreOperations;
SELECT 'REMOVED STORE OPERATION RECORDS: ' AS 'INFO LOG', @deletedStoreOperations AS 'NO OF DELETED STORE ENTRIES', GETUTCDATE() AS 'TIMESTAMP';
END;

DROP TABLE TEMP_SESSION_BATCH;

END;
-- Sleep for some time letting other threads to run.
WAITFOR DELAY @sleepTime;
END;

DROP TABLE IF EXISTS IDN_AUTH_SESSION_STORE_TMP;

SELECT 'FLAG SET TO INDICATE END OF CLEAN UP TASK...!!' AS 'INFO LOG';

IF (@tracingEnabled=1)
BEGIN
SELECT 'STORE OPERATION RECORDS REMOVED FROM IDN_AUTH_SESSION_STORE: ' AS 'INFO LOG', @deletedStoreOperations  AS 'TOTAL NO OF DELETED STORE ENTRIES', GETUTCDATE() AS 'COMPLETED_TIMESTAMP';
SELECT 'DELETE OPERATION RECORDS REMOVED FROM IDN_AUTH_SESSION_STORE: ' AS 'INFO LOG', @deletedDeleteOperations AS 'TOTAL NO OF DELETED DELETE ENTRIES', GETUTCDATE() AS 'COMPLETED_TIMESTAMP';
SELECT 'DELETE OPERATION RELATED SESSION RECORDS REMOVED FROM IDN_AUTH_USER_SESSION_MAPPING: ' AS 'INFO LOG', @deletedOperationalUserSessionMappings AS 'TOTAL NO OF DELETED DELETE ENTRIES', GETUTCDATE() AS 'COMPLETED_TIMESTAMP';
SELECT 'DELETE OPERATION RELATED SESSION RECORDS REMOVED FROM IDN_AUTH_SESSION_APP_INFO: ' AS 'INFO LOG', @deletedOperationalSessionAppInfo AS 'TOTAL NO OF DELETED DELETE ENTRIES', GETUTCDATE() AS 'COMPLETED_TIMESTAMP';
SELECT 'DELETE OPERATION RELATED SESSION RECORDS REMOVED FROM IDN_AUTH_SESSION_META_DATA: ' AS 'INFO LOG', @deletedOperationalSessionMetadata AS 'TOTAL NO OF DELETED DELETE ENTRIES', GETUTCDATE() AS 'COMPLETED_TIMESTAMP';
END;

SET @SQL_SAFE_UPDATES = @OLD_SQL_SAFE_UPDATES;

SELECT 'CLEANUP_SESSION_DATA() ENDED .... !' AS 'INFO LOG',GETUTCDATE() AS 'ENDING TIMESTAMP';

END;