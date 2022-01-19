[![CircleCI](https://circleci.com/gh/bofflord/ml-microservice-kubernetes/tree/master.svg?style=svg)](https://circleci.com/gh/bofflord/ml-microservice-kubernetes/tree/master)

## Project Overview

In this project a Machine Learning Microservice API is operationalized. It is part of the Udacity Cloud Devops Engineer Nanodegree.

A pre-trained, `sklearn` model that has been trained to predict housing prices in Boston according to several features, such as average rooms in a home and data about highway access, teacher-to-pupil ratios, and so on. You can read more about the data, which was initially taken from Kaggle, on [the data source site](https://www.kaggle.com/c/boston-housing). This model is applied in a Python flask app in a provided file, `app.py`. The app serves out predictions (inference) about housing prices through API calls. This project could be extended to any pre-trained machine learning model, such as those for image recognition and data labeling.

This project contains scripts that allow to run the app locally (standalone), in a Docker container or in a Kubernetes cluster. 

Furthermore a CircleCI integration ensures successful requirements installation and linting of the application code. This is indicated by the "PASSED" badge on top of the repository.

---

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

### Deployment and usage files
* run_docker.sh: see App deployment and Usage
* run_kubernetes.sh: see App deployment and Usage
* upload_docker.sh: see App deployment and Usage
* make_prediction.sh: see App deployment and Usage

### App and ML model files
* app.py: flask app which incorporates ML model
* model_data: ML model data

### Installation and Deployment files
* Dockerfile: all instruction for Docker image building of app
* Makefile: commands for setup, install, test and lint of app
* requirements.txt: lists all libraries required for app execution

### Supplements
* README.md
* output_txt_files
* Not included in repository, but required for Docker Hub login: dockertoken.txt