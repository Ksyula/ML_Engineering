#! /bin/bash

# BentoML: build, package, deploy a model for an at scale, production ready service
# Bento packages everything related to ML code:

    # static dataset
    # model(s)	
    # code
    # configuration files
    # dependencies
    # deployment logic

# Workflow: 

    # get jupyter notebook from week 7 of mlbookcamp-code repo
    # first create an anconda env and install xgboost and bentoML via pip
    # save model via bento ML and serve it locally and test with Swagger UI
	# containerize the bentoml (underyling using docker)
	# serve it locally with docker and test from Swagger UI or the terminal

# ignore the next block:
#### Preventing autoamatic execution of this script if someone runs it:
echo "This is not meant to be an executable shell script. Please open this file in a text editor or VSCode and run the commands one by one"
echo "Press any key to exit"
read -n 1  "key"
exit 


# Start from here
#### git setup

# fork the mlbookcamp-code repo to your own github account, and copy the HTTPS URL and clone it to local:
git clone "URL of your forked mlbookcamp"
# in case you already cloned it before and need to pull new changes:
cd mlbookcamp-code
git switch master
# add the original bookcamp code repo to remote. I call it upstream.
git remote add upstream https://github.com/alexeygrigorev/mlbookcamp-code.git
# if you've already added, it will list all remotes:
git remote -v
git pull upstream master
# add changes back to your own fork of mlbookcamp-code
git push

