#!/bin/bash
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
apt-get update && apt-get install -y aspnetcore-runtime-6.0

cat << EOF > /etc/systemd/system/MyApp.service
[Unit]
Description=CiCdDemo

[Service]
WorkingDirectory=/actions-runner/_work/cicdrunner/cicdrunner
ExecStart= /usr/bin/dotnet /actions-runner/_work/cicdrunner/cicdrunner/cicdrunner.dll

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload

mkdir actions-runner && cd actions-runner
curl -o actions-runner-linux-x64-2.303.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.303.0/actions-runner-linux-x64-2.303.0.tar.gz
echo "e4a9fb7269c1a156eb5d5369232d0cd62e06bec2fd2b321600e85ac914a9cc73  actions-runner-linux-x64-2.303.0.tar.gz" | shasum -a 256 -c
tar xzf ./actions-runner-linux-x64-2.303.0.tar.gz
chown -R azureuser:azureuser /actions-runner
su azureuser -c "./config.sh --url https://github.com/Larsson233/cicdrunner --token AY74E57G4TKLAMID4UDE7CLEELP66 --unattended"
./svc.sh install
./svc.sh start