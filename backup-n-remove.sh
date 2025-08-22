#!/bin/sh
set -e
clear

BACKUP_PATH="/mnt/us/SO-BACKUP"

echo "Kindle-SORemover"
echo "BACKUP & REMOVE"
echo "Don't worry if some of the files don't exist."
echo

echo "Backup directory is: $BACKUP_PATH"
echo

# Creating backup directory and basic checks to not overwrite it.
if [ ! -d "$BACKUP_PATH" ]; then
  mkdir "$BACKUP_PATH"
else
    echo "Backup directory already exists"
    if [ "$(ls -A $BACKUP_PATH)" ]; then
        echo "Backup directory is not empty"

        # If the backup path is not empty, copy its content to $BACKUP_PATH-old/<filename>-<date>
        if [ ! -d "$BACKUP_PATH-old" ]; then
            mkdir "$BACKUP_PATH-old"
        fi
        TIMESTAMP=$(date +"%Y-%m-%d-%H%M%S") # i.e. 2025-06-01-123456
        cp -a "$BACKUP_PATH" "$BACKUP_PATH-old/$TIMESTAMP/"
        echo "Existing files moved to $BACKUP_PATH-old/$TIMESTAMP/"
    fi
fi

if [ ! -d "$BACKUP_PATH" ]; then
    echo "Failed to create backup directory"
    exit 1
fi

# BACKUP & REMOVAL

# .assets
if [ -d "/mnt/us/system/.assets" ]; then
    cp -a "/mnt/us/system/.assets" "$BACKUP_PATH/.assets"
    BACKUPCOUNT=$(find "$BACKUP_PATH/.assets" -mindepth 1 | wc -l)
    FILE_COUNT=$(find "/mnt/us/system/.assets" -mindepth 1 | wc -l)
    if [ -d "$BACKUP_PATH/.assets" ] && [ "$BACKUPCOUNT" -eq "$FILE_COUNT" ]; then
        echo "Backed up .assets directory [$BACKUPCOUNT files]"
        rm -rf "/mnt/us/system/.assets"
        if [ ! -d "/mnt/us/system/.assets" ]; then
            echo "Successfully removed .assets directory"
        else
            echo "Failed to remove .assets directory"
        fi
    else
        echo "Failed to back up .assets directory; not removing original."
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
        rm -rf "adunits/"
        if [ ! -d "adunits/" ]; then
            echo "Successfully removed adunits directory"
        else
            echo "Failed to remove adunits directory"
        fi
    else
        echo "Failed to back up adunits directory; not removing original."
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
        rm -rf "merchant/"
        if [ ! -d "merchant/" ]; then
            echo "Successfully removed merchant directory"
        else
            echo "Failed to remove merchant directory"
        fi
    else
        echo "Failed to back up merchant directory; not removing original."
    fi
else
  echo "No merchant directory found"
fi

# appreg.db
if [ -f "appreg.db" ]; then
    cp appreg.db $BACKUP_PATH/appreg.db
    if [ -f "$BACKUP_PATH/appreg.db" ]; then
        echo "Backed up appreg.db file"
            sqlite3 appreg.db "delete from properties where handlerid='dcc' and name='adunit.viewable'"
            sqlite3 appreg.db "delete from properties where handlerid='dcc' and name='dtcp_pref_ShowScreensaverPref'"
            sqlite3 appreg.db "delete from properties where handlerid='dcc' and name='dtcp_pref_ShowBannerPref'"
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