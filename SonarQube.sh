#############################################
#                                           #
#       Sonarqube 
#                                           #
#############################################

#!/bin/bash
SONAR_CONTAINER="sonarqube"
SONAR_PORT="9000"
SONAR_DB_NAME="sonarqube_db"
SONAR_DB_USER="sonarqube_user"
SONAR_DB_PASSWORD="sonarqubemipassword"
SONAR_DB_URL="jdbc:postgresql://$SONAR_CONTAINER.postgres/$SONAR_DB_NAME"

# Configuracion de firewalld
#firewall-cmd --permanent --add-port=$SONAR_PORT/tcp
#firewall-cmd --reload
ufw allow $SONAR_PORT/tcp

# Preparacion de directorios
mkdir -p /var/containers/$SONAR_CONTAINER/{opt/sonarqube/data,opt/sonarqube/extensions,opt/sonarqube/logs,var/lib/postgresql/data}
chown 999:0 -R /var/containers/$SONAR_CONTAINER/opt

# Configuracion de memoria Elasticsearch
sysctl -w vm.max_map_count=262144
sysctl -w fs.file-max=65536
ulimit -n 65536
ulimit -u 4096

# Despliegue de base de datos
docker run -itd --name $SONAR_CONTAINER.postgres \
    --restart always \
    -e POSTGRES_PASSWORD=$SONAR_DB_PASSWORD \
    -e POSTGRES_USER=$SONAR_DB_USER \
    -e POSTGRES_DB=$SONAR_DB_NAME \
    -e "TZ=America/Mexico_City" \
    -v /etc/localtime:/etc/localtime:ro \
    -v /var/containers/$SONAR_CONTAINER/var/lib/postgresql/data:/var/lib/postgresql/data:z \
    postgres:alpine

# Despliegue Sonarqube
docker run -itd --name $SONAR_CONTAINER \
    --restart always \
    -p $SONAR_PORT:$SONAR_PORT \
    -e SONAR_WEB_PORT=$SONAR_PORT \
    -e SONAR_JDBC_URL=$SONAR_DB_URL \
    -e SONAR_JDBC_USERNAME=$SONAR_DB_USER \
    -e SONAR_JDBC_PASSWORD=$SONAR_DB_PASSWORD \
    -e "TZ=America/Mexico_City" \
    -v /etc/localtime:/etc/localtime:ro \
    -v /var/containers/$SONAR_CONTAINER/opt/sonarqube/data:/opt/sonarqube/data:z \
    -v /var/containers/$SONAR_CONTAINER/opt/sonarqube/extensions:/opt/sonarqube/extensions:z \
    -v /var/containers/$SONAR_CONTAINER/opt/sonarqube/logs:/opt/sonarqube/logs:z \
    -v /var/containers/$SONAR_CONTAINER/var/sonarqube-scanners:/var/sonarqube-scanners:z \
    --link $SONAR_CONTAINER.postgres:$SONAR_CONTAINER.postgres \
    sonarqube:8.3.1-community