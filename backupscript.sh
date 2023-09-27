#!/bin/bash
#Purpose = Backup of Structure Guard Data
#START

# current time
TIME=`date +"%b-%d-%y"`
# new file name
FILENAME="backup-$TIME.tar.gz"
# src to backup
SRCDIR="/home/sgadmin/structure_guard/public/shared"
# location to backup to
DESDIR="/media/usbbackup"

# tar it
tar -cpzf $DESDIR/$FILENAME $SRCDIR

# remove backups older than 365 days
find $DESDIR/*tar* -mtime +365 -exec rm {} \;

#END