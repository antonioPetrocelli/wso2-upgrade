# WSO2 Upgrade
 Linee guida per l'aggiornamento di Wso2 API Manager, Identity Server e Micro Integrator

|Redatto da    |Antonio Petrocelli                   |
|--------------|-------------------------------------|
|Aggiornato da |Antonio Petrocelli                   |
|Versione: 1.0 |Data: 13/12/2024 - Bozza             |

La presente documentazione illustra gli step necessari per aggiornare le versioni dei seguenti prodotti WSO2

|Product                |From Version   |To Version |Guidelines          |Docs                      |
|-----------------------|---------------|-----------|--------------------|--------------------------|
|Wso2 API Manager       |4.1.0          |4.2.0      |[am](/am/README.md) |[410to420](/am/410to420/) |
|Wso2 API Manager       |4.1.0          |4.2.0      |                    |[420to430](/am/420to430/) |
|Wso2 Identity Server   |5.11.0         |6.0.0      |[is](/is/README.md) |[511to600](/is/511to600/) |
|Wso2 Identity Server   |6.0.0          |6.1.0      |                    |[600to610](/is/600to610/) |
|Wso2 Micro Integrator  |4.2.0          |4.3.0      |[mi](/mi/README.md) |[420to430](/mi/420to430/) |

## To Do
* Verificare la sintassi degli script PostGres per ADD, ALTER e DROP CONSTRAINT
* Verificare se WSO2UMA_DB e WSO2CONSENT_DB sono stati separati dal WSO2IDENTITY_DB
* Verificare uso di [apim.sync_runtime_artifacts.gateway] in <APIM_HOME>/repository/conf/deployment.toml: in 4.2.0 it is recommended to use the `async` mode only
* Release Notes: controllare se sono usate le funzionalità deprecate e/o dismesse