# wso2-upgrade
 HowTo upgrade wso2am and wsois
 Il presente documento evidenzia le differenze nei database tra le versioni di WSO2 prese in esame per mettere in atto l'upgrade dell'infrastruttura HDI

## Documentazione di riferimento per WSO2 Api Manager

### AM 4.1.0
* Docs: https://apim.docs.wso2.com/en/4.1.0/
* Release Notes: https://apim.docs.wso2.com/en/4.1.0/get-started/about-this-release/
* DB Docs: https://apim.docs.wso2.com/en/4.1.0/install-and-setup/setup/setting-up-databases/changing-default-databases/changing-to-postgresql/

### AM 4.2.0
* Docs: https://apim.docs.wso2.com/en/4.2.0/
* Release Notes: https://apim.docs.wso2.com/en/4.2.0/get-started/about-this-release/
* DB Docs: https://apim.docs.wso2.com/en/4.2.0/install-and-setup/setup/setting-up-databases/changing-default-databases/changing-to-postgresql/

### AM 4.3.0
* Docs: https://apim.docs.wso2.com/en/4.3.0/
* Release Notes: https://apim.docs.wso2.com/en/4.3.0/get-started/about-this-release/
* DB Docs: https://apim.docs.wso2.com/en/4.3.0/install-and-setup/setup/setting-up-databases/changing-default-databases/changing-to-postgresql/

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

### IS 6.0.0
* Docs: https://is.docs.wso2.com/en/6.0.0/
* Release Notes: https://is.docs.wso2.com/en/6.0.0/get-started/about-this-release/

### IS 6.1.0
* Docs: https://is.docs.wso2.com/en/6.1.0/
* Release Notes: https://is.docs.wso2.com/en/6.1.0/get-started/about-this-release/

## Database utilizzati da WSO2 Identity Server