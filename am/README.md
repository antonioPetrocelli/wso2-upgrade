# Aggiornamento di WSO2 API Manager

1. Preparare un nuovo ambiente di deploy.

    Un nuovo ambiente di aggiornamento è preferibile rispetto ad un aggiornamento in-place, in modo da non interferire con il lavoro di sviluppo in corso, ridurre i tempi di inattività della migrazione e non interrompere la configurazione esistente. Questo approccio consente una transizione senza soluzione di continuità e una fase di test prima della messa in funzione. 
    
    1.1. Installare WSO2 APIM nel nuovo ambiente senza avviarlo.
    1.2. Aggiornare WSO2 APIM all'ultimo patch level.

2. Migrazione delle configurazioni dalla versione precedente.

    2.1. deployment.toml.
    2.2. log4j2.properties.
    2.3. Java KeyStores.
    2.4. Custom components (libs, jars etc ...).
    2.5. Controllare la compatibilità della versione Java per i custom components.

4. Migrazione del database.

    4.1. Preparare una copia del vecchio database (dump di struttura e dati).
    4.2. Controllare le differenze nella struttura dei database e creare gli script di aggiornamento.
    4.3. Applicare gli script di aggioramento sul nuovo database.

5. Avviare l'applicazione.

6. Test.

7. Modificare la configurazione del Load Balancer per farlo puntare al nuovo ambiente.

## Upgrades documentati

|Product                |From Version   |To Version |Docs                      |
|-----------------------|---------------|-----------|--------------------------|
|Wso2 API Manager       |4.1.0          |4.2.0      |[410to420](/am/410to420/) |
|Wso2 API Manager       |4.1.0          |4.2.0      |[420to430](/am/420to430/) |