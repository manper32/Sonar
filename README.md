# Instalar-SonarQube-en-Docker-Container

Ejecutar en bash como usuario root

# Inspeccion de proyectos

https://techexpert.tips/es/sonarqube-es/sonarqube-instalacion-del-escaner-en-ubuntu-linux/

Se tiene que realizar la instalacion del sonar-scanner, asi que se tienen que seguir los siguientes pasos o revisar el la URL proporcionada arriba

mkdir /downloads/sonarqube -p
cd /downloads/sonarqube
wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.2.0.1873-linux.zip
unzip sonar-scanner-cli-4.2.0.1873-linux.zip
mv sonar-scanner-4.2.0.1873-linux /opt/sonar-scanner

sudo nano /opt/sonar-scanner/conf/sonar-scanner.properties

sudo nano /etc/profile.d/sonar-scanner.sh
---contenido
#/bin/bash

export PATH="$PATH:/opt/sonar-scanner/bin"
---

source /etc/profile.d/sonar-scanner.sh

env | grep path

cd zabbix-4.4.0
sonar-scanner -X -Dsonar.projectKey=<nombre proyecto> -Dsonar.sources=. -Dsonar.host.url=http://10.150.1.37:9000 -Dsonar.login=<token>