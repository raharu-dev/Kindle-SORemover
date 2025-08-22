#!/bin/sh
BACKUP_PATH="/mnt/us/BACKUP"

echo $BACKUP_PATH
mkdir $BACKUP_PATH

if [ ! -d "$BACKUP_PATH" ]; then
  echo "Failed to create backup directory"
  exit 1
fi

# BACKUP and REMOVAL
if [ -d "/mnt/us/system/.assets" ]; then
    #cp -r /mnt/us/system/.assets $BACKUP_PATH/.assets
else
  echo "No .assets directory found"
fi
if [ -d "/var/local/adunits/" ]; then
    #cp -r /var/local/adunits/ $BACKUP_PATH/adunits/
else
  echo "No adunits directory found"
fi
if [ -d "/var/local/merchant/" ]; then
    #cp -r /var/local/merchant/ $BACKUP_PATH/merchant/
else
  echo "No merchant directory found"
fi
if [ -f "/var/local/appreg.db" ]; then
    #cp /var/local/appreg.db $BACKUP_PATH/appreg.db
else
  echo "No appreg.db file found"
fi