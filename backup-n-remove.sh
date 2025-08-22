#!/bin/sh
clear

BACKUP_PATH="/mnt/us/BACKUP"

echo "-BACKUP & REMOVE-"
echo Backup directory is: $BACKUP_PATH

if [ ! -d "$BACKUP_PATH" ]; then
  mkdir "$BACKUP_PATH"
else
  echo "Backup directory already exists"
  echo
fi

if [ ! -d "$BACKUP_PATH" ]; then
  echo "Failed to create backup directory"
  exit 1
fi

# BACKUP and REMOVAL
# .assets
if [ -d "/mnt/us/system/.assets" ]; then
    cp -r /mnt/us/system/.assets $BACKUP_PATH/.assets
    if [ -d "$BACKUP_PATH/.assets" ]; then
        echo "Backed up .assets directory"
        rm -rf /mnt/us/system/.assets
        if [ ! -d "/mnt/us/system/.assets" ]; then
            echo "Successfully removed .assets directory"
        else
            echo "Failed to remove .assets directory"
        fi
    else
        echo "Failed to back up .assets directory"
    fi
else
  echo "No .assets directory found"
fi
# /var/local files
cd /var/local/

if [ -d "adunits/" ]; then
    cp -r adunits/ $BACKUP_PATH/adunits/
    if [ -d "$BACKUP_PATH/adunits/" ]; then
        echo "Backed up adunits directory"
        rm -rf adunits/
        if [ ! -d "adunits/" ]; then
            echo "Successfully removed adunits directory"
        else
            echo "Failed to remove adunits directory"
        fi
    else
        echo "Failed to back up adunits directory"
    fi
else
  echo "No adunits directory found"
fi

if [ -d "merchant/" ]; then
    cp -r merchant/ $BACKUP_PATH/merchant/
    if [ -d "$BACKUP_PATH/merchant/" ]; then
        echo "Backed up merchant directory"
        rm -rf merchant/
        if [ ! -d "merchant/" ]; then
            echo "Successfully removed merchant directory"
        else
            echo "Failed to remove merchant directory"
        fi
    else
        echo "Failed to back up merchant directory"
    fi
  echo "No merchant directory found"
fi
if [ -f "appreg.db" ]; then
    cp appreg.db $BACKUP_PATH/appreg.db
    if [ -f "$BACKUP_PATH/appreg.db" ]; then
        echo "Backed up appreg.db file"
            sqlite3 /var/local/appreg.db "delete from properties where handlerid='dcc' and name='adunit.viewable'"
            sqlite3 /var/local/appreg.db "delete from properties where handlerid='dcc' and name='dtcp_pref_ShowScreensaverPref'"
            sqlite3 /var/local/appreg.db "delete from properties where handlerid='dcc' and name='dtcp_pref_ShowBannerPref'"
            # IF MD5sums are different, then it was succesful
            if [ "$(md5sum appreg.db | awk '{print $1}')" != "$(md5sum $BACKUP_PATH/appreg.db | awk '{print $1}')" ]; then
                echo "appreg.db has been modified."
            else
                echo "appreg.db appears unchanged. Removal may have failed."
            fi
    else
        echo "Failed to back up appreg.db file"
    fi
else
  echo "No appreg.db file found"
fi