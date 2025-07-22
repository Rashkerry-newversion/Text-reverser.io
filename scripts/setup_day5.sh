#!/bin/bash

echo "📦 Installing Nexus 3.82.0 on port 9002..."

# 1. Update
sudo apt update && sudo apt upgrade -y

# 2. Install Java 17
sudo apt install -y openjdk-17-jdk wget tar

# 3. Create nexus user
sudo useradd -m -U -d /opt/nexus -s /bin/false nexus 2>/dev/null || echo "User nexus already exists"

# 4. Download Nexus 3.72.0-04
cd /tmp
wget https://download.sonatype.com/nexus/3/nexus-3.72.0-04-unix.tar.gz -O nexus.tar.gz

# 5. Extract and move
sudo mkdir -p /opt/nexus
sudo tar -zxvf nexus.tar.gz -C /opt/nexus --strip-components=1

# 6. Set permissions
sudo chown -R nexus:nexus /opt/nexus
sudo chmod +x /opt/nexus/bin/nexus

# 7. Change port from 8081 → 9002
sudo sed -i 's/application-port=8081/application-port=9002/' /opt/nexus/etc/nexus-default.properties

# 8. Create systemd service
echo "🔧 Creating systemd service..."
sudo tee /etc/systemd/system/nexus.service > /dev/null <<EOF
[Unit]
Description=Nexus Repository Manager
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
User=nexus
Group=nexus
ExecStart=/opt/nexus/bin/nexus start
ExecStop=/opt/nexus/bin/nexus stop
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF

# 9. Start and enable service
echo "🚀 Starting Nexus..."
sudo systemctl daemon-reload
sudo systemctl enable nexus
sudo systemctl start nexus

echo "⏳ Waiting for Nexus to boot..."
sleep 30

# 10. Confirm Nexus is running
if curl -s http://localhost:9002 | grep -q "Nexus Repository Manager"; then
  echo "✅ Nexus is running on http://localhost:9002"
else
  echo "❌ Nexus may have failed. Use: sudo journalctl -xeu nexus.service"
fi

echo "🔐 Default admin password:"
echo "cat /opt/sonatype-work/nexus3/admin.password"
