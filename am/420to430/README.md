# Aggiornamento di WSO2 API Manager dalla versione 4.2.0 alla versione 4.3.0

## Documentazione di riferimento per WSO2 Api Manager

### AM 4.2.0
* [Docs](https://apim.docs.wso2.com/en/4.2.0/)
* [Release Notes](https://apim.docs.wso2.com/en/4.2.0/get-started/about-this-release/)
* [Reference](https://apim.docs.wso2.com/en/4.2.0/reference/product-apis/overview/)
* [DB Docs](https://apim.docs.wso2.com/en/4.2.0/install-and-setup/setup/setting-up-databases/changing-default-databases/changing-to-postgresql/)

#### [AM 4.2.0 Deprecated & Removed features](https://apim.docs.wso2.com/en/4.2.0/get-started/about-this-release/#deprecated-features-and-functionalities)
* Deprecated features and functionalities
    * **Synchronous Data Retrieval Mode in Gateway Runtime Artifact Synchronization**

        Synchronization was configurable by setting the value of `data_retrieval_mode` to `sync` (`data_retrieval_mode = "sync"`) in deployment.toml.
        ```
        [apim.sync_runtime_artifacts.gateway]
        data_retrieval_mode = "sync"
        ```
        The support for this mode is now deprecated from WSO2 API Manager 4.2.0 onwards. Therefore, it is recommended to use the `async` mode only.
* Removed features and functionalities
    * **Support for Jaggery apps from API Manager**

        In previous releases, webapps of API-Manager were dependant on the deprecated [Jaggery.js](https://github.com/wso2/jaggery) Javascript framework. From this version onwards all the webapps will be using JSP as the server-side language. Therefore, the capability to deploy Jaggery apps in WSO2 API Manager is removed from this release onwards.
    * **JDK 8 support**

        JDK 8 support is removed from  WSO2 API Manager 4.2.0 onwards.
    * **Publisher and Devportal profiles**

        The `api-publisher` and `api-devportal` profiles, which were deprecated in previous releases, are no longer supported in API Manager 4.2.0 and beyond. To perform tasks previously handled by these profiles, use the `control-pane` profile instead.
* Compatible WSO2 product versions
    * WSO2 API Manager 4.2.0 is compatible with WSO2 Identity Server 6.0.0 and 6.1.0.
    * WSO2 API Manager 4.2.0 is compatible with Choreo Connect 1.2.0.

### AM 4.3.0
* [Docs](https://apim.docs.wso2.com/en/4.3.0/)
* [Release Notes](https://apim.docs.wso2.com/en/4.3.0/get-started/about-this-release/)
* [Reference](https://apim.docs.wso2.com/en/4.3.0/reference/product-apis/overview/)
* [DB Docs](https://apim.docs.wso2.com/en/4.3.0/install-and-setup/setup/setting-up-databases/changing-default-databases/changing-to-postgresql/)

#### [AM 4.3.0 Deprecated & Removed features](https://apim.docs.wso2.com/en/4.3.0/get-started/about-this-release/#deprecated-features-and-functionalities)
* Deprecated features and functionalities
    * **SSE Streaming API support**

        The support for creating and using Server Sent Events (SSE) Streaming APIs will be deprecated from APIM 4.3.0.
* Removed features and functionalities
    * **Choreo Connect**
* Compatible WSO2 product versions
    * WSO2 API Manager 4.3.0 is compatible with WSO2 Identity Server 6.1.0.
    * WSO2 API Manager 4.3.0 is compatible with WSO2 API Platform for Kubernetes (APK) version 1.1.0.

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
