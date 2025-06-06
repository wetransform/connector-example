# Connector Example
This repository contains an example deployment of 4 EDC instances with an UI, showcasing data transfer between a provider and multiple participants using OAuth2-based Identification.

## How to run

> [!IMPORTANT]
> This is the development environment which does not host the connectors themselves.

Setting up the development environment includes four steps: cloning the repositories, setting up the connectors in your IDE (this guide describes IntelliJ to set up), starting the components, and initializing the project. Alternatively, to setting up the connectors in your IDE, you can also start the connectors from the `docker-compose-connectors.yaml`

1. Clone this repository to the directory `connector-example` and clone the [connector](https://github.com/wetransform/connector) repository to `connector`.
2. Open the connector with your IDE and add two **Gradle** Run/Debug Configurations with their respective environments (skip these steps if you opt running the connectors in a docker compose):
   1. Name: `edc-forest-owner-a`, Run: `:launchers:connector:runShadow --info`, Gradle project: `connector`, Environment variables:
      ```
      EDC_AGENT_IDENTITY_KEY=participant_id;EDC_DATAPLANE_API_PUBLIC_BASEURL=http://host.docker.internal:30291/public;EDC_DATAPLANE_PROXY_PUBLIC_ENDPOINT=http://host.docker.internal:30291/public;EDC_DATASOURCE_DEFAULT_PASSWORD=postgres;EDC_DATASOURCE_DEFAULT_URL=jdbc:postgresql://host.docker.internal:5432/dataspace?currentSchema=forestownera;EDC_DATASOURCE_DEFAULT_USER=user;EDC_DSP_CALLBACK_ADDRESS=http://host.docker.internal:30194/protocol;EDC_OAUTH_CERTIFICATE_ALIAS=public-key;EDC_OAUTH_CLIENT_ID=forest-owner-a;EDC_OAUTH_PRIVATE_KEY_ALIAS=private-key;EDC_OAUTH_PROVIDER_AUDIENCE=http://host.docker.internal:8080/realms/dataspace;EDC_OAUTH_PROVIDER_JWKS_URL=http://host.docker.internal:8080/realms/dataspace/protocol/openid-connect/certs;EDC_OAUTH_TOKEN_URL=http://host.docker.internal:8080/realms/dataspace/protocol/openid-connect/token;EDC_OAUTH_VALIDATION_ISSUED_AT_LEEWAY=5;EDC_OAUTH_VALIDATION_NBF_LEEWAY=20;EDC_PARTICIPANT_ID=company-forest-owner-a;EDC_PUBLIC_KEY_ALIAS=public-key;EDC_SQL_SCHEMA_AUTOCREATE=true;EDC_TRANSFER_PROXY_TOKEN_SIGNER_PRIVATEKEY_ALIAS=private-key;EDC_TRANSFER_PROXY_TOKEN_VERIFIER_PUBLICKEY_ALIAS=public-key;LOG_LEVEL=info;WEB_HTTP_CATALOG_PATH=/catalog;WEB_HTTP_CATALOG_PORT=20199;WEB_HTTP_CONTROL_PATH=/control;WEB_HTTP_CONTROL_PORT=20192;WEB_HTTP_MANAGEMENT_PATH=/management;WEB_HTTP_MANAGEMENT_PORT=20193;WEB_HTTP_PATH=/api;WEB_HTTP_PORT=20191;WEB_HTTP_PROTOCOL_PATH=/protocol;WEB_HTTP_PROTOCOL_PORT=20194;WEB_HTTP_PUBLIC_PATH=/public;WEB_HTTP_PUBLIC_PORT=20291;EDC_TOKEN_CLAIMS_TO_COPY=geofence:geofence;EDC_NODES_FILE_PATH=/path/to/connector-example/edc/nodes.properties;EDC_VAULT_FILE_PATH=/path/to/connector-example/edc/vault.properties
      ```
      _Note: Make sure to adjust `EDC_NODES_FILE_PATH` to the correct path containing the federated catalog endpoints and `EDC_VAULT_FILE_PATH` to contain the vault path._
   2. Name: `edc-forest-owner-b`, Run: `:launchers:connector:runShadow --info`, Gradle project: `connector`, Environment variables:
      ```
      EDC_AGENT_IDENTITY_KEY=participant_id;EDC_DATAPLANE_API_PUBLIC_BASEURL=http://host.docker.internal:31291/public;EDC_DATAPLANE_PROXY_PUBLIC_ENDPOINT=http://host.docker.internal:31291/public;EDC_DATASOURCE_DEFAULT_PASSWORD=postgres;EDC_DATASOURCE_DEFAULT_URL=jdbc:postgresql://host.docker.internal:5432/dataspace?currentSchema=forestownerb;EDC_DATASOURCE_DEFAULT_USER=user;EDC_DSP_CALLBACK_ADDRESS=http://host.docker.internal:31194/protocol;EDC_OAUTH_CERTIFICATE_ALIAS=public-key;EDC_OAUTH_CLIENT_ID=forest-owner-b;EDC_OAUTH_PRIVATE_KEY_ALIAS=private-key;EDC_OAUTH_PROVIDER_AUDIENCE=http://host.docker.internal:8080/realms/dataspace;EDC_OAUTH_PROVIDER_JWKS_URL=http://host.docker.internal:8080/realms/dataspace/protocol/openid-connect/certs;EDC_OAUTH_TOKEN_URL=http://host.docker.internal:8080/realms/dataspace/protocol/openid-connect/token;EDC_OAUTH_VALIDATION_ISSUED_AT_LEEWAY=5;EDC_OAUTH_VALIDATION_NBF_LEEWAY=20;EDC_PARTICIPANT_ID=company-forest-owner-b;EDC_PUBLIC_KEY_ALIAS=public-key;EDC_SQL_SCHEMA_AUTOCREATE=true;EDC_TRANSFER_PROXY_TOKEN_SIGNER_PRIVATEKEY_ALIAS=private-key;EDC_TRANSFER_PROXY_TOKEN_VERIFIER_PUBLICKEY_ALIAS=public-key;LOG_LEVEL=info;WEB_HTTP_CATALOG_PATH=/catalog;WEB_HTTP_CATALOG_PORT=21199;WEB_HTTP_CONTROL_PATH=/control;WEB_HTTP_CONTROL_PORT=21192;WEB_HTTP_MANAGEMENT_PATH=/management;WEB_HTTP_MANAGEMENT_PORT=21193;WEB_HTTP_PATH=/api;WEB_HTTP_PORT=21191;WEB_HTTP_PROTOCOL_PATH=/protocol;WEB_HTTP_PROTOCOL_PORT=21194;WEB_HTTP_PUBLIC_PATH=/public;WEB_HTTP_PUBLIC_PORT=21291;EDC_TOKEN_CLAIMS_TO_COPY=geofence:geofence;EDC_NODES_FILE_PATH=/path/to/connector-example/edc/nodes.properties;EDC_VAULT_FILE_PATH=/path/to/connector-example/edc/vault.properties
      ```
      _Note: Make sure to adjust `EDC_NODES_FILE_PATH` to the correct path containing the federated catalog endpoints and `EDC_VAULT_FILE_PATH` to contain the vault path._
   3. Name: `edc-forest-owner-c`, Run: `:launchers:connector:runShadow --info`, Gradle project: `connector`, Environment variables:
      ```
      EDC_AGENT_IDENTITY_KEY=participant_id;EDC_DATAPLANE_API_PUBLIC_BASEURL=http://host.docker.internal:33291/public;EDC_DATAPLANE_PROXY_PUBLIC_ENDPOINT=http://host.docker.internal:33291/public;EDC_DATASOURCE_DEFAULT_PASSWORD=postgres;EDC_DATASOURCE_DEFAULT_URL=jdbc:postgresql://host.docker.internal:5432/dataspace?currentSchema=forestownerc;EDC_DATASOURCE_DEFAULT_USER=user;EDC_DSP_CALLBACK_ADDRESS=http://host.docker.internal:33194/protocol;EDC_OAUTH_CERTIFICATE_ALIAS=public-key;EDC_OAUTH_CLIENT_ID=forest-owner-c;EDC_OAUTH_PRIVATE_KEY_ALIAS=private-key;EDC_OAUTH_PROVIDER_AUDIENCE=http://host.docker.internal:8080/realms/dataspace;EDC_OAUTH_PROVIDER_JWKS_URL=http://host.docker.internal:8080/realms/dataspace/protocol/openid-connect/certs;EDC_OAUTH_TOKEN_URL=http://host.docker.internal:8080/realms/dataspace/protocol/openid-connect/token;EDC_OAUTH_VALIDATION_ISSUED_AT_LEEWAY=5;EDC_OAUTH_VALIDATION_NBF_LEEWAY=20;EDC_PARTICIPANT_ID=company-forest-owner-c;EDC_PUBLIC_KEY_ALIAS=public-key;EDC_SQL_SCHEMA_AUTOCREATE=true;EDC_TRANSFER_PROXY_TOKEN_SIGNER_PRIVATEKEY_ALIAS=private-key;EDC_TRANSFER_PROXY_TOKEN_VERIFIER_PUBLICKEY_ALIAS=public-key;LOG_LEVEL=info;WEB_HTTP_CATALOG_PATH=/catalog;WEB_HTTP_CATALOG_PORT=23199;WEB_HTTP_CONTROL_PATH=/control;WEB_HTTP_CONTROL_PORT=23192;WEB_HTTP_MANAGEMENT_PATH=/management;WEB_HTTP_MANAGEMENT_PORT=23193;WEB_HTTP_PATH=/api;WEB_HTTP_PORT=23191;WEB_HTTP_PROTOCOL_PATH=/protocol;WEB_HTTP_PROTOCOL_PORT=23194;WEB_HTTP_PUBLIC_PATH=/public;WEB_HTTP_PUBLIC_PORT=23291;EDC_TOKEN_CLAIMS_TO_COPY=geofence:geofence;EDC_NODES_FILE_PATH=/path/to/connector-example/edc/nodes.properties;EDC_VAULT_FILE_PATH=/path/to/connector-example/edc/vault.properties
      ```
      _Note: Make sure to adjust `EDC_NODES_FILE_PATH` to the correct path containing the federated catalog endpoints and `EDC_VAULT_FILE_PATH` to contain the vault path._
   4. Name: `forest-inventory-researcher`, Run: `:launchers:connector:runShadow --info`, Gradle project: `connector`, Environment variables:
      ```
      EDC_AGENT_IDENTITY_KEY=participant_id;EDC_DATAPLANE_API_PUBLIC_BASEURL=http://host.docker.internal:32291/public;EDC_DATAPLANE_PROXY_PUBLIC_ENDPOINT=http://host.docker.internal:32291/public;EDC_DATASOURCE_DEFAULT_PASSWORD=postgres;EDC_DATASOURCE_DEFAULT_URL=jdbc:postgresql://host.docker.internal:5432/dataspace?currentSchema=inventoryresearcher;EDC_DATASOURCE_DEFAULT_USER=user;EDC_DSP_CALLBACK_ADDRESS=http://host.docker.internal:33194/protocol;EDC_OAUTH_CERTIFICATE_ALIAS=public-key;EDC_OAUTH_CLIENT_ID=forest-inventory-researcher;EDC_OAUTH_PRIVATE_KEY_ALIAS=private-key;EDC_OAUTH_PROVIDER_AUDIENCE=http://host.docker.internal:8080/realms/dataspace;EDC_OAUTH_PROVIDER_JWKS_URL=http://host.docker.internal:8080/realms/dataspace/protocol/openid-connect/certs;EDC_OAUTH_TOKEN_URL=http://host.docker.internal:8080/realms/dataspace/protocol/openid-connect/token;EDC_OAUTH_VALIDATION_ISSUED_AT_LEEWAY=5;EDC_OAUTH_VALIDATION_NBF_LEEWAY=20;EDC_PARTICIPANT_ID=company-forest-inventory-researcher;EDC_PUBLIC_KEY_ALIAS=public-key;EDC_SQL_SCHEMA_AUTOCREATE=true;EDC_TRANSFER_PROXY_TOKEN_SIGNER_PRIVATEKEY_ALIAS=private-key;EDC_TRANSFER_PROXY_TOKEN_VERIFIER_PUBLICKEY_ALIAS=public-key;LOG_LEVEL=info;WEB_HTTP_CATALOG_PATH=/catalog;WEB_HTTP_CATALOG_PORT=22199;WEB_HTTP_CONTROL_PATH=/control;WEB_HTTP_CONTROL_PORT=22192;WEB_HTTP_MANAGEMENT_PATH=/management;WEB_HTTP_MANAGEMENT_PORT=22193;WEB_HTTP_PATH=/api;WEB_HTTP_PORT=22191;WEB_HTTP_PROTOCOL_PATH=/protocol;WEB_HTTP_PROTOCOL_PORT=22194;WEB_HTTP_PUBLIC_PATH=/public;WEB_HTTP_PUBLIC_PORT=22291;EDC_TOKEN_CLAIMS_TO_COPY=geofence:geofence;EDC_NODES_FILE_PATH=/path/to/connector-example/edc/nodes.properties;EDC_VAULT_FILE_PATH=/path/to/connector-example/edc/vault.properties
      ```
      _Note: Make sure to adjust `EDC_NODES_FILE_PATH` to the correct path containing the federated catalog endpoints and `EDC_VAULT_FILE_PATH` to contain the vault path._
3. In `connector-example`, run `docker compose up -d`.
4.  After the services are started up, start the connectors:
   1. If you run the instances in your IDE, run all four configurations, `edc-forest-owner-a`, `edc-forest-owner-b`, `edc-forest-owner-c` and `forest-inventory-researcher`, in parallel.
   2. Otherwise if you are running the connectors via docker, run `docker compose -f docker-compose-connectors.yaml up -d`
5. To add the initial data sets to your setup, run in the `connector-example`-directory following: `EDC_BASE_URL=http://host.docker.internal:20193 ./initialization/init.sh` (This step is only necessary at the initial installation.)

Ressources available at:
- The EDC components are available on the 20xxx-Ports without and 30xxx-Ports with a MITM-setup.
- The Portals are available on [http://localhost:8085](http://localhost:8085), [http://localhost:8086](http://localhost:8086), [http://localhost:8087](http://localhost:8087), [http://localhost:8089](http://localhost:8089)
- The MITM that logs all http-communication except between the browser and the portal (use the developer console of your browser for that) runs on [http://localhost:9081/?token=edc-mitm](http://localhost:9081/?token=edc-mitm) with the token/password `edc-mitm`
- Keycloak runs on port 7080 but it's supposed to be accessed through the mitm only on port 8080: [http://localhost:8080](http://localhost:8080) with the username `admin` and password `admin`
- Datasets Nginx: [http://localhost:8088](http://localhost:8088)

## Components
### Keycloak
This deployment uses Keycloak for identity and access management to realize communication between the two Eclipse Dataspace Connectors.

### EDC
Each of the participants has their own EDC Instance configured to authenticate with Keycloak.

- **Assets**: Ressources defined with metadata, which can be shared with the Connector.

- **Policies**: Used to define guideline for the usage of an Asset. **Usage Policies** define who can use the offered Asset and **Access Policies** define who can see the Asset in the Catalog. The predefined Policies in this example include time-based, identity-based or geographic restrictions.

- **Contract Defintions**: The contract defintion is used to assign **Access and Usage Policies** to an Asset.

- **Catalog**: The Catalog lists all offers available for each participant depending on their assigned attributes.

- **Contract Agreements**: A Contract Agreement is the formal agreement that arises after the acceptance of the Contract Offer by the Consumer.


### Portal
Each participant has its own portal deployment, which allows assets, policies and contract definitions to be created via a user interface, enabling quick and easy data transfer between participants via the EDC. Each of the ressources listed in the [EDC Section](###EDC) is accesible and configurable with the Portals UI.

### PostgreSQL
In this deployment the PostgreSQL Database is by default configured to the control- and dataplane state.

### Datasets - Nginx
This example uses Nginx to serve datasets via HTTP to showcase how data can be made available over the EDC as an Asset. This is only used for demonstration purposes.

### EDC communication visualization
<img src="doc/images/edc_communication.png" alt="communication" />
