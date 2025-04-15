# LegacyAppAspire

## Aspire

Using Aspire with a Legacy Web Application
This document provides a guide for setting up and running a legacy web application using Aspire, a framework designed to simplify distributed application development.

### Prerequisites
Before proceeding, ensure you have the following installed:

- .NET 9 SDK
- Docker (for containerized deployments)
- Azure CLI (for Azure Key Vault and Application Insights integration)
- SQL Server (for database integration)

### Solution Overview

This solution demonstrates how to use Aspire to configure and run a legacy web application. Key features include:

- Azure Key Vault Integration: Securely manage secrets and configuration.
- Application Insights: Monitor application performance and diagnostics.
- SQL Server Integration: Persistent database support.
- Docker Compose: Simplified containerized deployments.


## Infrastructure

Migrating a Legacy Application to Azure Using Bicep
This repository provides a sample solution for migrating a legacy application to Azure. It demonstrates how to use Azure Bicep to define and deploy the necessary infrastructure for a modernized cloud environment. The solution is designed to address common requirements such as containerization, database migration, monitoring, and security.

### Overview

The solution includes the following components:

- Azure Container Registry (ACR): For storing and managing container images.
- Azure SQL Database: For hosting the application's relational database.
- Azure Application Insights and Log Analytics: For monitoring and diagnostics.
- Azure Key Vault: For securely managing secrets and application settings.
- Azure App Service Plan and Web App: For hosting the application.
- Infrastructure as Code (IaC): Defined using Bicep files for repeatable and consistent deployments.

### Architecture

The architecture is modular, with each component defined in its own Bicep module. The main.bicep file orchestrates the deployment of these modules. Below is a high-level overview of the architecture:

1.	Container Registry: Stores container images for the application.
2.	SQL Database: Hosts the application's data, with secure access and optional public network restrictions.
3.	Application Insights and Log Analytics: Provides observability for the application.
4.	Key Vault: Manages sensitive information such as database credentials.
5.	App Service Plan and Web App: Hosts the application, integrates with other services, and supports system-assigned managed identities.

### Prerequisites

Before deploying this solution, ensure you have the following:

- Azure CLI: Installed and authenticated.
- Bicep CLI: Installed (or use the built-in support in Azure CLI).
- Azure Subscription: With sufficient permissions to create resources.
- Resource Group: Pre-created or specify a new one during deployment.

