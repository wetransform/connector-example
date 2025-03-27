# Connector Example
This repository contains an example deployment of 2 EDC instances with an UI, showcasing data transfer between a provider and a consumer using OAuth2-based Identification.

## How to run
To run on your local machine run:
```
docker compose up -d
```
Ressources available at:
- Portal provider: [http://localhost:8085](http://localhost:8085)
- Portal consumer: [http://localhost:8086](http://localhost:8086)
- Keycloak: [http://localhost:8080](http://localhost:8080)
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
