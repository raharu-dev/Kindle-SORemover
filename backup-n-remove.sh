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

        echo "Do you want to continue and possibly overwrite existing files? [y/n]"

        read -r answer
        while [ "$answer" != "y" ] && [ "$answer" != "Y" ]; do
            echo "Please enter 'y' to continue or 'n' to abort:"
            read -r answer
            if [ "$answer" = "n" ] || [ "$answer" = "N" ]; then
                echo "Aborted by user."
                exit 1
            fi
        done
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
    if [ -d "$BACKUP_PATH/.assets" ] && [ "$(ls -A "$BACKUP_PATH/.assets")" ]; then
        echo "Backed up .assets directory"
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
    if [ -d "$BACKUP_PATH/adunits/" ] && [ "$(ls -A "$BACKUP_PATH/adunits/")" ]; then
        echo "Backed up adunits directory"
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
    if [ -d "$BACKUP_PATH/merchant/" ] && [ "$(ls -A "$BACKUP_PATH/merchant/")" ]; then
        echo "Backed up merchant directory"
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