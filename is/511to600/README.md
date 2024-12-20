# Aggiornamento di WSO2 Identity Server dalla versione 5.11.0 alla versione 6.0.0

## Documentazione di riferimento per WSO2 Identity Server

### IS 5.11.0
* [Docs](https://is.docs.wso2.com/en/5.11.0/)
* [Release Notes](https://is.docs.wso2.com/en/5.11.0/get-started/about-this-release/)
* [Reference](https://is.docs.wso2.com/en/5.11.0/references/references-overview/)
* [DB Docs](https://is.docs.wso2.com/en/5.11.0/setup/working-with-databases/)

#### [IS 5.11.0 Deprecated & Removed features](https://is.docs.wso2.com/en/5.11.0/get-started/about-this-release/#deprecated-features-and-functionalities)
* [Deprecated features and functionalities](https://is.docs.wso2.com/en/5.11.0/references/wso2-identity-server-feature-deprecation/#feature-deprecation-matrix)
    * **/identity/connect/register API**
	* **OAuth 1.0**

### IS 6.0.0
* [Docs](https://is.docs.wso2.com/en/6.0.0/)
* [Release Notes](https://is.docs.wso2.com/en/6.0.0/get-started/about-this-release/)
* [Reference](https://is.docs.wso2.com/en/6.0.0/references/references-overview/)
* [DB Docs](https://is.docs.wso2.com/en/6.0.0/deploy/work-with-databases/)

#### [IS 6.0.0 Deprecated & Removed features](https://is.docs.wso2.com/en/6.0.0/references/about-this-release/#removed-features)
* Deprecated features and functionalities
    * **SCIM 1 inbound provisioning**: Use SCIM 2.0 inbound provisioning
	* **SCIM 1 outbound provisioning**: Use SCIM 2.0 outbound provisioning
	* **SOAP APIs**: Use REST-based APIs
	* **Legacy DCR endpoint implementation (/identity/register)**: Use /identity/oauth2/dcr/v1.1
* Removed features and functionalities
	* **H2 Console**
	* **Embedded LDAP user store**
	* **Carbon metrics**
	* **Yahoo authenticator**
	* **Legacy OpenID authentication**
	* **reCAPTCHA v2 "I'm not a robot" Checkbox**
	* **Hazelcast DNS based pod discovery in Kubernetes membership scheme**

## Database utilizzati da WSO2 Identity Server

### WSO2IDENTITY_DB
* deployment.toml section: [database.identity_db]
* Source script v5.11.0: [<IS_HOME>/dbscripts/identity/](/is/wso2is-5.11.0/dbscripts/identity/)
* Source script v6.0.0: [<IS_HOME>/dbscripts/identity/](/am/wso2is-6.0.0/dbscripts/identity/)

### WSO2SHARED_DB
* deployment.toml section: [database.shared_db]
* Source script v5.11.0: [<IS_HOME>/dbscripts/](/is/wso2is-5.11.0/dbscripts/)
* Source script v6.0.0: [<IS_HOME>/dbscripts/](/is/wso2is-6.0.0/dbscripts/)

### WSO2UMA_DB
* Verificare se è stato separato dal WSO2IDENTITY_DB

### WSO2CONSENT_DB
* Verificare se è stato separato dal WSO2IDENTITY_DB

### WSO2CARBON_DB
* deployment.toml section: [database.local]
* Source script v5.11.0: [<IS_HOME>/dbscripts/](/is/wso2is-5.11.0/dbscripts/)
* Source script v6.0.0: [<IS_HOME>/dbscripts/](/is/wso2is-6.0.0/dbscripts/)
* **Note:** *By default WSO2CARBON_DB will be an embedded H2 database and it is not necessary to change it to another database. But if you have a requirement to change it, make sure that each server node have its own WSO2CARBON_DB*

## Verifica delle differenze nella struttura tra i DB Postgres
* [511to600](/is/511to600/db/postgres/)