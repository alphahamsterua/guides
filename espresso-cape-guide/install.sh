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

echo "Downloading docker-compose.yaml..."
curl https://www.espressosys.com/cape/docker-compose.yaml --output docker-compose.yaml
echo "The file was downloaded..."

docker compose pull
docker compose up -d
echo "Docker started..."

echo "Script finished."
