[![CircleCI](https://circleci.com/gh/bofflord/cloud_devops_capstone/tree/master.svg?style=svg)](https://circleci.com/gh/bofflord/cloud_devops_capstone/tree/master)

# Udacity Cloud DevOps Engineer Nanodegree Program - Capstone Project #

## Project Overview

In this project a Machine Learning Microservice API is operationalized and integrated into a Continuous Integration and Continuous Deployment pipeline. This pipeline is implemented via CircleCi and enables an automated "blue-green" deployment of new product versions. The infrastructure is built in the AWS Cloud mainly via the services ECR, EKS, Fargate and Cloudfront.

The Machine Learning Microservice API is adapted from the [ML Microservice project](https://github.com/bofflord/ml-microservice-kubernetes).
A pre-trained, `sklearn` model that has been trained to predict housing prices in Boston according to several features, such as average rooms in a home and data about highway access, teacher-to-pupil ratios, and so on. You can read more about the data, which was initially taken from Kaggle, on [the data source site](https://www.kaggle.com/c/boston-housing). This model is applied in a Python flask app in a provided file, `app.py`. The app serves out predictions (inference) about housing prices through API calls. This project could be extended to any pre-trained machine learning model, such as those for image recognition and data labeling.

This project contains scripts that allow to run the app locally (standalone), in a Docker container or in a Kubernetes cluster. 

Furthermore a CircleCI integration ensures successful requirements installation and linting of the application code. This is indicated by the "PASSED" badge on top of the repository.

---
## CI/CD Pipeline
![Alt text](/screenshots/2022-01-27_18_02_17-cloud_devops_capstone_workflow2.png?raw=true "CI/CD Pipeline of ML APP project - compact view")
### Overview of pipeline jobs:
- build_app: lints the ML application and the corresponding Dockerfile.
- build_container: 
    - builds a Docker container for the ML app. 
    - stores the container in an AWS ECR repository.
- create_eks_cluster:
    - checks if an EKS cluster for the ML app is existing.
    - If none is existing, a Kubernetes cluster is created on AWS EKS.
    - cluster resources are managed by AWS Fargate.
- setup_eks_loadbalancer:
    - creates/ upgrades the policies and roles for an application load balancer.
    - creates/ upgrades an application load balancer for EKS cluster.
    - the loadbalancer is required in order expose the application to the internet.
- create_fargate_profile:
    - creates a new Fargate profile for the updated application product, the "green" version.
    - the unique identifier of the new profile is a substring of the CircleCI workflow ID.
- deploy_container:
    - deploys the container with the new application version to the EKS cluster.
    - the "green" application is deployed to namespace of the "green" Fargate profile.
    - this is done via a Kubernetes manifest that specifies the creation of the following elements:
        - Namespace
        - Deployment (with reference to AWS ECR docker image)
        - Service: routing from Docker container port to Kubernetes node port.
        - Ingress: routing from Kubernetes node port to internet-facing application load balancer
- smoketest_app:
    - this job smoketests the functionality of the API and the application behind it.
    - it sends a sample request to internet-address of the exposed application port and verifies that a response with the prediction result is sent.
    - this result is checked against the expected value to ensure that the app is working as expected.
    - if the smoketest is successful, the "green" app update is promoted to production.
    - if the smoketest fails, the "green" app specific resources on the EKS Cluster are destroyed by deletion of the corresponding Fargate profile.
- prod_promotion
    - users of the ML app interact only with URl of the Cloudfront distribution.
    - promotion to production is done via updating the Cloudfront distribution of the ML app.
    - the corresponding Cloudformation stack of the Cloudfront distribution is deployed again and updates the origin URL to the one of the "green" ML app.
    - Thus users are no longer routed to the previous "blue" ML app URK.
- cleanup
    - this jobs removes all infrastructure of previous ML app versions by deleting their Fargate profiles.

## Environment setup

* Create a virtualenv with Python 3.7 and activate it. Refer to this link for help on specifying the Python version in the virtualenv. Alternatively you may run `make setup`
```bash
python3 -m pip install --user virtualenv
# You should have Python 3.7 available in your host. 
# Check the Python path using `which python3`
# Use a command similar to this one:
python3 -m virtualenv --python=<path-to-Python3.7> .devops
source .devops/bin/activate
```
* Run `make install` to install the necessary dependencies

## App deployment and Usage

### Running `app.py`

1. Standalone:  `python app.py`
2. Run in Docker:  `. run_docker.sh`
3. Run in Kubernetes:  `. run_kubernetes.sh`
    - Prerequisite: app image is uploaded to Docker Hub: `. run upload_docker.sh`

### Making predictions on the locally deployed app

* These is instrcutions apply to all app deployments: Standalone, Docker, Kubernetes
* Update the required parameters in `make_predictions.sh`
* Run `. make_predictions.sh`

## Explanation of repository files

### CI/CD Pipeline and required infrastructure files


### App and ML model files
* app.py: flask app which incorporates ML model
* model_data: ML model data

### Installation and Deployment files
* Dockerfile: all instruction for Docker image building of app
* Makefile: commands for setup, install, test and lint of app
* requirements.txt: lists all libraries required for app execution

### Supporting scripts: folder supporting_scripts
* run_docker.sh: see App deployment and Usage
* run_kubernetes.sh: see App deployment and Usage
* upload_aws.sh: for manual upload of Docker image to AWS ECR
* testing.sh: for testing of application. Sends a sample request to the ML API. Parameters:
    * (1): IP address of ML app API.
    * (2): port of ML app API.
* delete_all_infra: for manual deletion of all infrastruktur. This includes the EKS Cluster.

### Supplements
* README.md