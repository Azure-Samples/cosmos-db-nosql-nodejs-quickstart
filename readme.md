<!--
---
page_type: sample
name: "Quickstart: Azure Cosmos DB for NoSQL and Azure SDK for Node.js"
description: This is a simple Express web application to illustrate common basic usage of Azure Cosmos DB for NoSQL and the Azure SDK for Node.js.
urlFragment: template
languages:
- typescript
- javascript
- azdeveloper
products:
- azure-cosmos-db
---
-->

# Quickstart: Azure Cosmos DB for NoSQL - Azure SDK for Node.js

This is a simple Express web application to illustrate common basic usage of Azure Cosmos DB for NoSQL with the Azure SDK for Node.js.

## Prerequisites

- [Docker](https://www.docker.com/)
- [Azure Developer CLI](https://aka.ms/azd-install)
- [Node.js 22 or newer](https://nodejs.org/)

## Quickstart

1. Log in to Azure Developer CLI. *This is only required once per-install.*

    ```bash
    azd auth login
    ```

1. Initialize this template (`cosmos-db-nosql-nodejs-quickstart`) using `azd init`

    ```bash
    azd init --template cosmos-db-nosql-nodejs-quickstart
    ```

1. Ensure that **Docker** is running in your environment.

1. Use `azd up` to provision your Azure infrastructure and deploy the web application to Azure.

    ```bash
    azd up
    ```

1. Observed the deployed web application

    ![Screenshot of the deployed JavaScript web application.](assets/web-js.png)

    ![Screenshot of the deployed TypeScript web application.](assets/web-ts.png)

1. (Optionally) Run this web application locally in either the `src/js` or `src/ts` folders:

    ```bash
    npm install
    npm run dev
    ```
