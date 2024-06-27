#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e


# Stop the docker-compose file in the current directory
echo "stop docker-compose in the current directory..."
docker-compose down

# Stop the docker-compose file in esignet/docs/docker-compose/
echo "Running docker-compose in esignet/docs/docker-compose/ directory..."
cd esignet/docs/docker-compose/

docker-compose down

echo "esignet  have been stop."
