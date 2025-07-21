#!/bin/bash
echo "🛠 Day 3: Tomcat Install"

sudo apt update && sudo apt upgrade -y

# 1. Create 'tomcat' user
sudo useradd -m -U -d /opt/tomcat -s /bin/false tomcat || true

# 2. Get latest Tomcat 10.1 version number
TOMCAT_VERSION="10.1.43"

# 3. Download
cd /tmp
wget https://downloads.apache.org/tomcat/tomcat-10/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz \
  || { echo "Download failed"; exit 1; }

# 4. Install
sudo mkdir -p /opt/tomcat
sudo tar -xzvf apache-tomcat-$TOMCAT_VERSION.tar.gz -C /opt/tomcat --strip-components=1

# 5. Permissions
sudo chown -R tomcat: /opt/tomcat
sudo chmod +x /opt/tomcat/bin/*.sh

# 6. Test startup
sudo -u tomcat /opt/tomcat/bin/startup.sh
sleep 5
if curl -s http://localhost:8080 | grep -q "Apache Tomcat"; then
  echo "Tomcat started successfully!"
else
  echo "Tomcat failed to start. Check logs."
fi
