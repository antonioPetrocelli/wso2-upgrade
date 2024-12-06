# Upgrading WSO2 Micro Integrator: steps needed

1. Setting Up a new Deployment

    Begin with establishing a new deployment environment for WSO2 MI, ensuring you don’t disrupt your existing setup. This approach allows for a seamless transition and testing phase before going live. A new upgrade environment is  preferable over an in-place upgrade, so as not to interfere with ongoing development work and reduce the switching downtime.
    
    1.1 Install WSO2 MI in the new environment whitout start it.

2. Migrating Configurations from older version

    2.1. deployment.toml
    2.2. log4j2.properties
    2.3. Java KeyStores
    2.4. Custom components (libs, jars etc ...)
    2.5. Check java version compatibility for custom component

4. Database Migration

    4.1. Copy the old database in a new one
    4.2. Check the database structure differences and create db scripts to reflect the differences in the new database
    4.3. Apply database scripts to the new database for upgrade it to the new version

5. Start the application

6. Testing

7. Change Load Balancer config to point to the new environment