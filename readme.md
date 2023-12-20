---
page_type: sample
languages:
- azdeveloper
- nodejs
- bicep
- javascript
- html
products:
- azure
- azure-cosmos-db
- azure-container-apps
- azure-container-registry
urlFragment: azd
name: Sample Express and Node.js application for Azure Cosmos DB for NoSQL
description: This is a simple Express web application to illustrate common basic usage of Azure Cosmos DB for NoSQL's client library for Node.js. This sample application accesses an existing account, database, and container using the @azure/cosmos and @azure/identity packages.
---

# Quickstart: Azure Cosmos DB for NoSQL client library for Node.js

[![Open in GitHub Codespaces](https://img.shields.io/static/v1?style=for-the-badge&label=GitHub+Codespaces&message=Open&color=brightgreen&logo=github)](https://codespaces.new/Azure-Samples/cosmos-db-nosql-nodejs-quickstart?quickstart=1)
[![Open in Dev Container](https://img.shields.io/static/v1?style=for-the-badge&label=Dev+Containers&message=Open&color=blue&logo=visualstudiocode)](https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/Azure-Samples/cosmos-db-nosql-nodejs-quickstart)

This is a simple Express web application to illustrate common basic usage of Azure Cosmos DB for NoSQL's client library for Node.js. This sample application accesses an existing account, database, and container using the [`@azure/cosmos`](https://www.npmjs.com/package/@azure/cosmos) and [`@azure/identity`](https://www.npmjs.com/package/@azure/identity) packages. Modify the source code and leverage the Infrastructure as Code (IaC) Bicep assets to get up and running quickly.

When you are finished, you will have a fully functional web application deployed to Azure.

![Screenshot of the deployed web application.](assets/web.png)

### Prerequisites

> This template will create infrastructure and deploy code to Azure. If you don't have an Azure Subscription, you can sign up for a [free account here](https://azure.microsoft.com/free/). Make sure you have the contributor role in the Azure subscription.

The following prerequisites are required to use this application. Please ensure that you have them all installed locally.

- [Azure Developer CLI](https://aka.ms/azd-install)
- [Node.js 20 or newer](https://nodejs.org/)

### Quickstart

To learn how to get started with any template, follow the steps in [this quickstart](https://learn.microsoft.com/azure/cosmos-db/nosql/quickstart-nodejs) with this template (`cosmos-db-nosql-nodejs-quickstart`).

This quickstart will show you how to authenticate on Azure, initialize using a template, provision infrastructure and deploy code on Azure via the following commands:

```bash
# Log in to azd. Only required once per-install.
azd auth login

# First-time project setup. Initialize a project in the current directory, using this template.
# Omit the --template argument if you are running in a development container.
azd init --template cosmos-db-nosql-nodejs-quickstart

# Provision and deploy to Azure
azd up
```

### Application Architecture

This application utilizes the following Azure resources:

- [**Azure Container Registry**](https://learn.microsoft.com/azure/container-registry/)
    - This services hosts the container image.
- [**Azure Container Apps**](https://learn.microsoft.com/azure/container-apps/)
    - This service hosts the Express web application.
- [**Azure Cosmos DB for NoSQL**](https://learn.microsoft.com/azure/cosmos-db/) 
    - This service stores the NoSQL data.

Here's a high level architecture diagram that illustrates these components. Notice that these are all contained within a single **resource group**, that will be created for you when you create the resources.

```mermaid
%%{ init: { 'theme': 'base', 'themeVariables': { 'background': '#243A5E', 'primaryColor': '#50E6FF', 'primaryBorderColor': '#243A5E', 'tertiaryBorderColor': '#50E6FF', 'tertiaryColor': '#243A5E', 'fontFamily': 'Segoe UI', 'lineColor': '#FFFFFF', 'primaryTextColor': '#243A5E', 'tertiaryTextColor': '#FFFFFF' } }}%%
flowchart TB
    subgraph web-app[Azure Container Apps]
        app-framework(["Node.js 20 | Express 4"])
    end
    subgraph cosmos-db[Azure Cosmos DB]
        subgraph database-cosmicworks[Database: cosmicworks]
            subgraph container-products[Container: products]
                prd-yamba[Product: Yamba Surfboard]
                prd-kiama-classic[Product: Kiama Classic Surfboard]
            end
        end
    end
    web-app --> cosmos-db
```

### Cost of provisioning and deploying this template

This template provisions resources to an Azure subscription that you will select upon provisioning them. Refer to the [Pricing calculator for Microsoft Azure](https://azure.microsoft.com/pricing/calculator/) to estimate the cost you might incur when this template is running on Azure and, if needed, update the included Azure resource definitions found in [`infra/main.bicep`](infra/main.bicep) to suit your needs.

### Application Code

This template is structured to follow the [Azure Developer CLI](https://aka.ms/azure-dev/overview). You can learn more about `azd` architecture in [the official documentation](https://learn.microsoft.com/azure/developer/azure-developer-cli/make-azd-compatible?pivots=azd-create#understand-the-azd-architecture).

### Next Steps

At this point, you have a complete application deployed on Azure. But there is much more that the Azure Developer CLI can do. These next steps will introduce you to additional commands that will make creating applications on Azure much easier. Using the Azure Developer CLI, you can setup your pipelines, monitor your application, test and debug locally.

- [`azd pipeline config`](https://learn.microsoft.com/azure/developer/azure-developer-cli/configure-devops-pipeline?tabs=GitHub) - to configure a CI/CD pipeline (using GitHub Actions or Azure DevOps) to deploy your application whenever code is pushed to the main branch. 

- [Run and Debug Locally](https://learn.microsoft.com/azure/developer/azure-developer-cli/debug?pivots=ide-vs-code) - using Visual Studio Code and the Azure Developer CLI extension

- [`azd down`](https://learn.microsoft.com/azure/developer/azure-developer-cli/reference#azd-down) - to delete all the Azure resources created with this template 
