#!/bin/sh
set -e
clear

echo "Kindle-SORemover"
echo "REMOVE"

echo
echo "Don't worry if some of the files don't exist."
echo


# REMOVAL
CHANGE_COUNT=0
# .assets
echo "Backing up .assets directory"
if [ -d "/mnt/us/system/.assets" ]; then
  rm -rf "/mnt/us/system/.assets"
  if [ ! -d "/mnt/us/system/.assets" ]; then
    echo "Successfully removed .assets directory"
    CHANGE_COUNT=$((CHANGE_COUNT+1))
  else
    echo "Failed to remove .assets directory"
  fi
else
  echo "No .assets directory found"
fi
# /var/local files
cd /var/local/ || { echo "Failed to change directory to /var/local/"; exit 1; }
# adunits/
echo "Removing adunits directory"
if [ -d "adunits/" ]; then
  rm -rf "adunits/"
  if [ ! -d "adunits/" ]; then
    echo "Successfully removed adunits directory"
    CHANGE_COUNT=$((CHANGE_COUNT+1))
  else
    echo "Failed to remove adunits directory"
  fi
else
  echo "No adunits directory found"
fi
# merchant/
echo "Removing merchant directory"
if [ -d "merchant/" ]; then
  rm -rf "merchant/"
  if [ ! -d "merchant/" ]; then
    echo "Successfully removed merchant directory"
    CHANGE_COUNT=$((CHANGE_COUNT+1))
  else
    echo "Failed to remove merchant directory"
  fi
fi
# appreg.db
echo "Backing up appreg.db file"
APPREG=0
if [ -f "appreg.db" ]; then
  APPREGMD5=$(md5sum appreg.db | awk '{print $1}')
  sqlite3 appreg.db "delete from properties where handlerid='dcc' and name='adunit.viewable'"
  sqlite3 appreg.db "delete from properties where handlerid='dcc' and name='dtcp_pref_ShowScreensaverPref'"
  sqlite3 appreg.db "delete from properties where handlerid='dcc' and name='dtcp_pref_ShowBannerPref'"
  # IF MD5sums are different, then it was succesful
  if [ "$(md5sum appreg.db | awk '{print $1}')" != "$APPREGMD5" ]; then
    echo "appreg.db has been modified."
    CHANGE_COUNT=$((CHANGE_COUNT+1))
    APPREG=1
  else
    echo "appreg.db appears unchanged."
  fi
else
  echo "No appreg.db file found"
fi

# End message
echo
echo "Removal process completed."
echo "CHANGES: $CHANGE_COUNT"
if [ "$CHANGE_COUNT" -eq 0 ]; then
  echo "No changes were made."
else
  if [ "$APPREG" -eq 1 ]; then
    echo "Removal was most likely successful."
  else
    echo "Database is unchanged removal was most likely unsuccessful."
  fi
fi