#!/bin/sh
BACKUP_PATH="/mnt/us/BACKUP"

echo -BACKUP & REMOVE-
echo Backup directory is: $BACKUP_PATH

if [ ! -d "$BACKUP_PATH" ]; then
  mkdir "$BACKUP_PATH"
else
  echo "Backup directory already exists"
fi

if [ ! -d "$BACKUP_PATH" ]; then
  echo "Failed to create backup directory"
  exit 1
fi

# BACKUP and REMOVAL
# .assets
if [ -d "/mnt/us/system/.assets" ]; then
    cp -r /mnt/us/system/.assets $BACKUP_PATH/.assets
    rm -rf /mnt/us/system/.assets
else
  echo "No .assets directory found"
fi
# /var/local files
cd /var/local/
if [ -d "adunits/" ]; then
    cp -r adunits/ $BACKUP_PATH/adunits/
    rm -rf adunits/
else
  echo "No adunits directory found"
fi
if [ -d "merchant/" ]; then
    cp -r merchant/ $BACKUP_PATH/merchant/
    rm -rf merchant/
else
  echo "No merchant directory found"
fi
if [ -f "appreg.db" ]; then
    cp appreg.db $BACKUP_PATH/appreg.db
    sqlite3 /var/local/appreg.db "delete from properties where handlerid='dcc' and name='adunit.viewable'"
    sqlite3 /var/local/appreg.db "delete from properties where handlerid='dcc' and name='dtcp_pref_ShowScreensaverPref'"
    sqlite3 /var/local/appreg.db "delete from properties where handlerid='dcc' and name='dtcp_pref_ShowBannerPref'"
else
  echo "No appreg.db file found"
fi