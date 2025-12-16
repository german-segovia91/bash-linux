#!/bin/bash

if [ -z "$1" ]; then
  echo "Uso: $0 <nombre_subdirectorio>"
  exit 1
fi

DIA=$(date +%d-%m-%y)
BKPATH="/mnt/backup/SRV-DB06/$1"
LOG="/var/log/mysqldump/mysqldump_${1}_${DIA}.log"

echo ${LOG}

# Lista de bases a respaldar
BASES=("app_srv_ak01" "app_srv_ak02" " pbx01_asteriskcdrdb" "pbx04_asteriskcdrdb" "pbx05_asteriskcdrdb" "app_glpi")

mkdir -p /var/log/mysqldump
mkdir -p "$BKPATH"

echo "------------------ Inicio Backup MySQL SRV-DB06 --------------------------" | tee -a "$LOG"
date | tee -a "$LOG"

for BASE in "${BASES[@]}"; do
  BKFILE="/root/bkp/${BASE}-${DIA}.sql"
  echo "---- Backup de base: $BASE ----" | tee -a "$LOG"

  mysqldump -h localhost -u root "$BASE" > "$BKFILE" 2>> "$LOG"

#  if [ $? -eq 0 ]; then
#    echo " Backup $BASE exitoso, copiando a $BKPATH" | tee -a "$LOG"
#    cp "$BKFILE" "$BKPATH"
#  else
#    echo " Error al hacer dump de $BASE" | tee -a "$LOG"
#  fi
done