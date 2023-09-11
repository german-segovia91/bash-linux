#!/bin/bash
#Servidor NTP Primario
    NTPERVICE1="ntp-teco1.mitrol-intra.net";
#Servidor NTP Secundario
    NTPERVICE2="ntp-teco2.mitrol-intra.net";

echo -e "Estos son los Servidores a implementar"
echo -e "Servidor Primario = $NTPERVICE1"
echo -e "Servidor Secubdario = $NTPERVICE2"
echo -e ""
ls /etc/ntp.bkp
if [ $? -eq 0 ]; then

    echo -e "############"
    echo -e "##########"
    echo -e "########"
    echo -e "Este script ya se ejecutó, por favor revisar las configuraciones de /etc/ntp.conf y /etc/systemd/timesyncd.conf."
    echo -e "Revice con "
    echo -e "Para más información https://mitrol.atlassian.net/wiki/spaces/INFRA/pages/24722638331/Sincronizaci+n+de+NTP+con+Ubuntu+Server"

else
     ### instalacion de servicios necesarios
    echo -e "instalando componentes"
    apt install ntp ntpdate -y
    apt install systemd-timesyncd -y
    ### Congiguracion
    echo -e "configurando"
    timedatectl set-timezone America/Argentina/Buenos_Aires
    mv /etc/ntp.conf /etc/ntp.bkp
    sed -e 's/pool/'#pool'/g' /etc/ntp.bkp > /etc/ntp.conf
    echo -e server ntp-teco1.mitrol-intra.net prefer >> /etc/ntp.conf
    echo -e server ntp-teco2.mitrol-intra.net prefer >> /etc/ntp.conf
    echo -e NTP=server $NTPERVICE1 >> /etc/systemd/timesyncd.conf
    echo -e FallbackNTP=server $NTPERVICE2 >> /etc/systemd/timesyncd.conf
    ntpdate -u $NTPERVICE1
    echo -e ""
    echo -e ""
    echo -e "Status"
    timedatectl set-ntp true
    timedatectl status
fi
