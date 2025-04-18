#!/bin/sh
NOW=Backup
RPATH=/mnt/backup/SRV-xxx/$1
RPATH2=/mnt/backup-rep/SRV-xxx/$1
LOG=/var/log/bkpsql$1"-"$NOW".log"

echo "------------------"Backup SQL GLPI on "--------------------------"
echo `date`>>$LOG

mysqldump -h localhost -u root -p**** coc-mtr > /root/coc-mtr-$NOW.sql
cp /root/coc-mda-$NOW.sql $RPATH
cp /root/coc-mda-$NOW.sql $RPATH2
mysqldump -h localhost -u root -p**** coc-py > /root/coc-py-$NOW.sql
cp /root/coc-py-$NOW.sql $RPATH
cp /root/coc-py-$NOW.sql $RPATH2
mysqldump -h localhost -u root -p**** mysql > /root/mysql-$NOW.sql
cp /root/mysql-$NOW.sql $RPATH
cp /root/mysql-$NOW.sql $RPATH2
#mysqldump -h localhost -u root -p**** performance_schema > /root/performance_schema-$NOW.sql
#cp /root/performance_schema-$NOW.sql $RPATH
#cp /root/performance_schema-$NOW.sql $RPATH2
