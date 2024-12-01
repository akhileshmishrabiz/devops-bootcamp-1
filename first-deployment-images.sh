#!/bin/bash

# Variables
AWS_REGION="ap-south-1"
AWS_ACCOUNT_ID="366140438193"
environment="dev"
app_name="app"
REPOSITORY_NAME_APP="${environment}-${app_name}-flask"
REPOSITORY_NAME_NGINX="${environment}-${app_name}-nginx"
REPOSITORY_NAME_REDIS="${environment}-${app_name}-redis"

# Login to ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Function to build and push Docker images
build_and_push() {
    local service=$1
    local repository=$2
    local tag=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$repository:latest

    echo "Building $service image..."
    docker buildx build --platform linux/amd64 -t $tag $service

    echo "Pushing $service image to ECR..."
    docker push $tag
}

# Build and push images
build_and_push "app" $REPOSITORY_NAME_APP
build_and_push "app/nginx" $REPOSITORY_NAME_NGINX
build_and_push "app/redis" $REPOSITORY_NAME_REDIS

echo "All images have been built and pushed successfully."


# aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
# cd app
# docker build -t 366140438193.dkr.ecr.ap-south-1.amazonaws.com/dev-app-flask:latest
#  docker push 366140438193.dkr.ecr.ap-south-1.amazonaws.com/dev-app-flask:latest


# aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 366140438193.dkr.ecr.ap-south-1.amazonaws.com