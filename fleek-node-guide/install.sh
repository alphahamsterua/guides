#!/bin/bash

echo "Starting install dependencies..."
apt update
apt install curl mc wget git htop net-tools unzip jq build-essential ncdu tmux make cmake clang pkg-config libssl-dev protobuf-compiler -y

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

source $HOME/.cargo/env
cargo install sccache
echo "Dependencies were installed..."

echo "Cloning and building Ursa..."
cd $HOME && \
    git clone https://github.com/fleek-network/ursa.git && \
    cd ursa && \
    make install
echo "Ursa was built..."

echo "sleep 10 sec..."
sleep 10

echo "Starting..."
systemctl daemon-reload
systemctl enable fleek
systemctl restart fleek
echo "Started..."
