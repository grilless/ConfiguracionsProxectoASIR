#!/bin/bash
LOG_FILE="/var/log/actualizacion_sistema.log"
apt-get update -y >> $LOG_FILE 2>&1
apt-get upgrade -y >> $LOG_FILE 2>&1
apt-get autoremove -y >> $LOG_FILE 2>&1
apt-get autoclean -y >> $LOG_FILE 2>&1
echo "=== FIN DA ACTUALIZACIÓN: $(date) ===" >> $LOG_FILE
