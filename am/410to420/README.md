# Upgrading WSO2 API Manager from version 4.1.0 to 4.2.0

## Documentazione di riferimento per WSO2 Api Manager

### AM 4.1.0
* (Docs)[https://apim.docs.wso2.com/en/4.1.0/]
* (Release Notes)[https://apim.docs.wso2.com/en/4.1.0/get-started/about-this-release/
* (Reference)[https://apim.docs.wso2.com/en/4.1.0/reference/product-apis/overview/
* (DB Docs)[https://apim.docs.wso2.com/en/4.1.0/install-and-setup/setup/setting-up-databases/changing-default-databases/changing-to-postgresql/
* DB Upgrade: https://apim.docs.wso2.com/en/4.1.0/reference/guides/database-upgrade-guide/

### AM 4.2.0
* (Docs)[https://apim.docs.wso2.com/en/4.2.0/]
* (Release Notes)[https://apim.docs.wso2.com/en/4.2.0/get-started/about-this-release/]
* (Reference)[https://apim.docs.wso2.com/en/4.2.0/reference/product-apis/overview/]
* (DB Docs)[https://apim.docs.wso2.com/en/4.2.0/install-and-setup/setup/setting-up-databases/changing-default-databases/changing-to-postgresql/]
* DB Upgrade: https://apim.docs.wso2.com/en/4.2.0/reference/guides/database-upgrade-guide/]

## Database utilizzati da WSO2 Api Manager

### WSO2AM_DB
* deployment.toml section: [database.apim_db]
* Source script: <API-M_HOME>/dbscripts/apimgt/postgresql.sql

### WSO2_SHARED_DB
* deployment.toml section: [database.shared_db]
* Source script: <API-M_HOME>/dbscripts/postgresql.sql

### WSO2CARBON_DB
* deployment.toml section: [database.local]
* Source script: <API-M_HOME>/dbscripts/postgresql.sql
* **Note:** *By default WSO2CARBON_DB will be an embedded H2 database and it is not necessary to change it to another database. But if you have a requirement to change it, make sure that each server node have its own WSO2CARBON_DB*
        
## AM DB Version Comparison
* [410to420](/am/410to420/db/postgres/)
* [420to430](/am/420to430/db/postgres/)
