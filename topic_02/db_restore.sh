#!/bin/bash

# Load external variables
source ./variables.env

# Create a storage account SAS token
SAS_TOKEN=$(az storage account generate-sas --permissions rl --account-name $STORAGE_ACCOUNT --services b --resource-types o --expiry $(date -u -d "1 day" '+%Y-%m-%dT%H:%MZ') --output tsv)

# Restore the database
az sql db import \
    --admin-user "$ADMIN_USER" \
    --admin-password "$ADMIN_PASSWORD" \
    --storage-key "$SAS_TOKEN" \
    --storage-key-type "SharedAccessKey" \
    --storage-uri "https://${STORAGE_ACCOUNT}.blob.core.windows.net/${STORAGE_CONTAINER}/${BACKUP_NAME}" \
    --name $DATABASE_NAME \
    --server $SQL_SERVER \
    --resource-group $RESOURCE_GROUP

if [ $? -eq 0 ]; then
    echo "Restore completed successfully"
else
    echo "Restore failed"
    exit 1
fi
