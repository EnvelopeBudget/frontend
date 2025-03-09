#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Run project tests
yarn testCI

test_exit_code=$?

# Check the exit code
if [ $test_exit_code -eq 0 ]; then
  echo "Project tests were successful!"
else
  echo "Project tests failed."
  exit 1 # Exit with a non-zero code to indicate failure
fi

# Docker image details
IMAGE_NAME="envelope-budget-frontend"
export PROJECT_VERSION="$(cat project.version)"

# Docker Hub credentials
DOCKER_USERNAME="alserbin"

# echo "Building envelope-budget-frontend project - $PROJECT_VERSION"
docker build -t $DOCKER_USERNAME/$IMAGE_NAME:$PROJECT_VERSION .
# echo "Tagging envelope-budget-frontend project - latest"
docker image tag $DOCKER_USERNAME/$IMAGE_NAME:$PROJECT_VERSION $DOCKER_USERNAME/$IMAGE_NAME:latest

# Log in to Docker Hub
echo "Logging into Docker Hub..."
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

# Push the Docker images
echo "Pushing image $IMAGE_NAME:$PROJECT_VERSION to Docker Hub..."
docker push "$DOCKER_USERNAME/$IMAGE_NAME:$PROJECT_VERSION"
docker push "$DOCKER_USERNAME/$IMAGE_NAME:latest"

echo "Push successful!"
exit 0


