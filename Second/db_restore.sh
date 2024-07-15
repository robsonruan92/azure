#!/bin/bash

# Load external variables
source ./variables.env

# Function to write logs
function log_message() {
  local message="$1"
  echo "$(date +"%Y-%m-%d %H:%M:%S") - $message"
}
# Function to create SQL Database if not exists
function create_sql_database() {
  log_message "Creating SQL Database '$DATABASE_NAME' if it doesn't exist..."
  
  # Check if the database exists
  az sql db show \
    --name "$DATABASE_NAME" \
    --server "$SQL_SERVER" \
    --resource-group "$RESOURCE_GROUP" \
    --output none
  
  if [ $? -ne 0 ]; then
    # Database doesn't exist, create it
    az sql db create \
      --name "$DATABASE_NAME" \
      --server "$SQL_SERVER" \
      --resource-group "$RESOURCE_GROUP" \
      --service-objective Basic \
      --edition Basic \
      --collation "SQL_Latin1_General_CP1_CI_AS" \
      --admin-user "$ADMIN_USER" \
      --admin-password "$ADMIN_PASSWORD" \
      --output none
    
    if [ $? -eq 0 ]; then
      log_message "SQL Database '$DATABASE_NAME' created successfully."
    else
      log_message "Failed to create SQL Database '$DATABASE_NAME'."
      exit 1
    fi
  else
    log_message "SQL Database '$DATABASE_NAME' already exists."
  fi
}
# Function to generate a SAS token for the storage account
function generate_sas_token() {
  log_message "Generating SAS token for storage account '$STORAGE_ACCOUNT_NAME'..."
  
# Generate SAS token for storage account
SAS_TOKEN=$(az storage account generate-sas \
  --permissions cdlruwap \
  --account-name "$STORAGE_ACCOUNT_NAME" \
  --services b \
  --resource-types sco \
  --expiry $(date -u -d '1 year' +%Y-%m-%dT%H:%MZ) \
  --output tsv)

# Check if SAS_TOKEN is empty or not
if [ -z "$SAS_TOKEN" ]; then
  log_message "Failed to generate SAS token."
  exit 1
else
  log_message "SAS token generated successfully."
fi
}

# Function to restore SQL Database from backup
function restore_sql_database() {
  local BACKUP_NAME="$BACKUP_NAME"
  local storage_uri="https://${STORAGE_ACCOUNT_NAME}.blob.core.windows.net/${CONTAINER_NAME}/${BACKUP_NAME}"
  
  log_message "Restoring SQL Database '$DATABASE_NAME' from backup '$BACKUP_NAME'..."
  
  az sql db import \
    --admin-user "$ADMIN_USER" \
    --admin-password "$ADMIN_PASSWORD" \
    --storage-key "$SAS_TOKEN" \
    --storage-key-type "SharedAccessKey" \
    --storage-uri "$storage_uri" \
    --name "$DATABASE_NAME" \
    --server "$SQL_SERVER" \
    --resource-group "$RESOURCE_GROUP" \
    --output none
  
  if [ $? -eq 0 ]; then
    log_message "Restore of SQL Database '$DATABASE_NAME' completed successfully."
  else
    log_message "Failed to restore SQL Database '$DATABASE_NAME'."
    exit 1
  fi
}

# Main script execution
create_sql_database
generate_sas_token
restore_sql_database

exit 0