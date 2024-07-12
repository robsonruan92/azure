# Azure SQL Database Backup and Restore Automation

This repository contains scripts to automate the backup and restore process for an Azure SQL Database using Azure CLI and Bash scripting.

## Prerequisites
- Azure CLI installed
- Logged in to Azure CLI (`az login`)
- Azure SQL Database and Storage Account already created

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

### Using cron jobs
- Add the scripts to a Linux server with the Azure CLI installed.
- Schedule the scripts using cron.

### Cron Job Setup

Open the cron job editor:

`crontab -e`

Add the following lines to schedule the backup script to run daily at midnight:


`0 0 * * * /backup.sh >> /path/to/backup.log 2>&1`

### Listing Available Backups

To list available backups and their details, use the following Azure CLI command:

`az storage account list  \`
`    --account-name $STORAGE_ACCOUNT \`
`    --container-name $STORAGE_CONTAINER \`
`    --output table`

### Running the Scripts

Make sure both `db_backup.sh` and `db_restore.sh` scripts are executable:
`chmod +x db_backup.sh db_restore.sh`

Run the backup script:
`./db_backup.sh`

Run the restore script:
`./db_restore.sh`