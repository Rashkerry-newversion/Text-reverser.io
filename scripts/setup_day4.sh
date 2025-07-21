#!/bin/bash
echo "Day 4: Installing SonarQube 10.4.0"

# Config
SONARQUBE_VERSION="10.4.0.87286"
SONAR_USER="sonar"
INSTALL_DIR="/opt/sonarqube"

# Java 17
sudo apt update
sudo apt install -y openjdk-17-jdk unzip wget

# User
sudo useradd -r -s /bin/bash -d $INSTALL_DIR $SONAR_USER || echo "User exists"

# Download
cd /tmp
wget -O sonarqube.zip https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${SONARQUBE_VERSION}.zip
sudo unzip -q sonarqube.zip -d /opt
sudo mv /opt/sonarqube-${SONARQUBE_VERSION} $INSTALL_DIR

# Permissions
sudo chown -R $SONAR_USER:$SONAR_USER $INSTALL_DIR

# System tuning
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
echo "fs.file-max=65536" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

echo "$SONAR_USER - nofile 65536" | sudo tee -a /etc/security/limits.conf
echo "$SONAR_USER - nproc 4096"  | sudo tee -a /etc/security/limits.conf

# systemd service
sudo bash -c "cat > /etc/systemd/system/sonarqube.service <<EOF
[Unit]
Description=SonarQube Service
After=network.target

[Service]
Type=forking
ExecStart=${INSTALL_DIR}/bin/linux-x86-64/sonar.sh start
ExecStop=${INSTALL_DIR}/bin/linux-x86-64/sonar.sh stop
User=$SONAR_USER
Group=$SONAR_USER
Restart=on-failure
LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
EOF"

# Enable + Start
sudo systemctl daemon-reload
sudo systemctl enable sonarqube
sudo systemctl start sonarqube

echo "🌐 Access: http://localhost:9000"
echo "🔑 Default: admin / admin"
