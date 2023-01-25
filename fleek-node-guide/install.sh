#!/bin/bash

echo "Starting install dependencies..."
apt update
apt install curl mc wget git htop net-tools unzip jq build-essential ncdu tmux make cmake clang pkg-config libssl-dev protobuf-compiler -y

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

source $HOME/.cargo/env
cargo install sccache
echo "Dependencies were installed..."

echo "Cloning and building Ursa..."
cd $HOME && \
    git clone https://github.com/fleek-network/ursa.git && \
    cd ursa && \
    make install
echo "Ursa was built..."

tee <<EOF /etc/systemd/system/fleek.service
[Unit]
Description=My-Fleek-node
After=network.target
[Service]
User=$USER
ExecStart=/root/.cargo/bin/ursa
WorkingDirectory=$HOME/ursa
Restart=on-failure
RestartSec=3
LimitNOFILE=4096
[Install]
WantedBy=multi-user.target
EOF

echo "sleep 10 sec..."
sleep 10

echo "Starting..."
systemctl daemon-reload
systemctl enable fleek
systemctl restart fleek
echo "Started..."
