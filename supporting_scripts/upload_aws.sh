 # describe repositories
 ECR_REPOS=($(aws ecr describe-repositories\
 --query 'repositories[*].[repositoryName]'\
 --output text\
 --profile privado_sth))

 echo "AWS ECR repositories:"
 echo "${ECR_REPOS[@]}"

# Build image and add a descriptive tag
docker build --tag=ml-app-local .

# Create dockerpath
DOCKERPATH=017792502591.dkr.ecr.us-east-1.amazonaws.com/ml_app:latest

# to local docker image to central path
docker image tag ml-app-local:latest $DOCKERPATH

# Retrieve an authentication token and authenticate your Docker client to your registry.
aws ecr get-login-password --region region | docker login --username AWS --password-stdin aws_account_id.dkr.ecr.region.amazonaws.com

# Push Docker image to AWS ECR repository
docker push $DOCKERPATH