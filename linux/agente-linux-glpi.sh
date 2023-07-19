#!/bin/bash
#Permite ip 192.168.55.111 o dominio support.lola.mem
SERVER_GLPI='support.lola.mem'
# Descargar e instalar el paquete del agente de GLPI
wget https://github.com/glpi-project/glpi-agent/releases/download/1.5/glpi-agent_1.5-1_all.deb
sudo dpkg -i glpi-agent_1.5-1_all.deb
sudo apt-get install -f -y
# Modificar la configuración del agente
sudo sed -i 's/no-ssl-check = 0/no-ssl-check = 1/' /etc/glpi-agent/agent.cfg
# Crear y editar el archivo 00-install.cfg
sudo tee /etc/glpi-agent/conf.d/00-install.cfg > /dev/null <<EOT
server = https://$SERVER_GLPI/glpi/front/inventory.php
EOT
# Reiniciar el servicio del agente de GLPI
sudo systemctl restart glpi-agent.service
# Iniciar el agente de GLPI
sudo glpi-agent

