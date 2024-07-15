#!/bin/bash

# Load external variables
source ./variables.env

# Function to write logs
log_message() {
  local message="$1"
  echo "$(date +"%Y-%m-%d %H:%M:%S") - $message"
}

# Function to show progress bar
show_progress() {
  while :; do
    for s in / - \\ \|; do
      printf "\r$s"
      sleep 0.1
    done
  done
}

# Check if necessary variables are set
if [ -z "$CONTAINER_NAME" ]; then
  echo "Error: CONTAINER_NAME is not set."
  exit 1
fi

if [ -z "$STORAGE_ACCOUNT_NAME" ]; then
  echo "Error: STORAGE_ACCOUNT_NAME is not set."
  exit 1
fi

# Function to create storage container if it doesn't exist
function create_container() {
  log_message "Creating container '$CONTAINER_NAME' if it doesn't exist..."
  
  az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME

  if [ $? -eq 0 ]; then
    log_message "Container '$CONTAINER_NAME' created or already exists."
  else
    log_message "Error creating container: $(tail -n 1 backup_log.txt)"
    exit 1
  fi
}

# Backup Function
backup_database() {
  local backup_name="autobackup-$(date +"%Y%m%d-%H%M%S")"
  local blob_uri="https://$STORAGE_ACCOUNT_NAME.blob.core.windows.net/$CONTAINER_NAME/$backup_name.bacpac"
  log_message "Backing up database '$DATABASE_NAME'..."

  # Generate a SAS token for the storage account
  log_message "Generating SAS token..."
  SAS_TOKEN=$(az storage account generate-sas \
    --permissions cdlruwap \
    --account-name "$STORAGE_ACCOUNT_NAME" \
    --services b \
    --resource-types sco \
    --expiry $(date -u -d '1 year' +%Y-%m-%dT%H:%MZ) \
    --output tsv)

  if [ -z "$SAS_TOKEN" ]; then
    log_message "Failed to generate SAS token."
    return 1
  fi

  # Check if the blob already exists and delete it if necessary
  log_message "Checking if blob exists..."
  blob_exists=$(az storage blob exists \
    --account-name "$STORAGE_ACCOUNT_NAME" \
    --container-name "$CONTAINER_NAME" \
    --name "$backup_name.bacpac" \
    --sas-token "$SAS_TOKEN" \
    --query "exists" \
    --output tsv)

  if [ "$blob_exists" == "true" ]; then
    log_message "Blob already exists. Deleting existing blob..."
    az storage blob delete \
      --account-name "$STORAGE_ACCOUNT_NAME" \
      --container-name "$CONTAINER_NAME" \
      --name "$backup_name.bacpac" \
      --sas-token "$SAS_TOKEN"
  fi

  log_message "Starting database export..."
  show_progress &  # Start the progress bar in the background
  progress_pid=$!

  az sql db export \
    --admin-user "$ADMIN_USER" \
    --admin-password "$ADMIN_PASSWORD" \
    --storage-key "$SAS_TOKEN" \
    --storage-key-type "SharedAccessKey" \
    --storage-uri "$blob_uri" \
    --name "$DATABASE_NAME" \
    --server "$SQL_SERVER" \
    --resource-group "$RESOURCE_GROUP" \
    >> backup_log.txt 2>&1

  if [ $? -eq 0 ]; then
    kill $progress_pid  # Stop the progress bar
    log_message "Backup '$backup_name' created successfully."
  else
    kill $progress_pid  # Stop the progress bar
    log_message "Error during backup: $(tail -n 1 backup_log.txt)"
  fi
}

# Call backup function
backup_database