#!/bin/bash
#Servidor NTP Primario
    NTPERVICE1="ntp-teco1.mitrol-intra.net";
#Servidor NTP Secundario
    NTPERVICE2="ntp-teco2.mitrol-intra.net";

echo  "Estos son los Servidores a implementar"
echo  "Servidor Primario = $NTPERVICE1"
echo  "Servidor Secubdario = $NTPERVICE2"
echo  ""
ls /etc/ntp.bkp
if [ $? -eq 0 ]; then

    echo  "############"
    echo  "##########"
    echo  "########"
    echo  "Este script ya se ejecutó, por favor revisar las configuraciones de /etc/ntp.conf y /etc/systemd/timesyncd.conf."
    echo  "Revice con "
    echo  "Para más información https://mitrol.atlassian.net/wiki/spaces/INFRA/pages/24722638331/Sincronizaci+n+de+NTP+con+Ubuntu+Server"

else
     ### instalacion de servicios necesarios
    echo "instalando componentes"
    apt install ntp ntpdate -y
    apt install systemd-timesyncd -y
    ### Congiguracion
    echo "configurando"
    timedatectl set-timezone America/Argentina/Buenos_Aires
    mv /etc/ntp.conf /etc/ntp.bkp
    sed -e 's/pool/'#pool'/g' /etc/ntp.bkp > /etc/ntp.conf
    echo server $NTPERVICE1 prefer >> /etc/ntp.conf
    echo server $NTPERVICE2 prefer >> /etc/ntp.conf
    echo NTP=server $NTPERVICE1 >> /etc/systemd/timesyncd.conf
    echo FallbackNTP=server $NTPERVICE2 >> /etc/systemd/timesyncd.conf
    ntpdate -u $NTPERVICE1
    echo  ""
    echo  ""
    echo  "Status"
    timedatectl set-ntp true
    timedatectl status
fi