# add files from the newly cloned directory:
mkdir week7
cd week7/
cp -r /mnt/d/5-Courses/mlbookcamp-code/course-zoomcamp/07-bentoml-production/code/* .


#### conda environement setup

 # if base is already activated, run the following to create an environment called bento:
conda create -n bento jupyter numpy pandas scikit-learn

# It's better to install bentoml via pip because the conda repo is not actively or officially maintained, however in this case, we need 
# to install xgboost with pip too, and an additional package pydantic
conda activate bento
pip install bentoml pydantic xgboost


#### Training and saving the model with bentoML:

# start jupyter notebook 
jupyter notebook
# run train.ipynb from week 6 using the XGBoost model trained on data without feature names
# details in video 7.2 and 7.5
# sample train.ipynb file can be found here:
# https://github.com/MemoonaTahira/MLZoomcamp2022/blob/main/Notes/Week_7-production_ready_deployment_bentoML/train.ipynb
# save the model using bentoml in jupyter notebook
# copy the string inside the quotes in the tag parameter
# install vim editor to write service.py:


#### Starting the bentoML service from terminal:
sudo apt update
sudo apt search vim
sudo apt install vim
vim --version

# or just use vscode with the bento conda environment, it will be less painful
# vim is useful when you can only work within the terminal with no GUI

# create new file called service.py and write the code from video 7.2 + 7.4 + 7.5 in it
# Video 7.4 - for more info on pydantic: https://pydantic-docs.helpmanual.io/ for defining our validation schema
# Vide 7.4 - for input/output type of the model: https://docs.bentoml.org/en/latest/reference/api_io_descriptors.html
# sample service.py can be found here:
# https://github.com/MemoonaTahira/MLZoomcamp2022/blob/main/Notes/Week_7-production_ready_deployment_bentoML/service.py
# save service.py and run from terminal:

bentoml serve service.py:svc --reload

# this opens swagger UI which is based on openAI, change URL to 127.0.0.1:3000 instead of
# default 0.0.0.0:3000 it shows in terminal
# opens correctly if link CTRL+clicked from vscode, translates 0.0.0.0:3000 to localhost

# click on the 'POST /classify' button, and then click on 'try it' and paste the test user information json from the train.ipynb 
# It should show you 200 Successful Response with the final decision of the model:
# Either the loan is approved, maybe or denied


#### Try different information commands in bentoml:

# Get list of models stored in the bentoml models directory:
bentoml models list
# Look at the metadata of a particular model:
# this was my model name and tag:
bentoml models get credit_risk_model:loqp7isqtki4aaav
# change model name and tag to your like this: 
# bentoml models get <model name>:<tag> 
# it returns something like this:

`
name: credit_risk_model
version: loqp7isqtki4aaav
module: bentoml.xgboost
labels: {}
options:
  model_class: Booster
metadata: {}
context:
  framework_name: xgboost
  framework_versions:
    xgboost: 1.6.2
  bentoml_version: 1.0.7
  python_version: 3.10.6
signatures:
  predict:
    batchable: false
api_version: v2
creation_time: '2022-10-20T17:12:21.082672+00:00'

`
# to delete a particular model:
bentoml models delete  credit_risk_model:<tag>

#### Bento build for a single unit/package of the model:

# create a newfile and name it bentofile.yaml from vscode, initially populated with standard content
# sample bentofile.yaml can be found here:
# https://github.com/MemoonaTahira/MLZoomcamp2022/blob/main/Notes/Week_7-production_ready_deployment_bentoML/bentofile.yaml
# here we add info on environment, packages and docker etc. 
# Use video 7.3 for adding content
# go here for more: https://docs.bentoml.org/en/0.13-lts/concepts.html

# edit and save, and then build bento:
# P.S. run this command from the folder where bentofile.yaml is
bentoml build
# successful build will display the bentoml logo

# next, cd to where the bento is built and look inside:
# default location for built services: /home/mona/bentoml/bentos    
 cd ~/bentoml/bentos/credit_risk_classifier/latest/
# you can replace  qlkhqrsqv6kpeaavt with any other bento tag
# install and run tree to see what's inside:
sudo apt install tree
tree
# it will show something like this:
`
.
├── README.md
├── apis
│   └── openapi.yaml
├── bento.yaml
├── env
│   ├── docker
│   │   ├── Dockerfile
│   │   └── entrypoint.sh
│   └── python
│       ├── install.sh
│       ├── requirements.lock.txt
│       ├── requirements.txt
│       └── version.txt
├── models
│   └── credit_risk_model
│       ├── latest
│       └── loqp7isqtki4aaav
│           ├── custom_objects.pkl
│           ├── model.yaml
│           └── saved_model.ubj
└── src
    ├── locustfile.py
    └── service.py

`

# wohoo, it created a dockerfile for us on its own besides a neatly structured model
# environment and some src files to serve the bento.

#### Load testing with locust for high performance optimization:

# you don't need to manually create locust.py if you've run "bento build" already. 
# If not then, you might need to create locustfile.py manually (sample added)
 # make sure you have bentoml serve --production running in one tab in the folder from where you ran the bentoml build
# comamands (which bentofile.yaml to build the model, which in turn used service.py)

bentoml serve --production
# open another tab and run:
locust -H http://localhost:3000
# do load testing.
# make sure you have modified the train.ipynb to work to accept microbatching in async mode to create a more robust service if you haven't already (video 7.5)


#### OPTIONAL - Speed up docker build: Only if you have an NVIDIA GPU + Windows 11 + WSL ready NVIDIA drivers
# set up nvidia container runtime for building docker containers with GPU:
# https://github.com/NVIDIA/nvidia-docker

distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
      && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
      && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
            sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
            sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list


sudo apt-get update
sudo apt-get install -y nvidia-docker2
# sudo systemctl restart docker
# systemctl doesn't work with WSL, just start the docker srevice:
sudo dockerd & 
# hit enter once to exit the INFO message, the docker service will keep running in the background
sudo docker run --rm --gpus all nvidia/cuda:11.0.3-base-ubuntu20.04 nvidia-smi
# once done, run docker images to get image ID and then run:
docker rmi <image ID>


#### Build the docker image:
cd 
cd week7
# start docker service
sudo dockerd &
# for some reason, the command above hangs up sometimes, try pressing ENTER if nohting happens for a while
# if it fails to start successfully, first run:
sudo dockerd
# then enter CTRL+C to exit, and then run 
sudo dockerd &
# As far as I understand, the sudo dockerd& allows you to keep working in the same terminal by returning you to terminal prompt if you
# hit enter once all the INFO messages are displayed to get back to terminal prompt
# next, start containerizing bentoml
bentoml containerize credit_risk_classifier:qlkhqrsqv6kpeaav


#### Only do this portion if it gives you an error about missing docker plugins, run this:
# only trying to install docker compose plugins didnt work:https://docs.docker.com/compose/install/linux/
# more info: https://docs.docker.com/engine/install/ubuntu/#set-up-the-repository

sudo apt-get update

sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
# it will upgrade docker compose (in case it is upto date, it won't change it) and install missing components
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# you are good to go. Run the build command again.  
bentoml containerize credit_risk_classifier:qlkhqrsqv6kpeaav

#### Run with docker to serve the bento and make predictions via Swagger UI!
docker run -it --rm -p 3000:3000 credit_risk_classifier:qlkhqrsqv6kpeaav 

# it says it will start service on  http://0.0.0.0:3000 but change to 127.0.0.1:3000
# opens correctly if link CTRL+clicked from vscode, translates 0.0.0.0:3000 to localhost

# It will open the swagger UI once again:
# Repeat steps from before:

# click on the 'POST /classify' button, and then click on 'try it' and paste the test user information json from the train.ipynb 
# sample user data:
`
{
  "seniority": 3,
  "home": "owner",
  "time": 36,
  "age": 26,
  "marital": "single",
  "records": "no",
  "job": "freelance",
  "expenses": 35,
  "income": 0.0,
  "assets": 60000.0,
  "debt": 3000.0,
  "amount": 800,
  "price": 1000
}
`
# It should show you 200 Successful Response with the final decision of the model:
`
{
  "status": "MAYBE"
}
`
# With any other test user, either the response is APPROVED, MAYBE or DECLINED


#### Run with docker to serve the bento and make predictions via terminal!

# instead of opening the 127.0.0.1:3000 URL,open another terminal and use curl:

cd week7
conda activate bento

# then paste this:

curl -X 'POST' \
'http://127.0.0.1:3000/classify' \
-H 'accept: application/json' \
-H 'Content-Type: application/json' \
-d '{
"seniority": 3,
"home": "owner",
"time": 36,
"age": 26,
"marital": "single",
"records": "no",
"job": "freelance",
"expenses": 35,
"income": 0.0,
"assets": 60000.0,
"debt": 3000.0,
"amount": 800,
"price": 1000
}'

#It should return the prediction from the model as either APPROVED, MAYBE or DECLINED like this:
`
{"status":"MAYBE"}
`




