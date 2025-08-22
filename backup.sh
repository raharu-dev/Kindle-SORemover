#!/bin/sh
set -e
clear

BACKUP_PATH="/mnt/us/SO-BACKUP"

echo "Kindle-SORemover"
echo "BACKUP"

echo
echo "Don't worry if some of the files don't exist."
echo "Backup directory is: $BACKUP_PATH"
echo

# Creating backup directory
if [ ! -d "$BACKUP_PATH" ]; then
  echo "Creating backup directory"
  mkdir "$BACKUP_PATH"
else
  echo "Backup directory already exists"
  if [ "$(ls -A $BACKUP_PATH)" ]; then
    echo "Backup directory is not empty"
    TIMESTAMP=$(date +"%Y-%m-%d-%H%M%S") # i.e. 2025-06-01-123456
    echo "Moving existing files to $BACKUP_PATH-old/$TIMESTAMP/"
    mkdir -p "$BACKUP_PATH-old/$TIMESTAMP/"
    if [ ! -d "$BACKUP_PATH-old/$TIMESTAMP" ]; then
      echo "Failed to create backup directory for old files"
    fi
    FILE_COUNT=$(find "$BACKUP_PATH" -mindepth 1 | wc -l)
    mv "$BACKUP_PATH"/* "$BACKUP_PATH-old/$TIMESTAMP/"
    if [ "$FILE_COUNT" -eq $(find "$BACKUP_PATH-old/$TIMESTAMP" -mindepth 1 | wc -l) ]; then
      echo "Existing files successfully moved to $BACKUP_PATH-old/$TIMESTAMP/"
    fi
  fi
fi

if [ ! -d "$BACKUP_PATH" ]; then
  echo "Failed to create backup directory"
  echo "Aborting operation."
  exit 1
fi

# BACKUP
FAIL_COUNT=0
# .assets
if [ -d "/mnt/us/system/.assets" ]; then
  cp -a "/mnt/us/system/.assets" "$BACKUP_PATH/.assets"
  BACKUPCOUNT=$(find "$BACKUP_PATH/.assets" -mindepth 1 | wc -l)
  FILE_COUNT=$(find "/mnt/us/system/.assets" -mindepth 1 | wc -l)
  if [ -d "$BACKUP_PATH/.assets" ] && [ "$BACKUPCOUNT" -eq "$FILE_COUNT" ]; then
    echo "Backed up .assets directory [$BACKUPCOUNT files]"
  else
    echo "Failed to back up .assets directory."
    FAIL_COUNT=$((FAIL_COUNT+FILE_COUNT))
  fi
else
  echo "No .assets directory found"
fi

# /var/local files
cd /var/local/ || { echo "Failed to change directory to /var/local/"; exit 1; }
# adunits/
if [ -d "adunits/" ]; then
  cp -a "adunits/" "$BACKUP_PATH/adunits/"
  BACKUPCOUNT=$(find "$BACKUP_PATH/adunits/" -mindepth 1 | wc -l)
  FILE_COUNT=$(find "adunits/" -mindepth 1 | wc -l)
  if [ -d "$BACKUP_PATH/adunits/" ] && [ "$BACKUPCOUNT" -eq "$FILE_COUNT" ]; then
    echo "Backed up adunits directory [$BACKUPCOUNT files]"
  else
    echo "Failed to back up adunits directory."
    FAIL_COUNT=$((FAIL_COUNT+FILE_COUNT))
  fi
else
  echo "No adunits directory found"
fi
# merchant/
if [ -d "merchant/" ]; then
  cp -a "merchant/" "$BACKUP_PATH/merchant/"
  BACKUPCOUNT=$(find "$BACKUP_PATH/merchant/" -mindepth 1 | wc -l)
  FILE_COUNT=$(find "merchant/" -mindepth 1 | wc -l)
  if [ -d "$BACKUP_PATH/merchant/" ] && [ "$BACKUPCOUNT" -eq "$FILE_COUNT" ]; then
    echo "Backed up merchant directory [$BACKUPCOUNT files]"
  else
    echo "Failed to back up merchant directory."
    FAIL_COUNT=$((FAIL_COUNT+FILE_COUNT))
  fi
else
  echo "No merchant directory found"
fi
# appreg.db
if [ -f "appreg.db" ]; then
  cp appreg.db $BACKUP_PATH/appreg.db
  if [ -f "$BACKUP_PATH/appreg.db" ]; then
    echo "Backed up appreg.db file"
  else
    echo "Failed to back up appreg.db file"
    FAIL_COUNT=$((FAIL_COUNT+1))
  fi
else
  echo "No appreg.db file found"
fi
# END Message
echo
echo "Backup process completed."
if [ "$FAIL_COUNT" -eq 0 ]; then
  echo "All files backed up successfully."
else
  echo "$FAIL_COUNT files failed to back up."
fi