# Aggiornamento di WSO2 Micro Integrator dalla versione 4.2.0 alla versione 4.3.0

## Documentazione di riferimento per WSO2 Micro Integrator

### MI 4.2.0
* [Docs](https://mi.docs.wso2.com/en/4.2.0/)
* [Release Notes](https://mi.docs.wso2.com/en/4.2.0/get-started/about-this-release/)
* [Reference](https://mi.docs.wso2.com/en/4.2.0/reference/config-catalog-mi/)
* [DB Docs](https://mi.docs.wso2.com/en/4.2.0/install-and-setup/setup/databases/setting-up-postgresql/)
	
### MI 4.3.0
* [Docs](https://mi.docs.wso2.com/en/4.3.0/)
* [Release Notes](https://mi.docs.wso2.com/en/4.3.0/get-started/about-this-release/)
* [Reference](https://mi.docs.wso2.com/en/4.3.0/reference/config-catalog-mi/)
* [DB Docs](https://mi.docs.wso2.com/en/4.3.0/install-and-setup/setup/databases/setting-up-postgresql/)

## Database utilizzati da WSO2 Micro Integrator

### WSO2CarbonDB
* deployment.toml section: [[datasource]]
* Source script v4.2.0: [<MI_HOME>/dbscripts/](/mi/wso2am-4.2.0/dbscripts/postgres/postgresql_user.sql)
* Source script v4.3.0: [<MI_HOME>/dbscripts/](/mi/wso2am-4.3.0/dbscripts/postgres/postgresql_user.sql)

### WSO2_COORDINATION_DB
* deployment.toml section: [[datasource]]
* Source script v4.2.0: [<MI_HOME>/dbscripts/](/mi/wso2am-4.2.0/dbscripts/postgres/postgresql_cluster.sql)
* Source script v4.3.0: [<MI_HOME>/dbscripts/](/mi/wso2am-4.3.0/dbscripts/postgres/postgresql_cluster.sql)

## Verifica delle differenze nella struttura tra i DB Postgres
* [420to430](/mi/420to430/db/postgres/)