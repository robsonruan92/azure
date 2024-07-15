# Azure SQL Database Backup and Restore Automation

This repository contains scripts to automate the backup and restore process for an Azure SQL Database using Azure CLI and Bash scripting. This Bash script automates the process of restoring an Azure SQL Database from a backup stored in an Azure Storage account. 

## Prerequisites
- **[Azure CLI Step-by-step installation](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt#option-2-step-by-step-installation-instructions)**
- Logged in to Azure CLI (`az login`)
- Azure SQL Database and Storage Account already created (you can check ![](topic_01/) to configure a Azure SQL)

## 1. Backup Process
The `db_backup.sh` script schedules regular backups for an Azure SQL Database and stores them in a specified Azure Storage Account.

## 2. Restore Process

The `db_restore.sh` script restores the database from a specified backup.

## 3. Automation

Ensure the scripts can be scheduled to run at specified intervals. This can be done using Azure Automation or cron jobs.

### Using Azure Automation

- Create an Automation Account in the Azure portal.
- Add the scripts as Runbooks.
- Schedule the Runbooks to run at desired intervals.

### Running the Scripts

Make sure both `db_backup.sh` and `db_restore.sh` scripts are executable:
`chmod +x db_backup.sh db_restore.sh`

Run the backup script:
`./db_backup.sh`

Run the restore script:
`./db_restore.sh`