#! /bin/bash

echo "Script started..."

echo "Downloading and installing Docker is started..."
curl -fsSL https://get.docker.com -o get-docker.sh && \
    sh get-docker.sh && \
    rm -rf get-docker.sh
echo "Finished..."

echo "Prepering Docker..."
usermod -aG docker $USER

systemctl enable docker
systemctl start docker
echo "Docker started..."

echo "Downloading ursa repo..."
apt update && \
    apt install unzip

wget https://github.com/fleek-network/ursa/archive/refs/heads/main.zip && \
    unzip main.zip && \
    rm -rf main.zip && \
    cd ursa-main
echo "ursa repo was downloaded..."

echo "Building ursa image..."
DOCKER_BUILDKIT=1 docker build -t ursa:latest .
echo "Image was built..."

echo "Starting container..."
docker run -d -p 4069:4069 -p 6009:6009 -v $HOME/.ursa/:/root/.ursa/:rw --name ursa-cli -it ursa
echo "Container started..."
echo "Script finished."
