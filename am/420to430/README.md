# Aggiornamento di WSO2 API Manager dalla versione 4.2.0 alla versione 4.3.0

## Documentazione di riferimento per WSO2 Api Manager

### AM 4.2.0
* (Docs)[https://apim.docs.wso2.com/en/4.2.0/]
* (Release Notes)[https://apim.docs.wso2.com/en/4.2.0/get-started/about-this-release/]
* (Reference)[https://apim.docs.wso2.com/en/4.2.0/reference/product-apis/overview/]
* (DB Docs)[https://apim.docs.wso2.com/en/4.2.0/install-and-setup/setup/setting-up-databases/changing-default-databases/changing-to-postgresql/]

### AM 4.3.0
* (Docs)[https://apim.docs.wso2.com/en/4.3.0/]
* (Release Notes)[https://apim.docs.wso2.com/en/4.3.0/get-started/about-this-release/]
* (Reference)[https://apim.docs.wso2.com/en/4.3.0/reference/product-apis/overview/]
* (DB Docs)[https://apim.docs.wso2.com/en/4.3.0/install-and-setup/setup/setting-up-databases/changing-default-databases/changing-to-postgresql/]

## Database utilizzati da WSO2 Api Manager

### WSO2AM_DB
* deployment.toml section: [database.apim_db]
* Source script v4.2.0: [<API-M_HOME>/dbscripts/apimgt/](/am/wso2am-4.2.0/dbscripts/apimgt/)
* Source script v4.3.0: [<API-M_HOME>/dbscripts/apimgt/](/am/wso2am-4.3.0/dbscripts/apimgt/)

### WSO2SHARED_DB
* deployment.toml section: [database.shared_db]
* Source script v4.2.0: [<API-M_HOME>/dbscripts/](/am/wso2am-4.2.0/dbscripts/)
* Source script v4.3.0: [<API-M_HOME>/dbscripts/](/am/wso2am-4.3.0/dbscripts/)

### WSO2CARBON_DB
* deployment.toml section: [database.local]
* Source script v4.2.0: [<API-M_HOME>/dbscripts/](/am/wso2am-4.2.0/dbscripts/)
* Source script v4.3.0: [<API-M_HOME>/dbscripts/](/am/wso2am-4.3.0/dbscripts/)
* **Note:** *By default WSO2CARBON_DB will be an embedded H2 database and it is not necessary to change it to another database. But if you have a requirement to change it, make sure that each server node have its own WSO2CARBON_DB*
        
## Verifica delle differenze nella struttura tra i DB Postgres
* [420to430](/am/420to430/db/postgres/)
