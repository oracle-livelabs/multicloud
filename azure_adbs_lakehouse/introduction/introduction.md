# Introduction

## Introduction

Oracle Autonomous AI Database Lakehouse on Oracle AI Database@Azure provides a governed lakehouse close to Azure applications. It combines Autonomous AI Database performance, security, and automated management with access to data in Azure Blob Storage.

In the event-account track, you use an Azure account and resources prepared for you. Azure Blob Storage holds the source CSV and JSON files. Autonomous AI Database exposes those files as external tables, combines them with managed database data, and supplies SQL access and governance without requiring the source data to be copied into the database.

![Autonomous AI Lakehouse architecture](images/lakehouse-architecture.png " ")

Select AI connects the approved database objects to Azure OpenAI. Participants can ask business questions in natural language, review the generated Oracle SQL, and run the query against the governed lakehouse data.

![Lakehouse data and AI workflow](images/lakehouse-workflow.png " ")

### Objectives

In this workshop, you will:

- Identify the roles of Azure Blob Storage, Autonomous AI Database, Select AI, and Azure OpenAI
- Describe how external tables provide SQL access to data stored in Azure
- Understand how the workshop turns natural-language questions into governed SQL queries

Estimated Workshop Time: 1 hour 30 minutes

## Acknowledgements

- **Author** - Oracle Multicloud Team
- **Last Updated By/Date** - Oracle LiveLabs, October 2026
