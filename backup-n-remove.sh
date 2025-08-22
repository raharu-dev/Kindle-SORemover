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
    #rm -rf /mnt/us/system/.assets
else
  echo "No .assets directory found"
fi
if [ -d "/var/local/adunits/" ]; then
    #cp -r /var/local/adunits/ $BACKUP_PATH/adunits/
    #rm -rf /var/local/adunits/
else
  echo "No adunits directory found"
fi
if [ -d "/var/local/merchant/" ]; then
    #cp -r /var/local/merchant/ $BACKUP_PATH/merchant/
    #rm -rf /var/local/merchant/
else
  echo "No merchant directory found"
fi
if [ -f "/var/local/appreg.db" ]; then
    #cp /var/local/appreg.db $BACKUP_PATH/appreg.db
    #sqlite3 appreg.db "delete from properties where handlerid='dcc' and name='adunit.viewable'"
    #sqlite3 appreg.db "delete from properties where handlerid='dcc' and name='dtcp_pref_ShowScreensaverPref'"
    #sqlite3 appreg.db "delete from properties where handlerid='dcc' and name='dtcp_pref_ShowBannerPref'"
else
  echo "No appreg.db file found"
fi