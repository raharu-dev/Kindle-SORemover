#!/bin/sh

# BACKUP and REMOVAL
if [ -d "/mnt/us/system/.assets" ]; then
    #rm -rf /mnt/us/system/.assets
else
  echo "No .assets directory found"
fi
if [ -d "/var/local/adunits/" ]; then
    #rm -rf /var/local/adunits/
else
  echo "No adunits directory found"
fi
if [ -d "/var/local/merchant/" ]; then
    #rm -rf /var/local/merchant/
else
  echo "No merchant directory found"
fi
if [ -f "/var/local/appreg.db" ]; then
else
  echo "No appreg.db file found"
fi