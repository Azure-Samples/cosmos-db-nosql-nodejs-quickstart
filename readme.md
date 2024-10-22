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

# Quickstart: Azure Cosmos DB for NoSQL client library for Node.js

This is a simple Express web application to illustrate common basic usage of Azure Cosmos DB for NoSQL's client library for Node.js. This sample application accesses an existing account, database, and container using the [`@azure/cosmos`](https://www.npmjs.com/package/@azure/cosmos) and [`@azure/identity`](https://www.npmjs.com/package/@azure/identity) packages.

### Prerequisites

- [Docker](https://www.docker.com/)
- [Azure Developer CLI](https://aka.ms/azd-install)
- [Node.js 22 or newer](https://nodejs.org/)

### Quickstart

1. Log in to Azure Developer CLI.

    ```bash
    azd auth login
    ```

    > [!TIP]
    > This is only required once per-install.

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

    ![Screenshot of the deployed web application.](assets/web.png)

1. (Optionally) Debug this web application locally. 

    1. In Visual Studio Code, start the debugging feature. For more information, see [debugging JavaScript in Visual Studio Code](https://code.visualstudio.com/docs/nodejs/nodejs-debugging) or [debugging TypeScript in Visual Studio Code](https://code.visualstudio.com/docs/typescript/typescript-debugging).

    1. Select the **** template.
    
    1. Visual Studio Code will dynamically generate a debug configuration.

    1. Debugging will use the Azure Cosmos DB for NoSQL account that was provisioned in a previous step.

        > [!IMPORTANT]
        > When your Azure infrastructure is provisioned, the endpoint for your deployed Azure Cosmos DB for NoSQL account is automatically saved in the *.env* file for both the JavaScript and TypeScript local projects to make debugging easier.
