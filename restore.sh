#!/bin/sh
set -e
clear

BACKUP_PATH="/mnt/us/SO-BACKUP"

echo "Kindle-SORemover"
echo "RESTORE"
echo

echo "Backup directory is: $BACKUP_PATH"
echo

if [ -d "$BACKUP_PATH" ]; then
  echo "Restoring from backup directory: $BACKUP_PATH"
else
  echo "Backup directory not found."
  exit 1
fi

FILE_COUNT=$(find "$BACKUP_PATH" -type f | wc -l)
FILE_COUNTER=0

if [ "$FILE_COUNT" -eq 0 ]; then
  echo "No files found in backup directory."
  exit 1
fi

# .assets
if [ -d "$BACKUP_PATH/.assets" ]; then
  cp -r "$BACKUP_PATH/.assets"/* /mnt/us/system/ads/
    if [ -d "/mnt/us/system/.assets" ]; then
        echo "Restored .assets directory"
        FILE_COUNTER=$((FILE_COUNTER + 1))
    else
        echo "Failed to restore .assets directory"
    fi
fi
# adunits/
if [ -d "$BACKUP_PATH/adunits" ]; then
  cp -r "$BACKUP_PATH/adunits"/* /var/local/
  if [ -d "/var/local/adunits" ]; then
      echo "Restored adunits directory"
      FILE_COUNTER=$((FILE_COUNTER + 1))
  else
      echo "Failed to restore adunits directory"
  fi
fi
# merchant/
if [ -d "$BACKUP_PATH/merchant" ]; then
  cp -r "$BACKUP_PATH/merchant"/* /var/local/
  if [ -d "/var/local/merchant" ]; then
      echo "Restored merchant directory"
      FILE_COUNTER=$((FILE_COUNTER + 1))
  else
      echo "Failed to restore merchant directory"
  fi
fi
# appreg.db
if [ -f "$BACKUP_PATH/appreg.db" ]; then
  cp "$BACKUP_PATH/appreg.db" /mnt/us/system/ads/
  if [ -f "/mnt/us/system/appreg.db" ]; then
      echo "Restored appreg.db"
      FILE_COUNTER=$((FILE_COUNTER + 1))
  else
      echo "Failed to restore appreg.db"
  fi
fi

echo "Restored $FILE_COUNT out of $FILE_COUNTER."
if [ "$FILE_COUNT" -eq "$FILE_COUNTER" ]; then
  echo "All files restored successfully."
else
  echo "Some files failed to restore."
fi