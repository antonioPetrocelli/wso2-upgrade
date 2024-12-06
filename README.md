# WSO2 Upgrade
HowTo upgrade wso2am, wso2is and wso2mi

|Redatto da    |Antonio Petrocelli                   |
|--------------|-------------------------------------|
|Aggiornato da |Antonio Petrocelli                   |
|Versione: 1.0 |Data: 05/12/2024 - Bozza             |

Il presente documento illustra gli step necessari per aggiornare le versioni dei seguenti prodotti WSO2

|Product                |From Version   |To Version |Docs                      |
|-----------------------|---------------|-----------|---------------------------
|Wso2 API Manager       |4.1.0          |4.2.0      |[410to420](/am/410to420/) |
|Wso2 API Manager       |4.1.0          |4.2.0      |[420to430](/am/420to430/) |
|Wso2 Identity Server   |5.11.0         |6.0.0      |[511to600](/is/511to600/) |
|Wso2 Identity Server   |6.0.0          |6.1.0      |[600to610](/is/600to610/) |
|Wso2 Micro Integrator  |4.2.0          |4.3.0      |[420to430](/mi/420to430/) |

Il presente documento evidenzia le differenze nei database tra le versioni di WSO2 prese in esame.

* Appunti
* Database: controllare differenze negli script
* Release Notes: controllare funzionalità deprecate e/o dismesse
* Ricerche:
    * WSO2 Upgrade Process
    * WSO2 Database Upgrade Guide

## Documentazione di riferimento per WSO2 Api Manager

### AM 4.1.0
* Docs: https://apim.docs.wso2.com/en/4.1.0/
* Release Notes: https://apim.docs.wso2.com/en/4.1.0/get-started/about-this-release/
* Reference: https://apim.docs.wso2.com/en/4.1.0/reference/product-apis/overview/
* DB Docs: https://apim.docs.wso2.com/en/4.1.0/install-and-setup/setup/setting-up-databases/changing-default-databases/changing-to-postgresql/
* DB Upgrade: https://apim.docs.wso2.com/en/4.1.0/reference/guides/database-upgrade-guide/

### AM 4.2.0
* Docs: https://apim.docs.wso2.com/en/4.2.0/
* Release Notes: https://apim.docs.wso2.com/en/4.2.0/get-started/about-this-release/
* Reference: https://apim.docs.wso2.com/en/4.2.0/reference/product-apis/overview/
* DB Docs: https://apim.docs.wso2.com/en/4.2.0/install-and-setup/setup/setting-up-databases/changing-default-databases/changing-to-postgresql/
* DB Upgrade: https://apim.docs.wso2.com/en/4.2.0/reference/guides/database-upgrade-guide/

### AM 4.3.0
* Docs: https://apim.docs.wso2.com/en/4.3.0/
* Release Notes: https://apim.docs.wso2.com/en/4.3.0/get-started/about-this-release/
* Reference: https://apim.docs.wso2.com/en/4.3.0/reference/product-apis/overview/
* DB Docs: https://apim.docs.wso2.com/en/4.3.0/install-and-setup/setup/setting-up-databases/changing-default-databases/changing-to-postgresql/
* DB Upgrade: https://apim.docs.wso2.com/en/4.3.0/reference/guides/database-upgrade-guide/

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
* <a href="410to420.html" target="_blank">WSO2 AM 4.1.0 To WSO2 AM 4.2.0 Database comparison</a>
* <a href="420to430.html" target="_blank">WSO2 AM 4.2.0 To WSO2 AM 4.3.0 Database comparison</a>
* <a href="410to430.html" target="_blank">WSO2 AM 4.1.0 To WSO2 AM 4.3.0 Database comparison</a>

## Documentazione di riferimento per WSO2 Identity Server

### IS 5.11.0
* Docs: https://is.docs.wso2.com/en/5.11.0/
* Release Notes: https://is.docs.wso2.com/en/5.11.0/get-started/about-this-release/
* Reference: https://is.docs.wso2.com/en/5.11.0/references/references-overview/
* DB Docs: https://is.docs.wso2.com/en/5.11.0/setup/working-with-databases/

### IS 6.0.0
* Docs: https://is.docs.wso2.com/en/6.0.0/
* Release Notes: https://is.docs.wso2.com/en/6.0.0/get-started/about-this-release/
* Reference: https://is.docs.wso2.com/en/6.0.0/references/references-overview/
* DB Docs: https://is.docs.wso2.com/en/6.0.0/deploy/work-with-databases/

### IS 6.1.0
* Docs: https://is.docs.wso2.com/en/6.1.0/
* Release Notes: https://is.docs.wso2.com/en/6.1.0/get-started/about-this-release/
* Reference: https://is.docs.wso2.com/en/6.1.0/references/references-overview/
* DB Docs: https://is.docs.wso2.com/en/6.1.0/deploy/work-with-databases/

## Database utilizzati da WSO2 Identity Server

## Documentazione di riferimento per WSO2 Micro Integrator

### MI 4.2.0
* Docs: https://mi.docs.wso2.com/en/4.2.0/
* Release Notes: https://mi.docs.wso2.com/en/4.2.0/get-started/about-this-release/
* Reference: https://mi.docs.wso2.com/en/4.2.0/reference/config-catalog-mi/
* DB Docs: https://mi.docs.wso2.com/en/4.2.0/install-and-setup/setup/databases/setting-up-postgresql/
	
### MI 4.3.0
* Docs: https://mi.docs.wso2.com/en/4.3.0/
* Release Notes: https://mi.docs.wso2.com/en/4.3.0/get-started/about-this-release/
* Reference: https://mi.docs.wso2.com/en/4.3.0/reference/config-catalog-mi/
* DB Docs: https://mi.docs.wso2.com/en/4.3.0/install-and-setup/setup/databases/setting-up-postgresql/

## Database utilizzati da WSO2 Micro Integrator