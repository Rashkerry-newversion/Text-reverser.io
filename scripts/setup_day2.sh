#!/bin/bash

# Day 2: Install Java & Jenkins on Ubuntu

echo "🔧 Updating system packages..."
sudo apt update -y && sudo apt upgrade -y

echo "☕ Installing Java (OpenJDK 17)..."
sudo apt install -y openjdk-17-jdk

echo "✅ Verifying Java installation..."
java -version

echo "📦 Installing required dependencies..."
sudo apt install -y gnupg2 curl software-properties-common apt-transport-https ca-certificates

echo "🔐 Adding Jenkins GPG key..."
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo "➕ Adding Jenkins repository..."
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

echo "🔄 Updating package index..."
sudo apt update -y

echo "🚀 Installing Jenkins..."
sudo apt install -y jenkins

echo "🔁 Starting Jenkins service..."
sudo systemctl start jenkins

echo "✅ Enabling Jenkins to start at boot..."
sudo systemctl enable jenkins

echo "🎉 Jenkins installation complete!"
echo "🔑 To get your Jenkins initial admin password, run:"
echo "    sudo cat /var/lib/jenkins/secrets/initialAdminPassword"

#!/bin/bash

echo "🔧 Updating packages..."
sudo apt update -y

echo "☕ Installing Java..."
sudo apt install -y openjdk-17-jdk

echo "📦 Installing Maven..."
sudo apt install -y maven

echo "✅ Verifying Java and Maven versions..."
java -version
mvn -version

echo "🔗 Setting environment variables for JAVA_HOME and MAVEN_HOME..."

# Set JAVA_HOME and MAVEN_HOME
JAVA_PATH=$(readlink -f /usr/bin/java | sed "s:/bin/java::")
echo "export JAVA_HOME=$JAVA_PATH" >> ~/.bashrc
echo "export MAVEN_HOME=/usr/share/maven" >> ~/.bashrc
echo 'export PATH=$PATH:$JAVA_HOME/bin:$MAVEN_HOME/bin' >> ~/.bashrc

# Apply changes
source ~/.bashrc

echo "📂 Creating Jenkins directories if not already present..."
sudo mkdir -p /var/lib/jenkins /var/cache/jenkins /var/log/jenkins

echo "✅ Java & Maven are ready for Jenkins!"
