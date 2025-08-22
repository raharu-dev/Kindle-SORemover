#!/bin/sh
set -e
clear

BACKUP_PATH="/mnt/us/SO-BACKUP"

echo "Kindle-SORemover"
echo "BACKUP & REMOVE"

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
    echo "Aborting operation."
    exit 1
fi

if [ ! -d "$BACKUP_PATH" ]; then
    echo "Failed to create backup directory"
    echo "Aborting operation."
    exit 1
fi

# BACKUP & REMOVAL
CHANGE_COUNT=0
FAIL_BACKUP_COUNT=0
# .assets
echo "Backing up .assets directory"
if [ -d "/mnt/us/system/.assets" ]; then
    cp -a "/mnt/us/system/.assets" "$BACKUP_PATH/.assets"
    BACKUP_COUNT=$(find "$BACKUP_PATH/.assets" -mindepth 1 | wc -l)
    FILE_COUNT=$(find "/mnt/us/system/.assets" -mindepth 1 | wc -l)
    if [ -d "$BACKUP_PATH/.assets" ] && [ "$BACKUP_COUNT" -eq "$FILE_COUNT" ]; then
        echo "Backed up .assets directory [$BACKUP_COUNT/$FILE_COUNT files]"
        echo "Removing .assets directory"
        rm -rf "/mnt/us/system/.assets"
        if [ ! -d "/mnt/us/system/.assets" ]; then
            echo "Successfully removed .assets directory"
            CHANGE_COUNT=$((CHANGE_COUNT+1))
        else
            echo "Failed to remove .assets directory"
        fi
    else
        FAIL_BACKUP_COUNT=$((FAIL_BACKUP_COUNT+FILE_COUNT))
        echo "Failed to back up .assets directory. [$BACKUP_COUNT/$FILE_COUNT files]"
        echo "Aborting deletion of this directory."
    fi
else
  echo "No .assets directory found"
fi
# /var/local files
cd /var/local/ || { echo "Failed to change directory to /var/local/"; exit 1; }
# adunits/
echo "Backing up adunits directory"
if [ -d "adunits/" ]; then
    cp -a "adunits/" "$BACKUP_PATH/adunits/"
    BACKUP_COUNT=$(find "$BACKUP_PATH/adunits/" -mindepth 1 | wc -l)
    FILE_COUNT=$(find "adunits/" -mindepth 1 | wc -l)
    if [ -d "$BACKUP_PATH/adunits/" ] && [ "$BACKUP_COUNT" -eq "$FILE_COUNT" ]; then
        echo "Backed up adunits directory [$BACKUP_COUNT/$FILE_COUNT files]"
        echo "Removing adunits directory"
        rm -rf "adunits/"
        if [ ! -d "adunits/" ]; then
            echo "Successfully removed adunits directory"
            CHANGE_COUNT=$((CHANGE_COUNT+1))
        else
            echo "Failed to remove adunits directory"
        fi
    else
        FAIL_BACKUP_COUNT=$((FAIL_BACKUP_COUNT+FILE_COUNT))
        echo "Failed to back up adunits directory. [$BACKUP_COUNT/$FILE_COUNT files]"
        echo "Aborting deletion of this directory."
    fi
else
  echo "No adunits directory found"
fi
# merchant/
echo "Backing up merchant directory"
if [ -d "merchant/" ]; then
    cp -a "merchant/" "$BACKUP_PATH/merchant/"
    BACKUP_COUNT=$(find "$BACKUP_PATH/merchant/" -mindepth 1 | wc -l)
    FILE_COUNT=$(find "merchant/" -mindepth 1 | wc -l)
    if [ -d "$BACKUP_PATH/merchant/" ] && [ "$BACKUP_COUNT" -eq "$FILE_COUNT" ]; then
        echo "Backed up merchant directory [$BACKUP_COUNT/$FILE_COUNT files]"
        echo "Removing merchant directory"
        rm -rf "merchant/"
        if [ ! -d "merchant/" ]; then
            echo "Successfully removed merchant directory"
            CHANGE_COUNT=$((CHANGE_COUNT+1))
        else
            echo "Failed to remove merchant directory"
        fi
    else
        FAIL_BACKUP_COUNT=$((FAIL_BACKUP_COUNT+FILE_COUNT))
        echo "Failed to back up merchant directory. [$BACKUP_COUNT/$FILE_COUNT files]"
        echo "Aborting deletion of this directory."
    fi
else
    echo "No merchant directory found"
fi
# appreg.db
echo "Backing up appreg.db file"
APPREG=0
if [ -f "appreg.db" ]; then
    cp appreg.db $BACKUP_PATH/appreg.db
    if [ -f "$BACKUP_PATH/appreg.db" ]; then
        echo "Backed up appreg.db file"
        echo "Modifying appreg.db file"
        sqlite3 appreg.db "delete from properties where handlerid='dcc' and name='adunit.viewable'"
        sqlite3 appreg.db "delete from properties where handlerid='dcc' and name='dtcp_pref_ShowScreensaverPref'"
        sqlite3 appreg.db "delete from properties where handlerid='dcc' and name='dtcp_pref_ShowBannerPref'"
        # IF MD5sums are different, then it was succesful
        if [ "$(md5sum appreg.db | awk '{print $1}')" != "$(md5sum $BACKUP_PATH/appreg.db | awk '{print $1}')" ]; then
            echo "appreg.db has been modified."
            CHANGE_COUNT=$((CHANGE_COUNT+1))
            APPREG=1
        else
            echo "appreg.db appears unchanged."
        fi
    else
        FAIL_BACKUP_COUNT=$((FAIL_BACKUP_COUNT+1))
        echo "Failed to back up appreg.db file"
        echo "Aborting modification of appreg.db"
    fi
else
    echo "No appreg.db file found"
fi

# End message
echo
echo "Backup and removal process completed."
if [ "$FAIL_BACKUP_COUNT" -gt 0 ]; then
    echo FAILED TO BACKUP: $FAIL_BACKUP_COUNT files
fi
echo CHANGES: $CHANGE_COUNT
if [ "$CHANGE_COUNT" -eq 0 ]; then
    echo "No changes were made."
else
    if [ "$APPREG" -eq 1 ]; then
        echo "Removal was most likely successful."
    else
        echo "Database is unchanged removal was most likely unsuccessful."
    fi
fi