# Setup of the base Virtual Machine AMI

## 1. Launch the VM


- in the console we have selected **t2.large** because we need at least 2 cores and at least 6GB memory
- we have left networking as default
- we have added a 50GB root volume and left "delete on termination" option on
- **important** we have added TAGs to enable cost monitoring: use = virology summer school and step = setup
- security group: we have used existing training test


## 2. Configure the VM

- once the VM is running, connect from within the AWS account
- create a shared folder for users to access with ```sudo -s``` first and ```mkdir -p /opt/share``` afterwards
- create students group with ```groupadd -g 10000 students```
- add student users to group with ```useradd -G students student```
- create password for student
- change group ownership to opt/shared with ```chown -R root:students shared```
- change permissions to folder with ```chmod -R g+w shared```
- install anaconda prerequisites

```
apt-get update

apt-get install -y \
libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6

wget https://repo.anaconda.com/archive/Anaconda3-2021.05-Linux-x86_64.sh .

bash Anaconda3-2021.05-Linux-x86_64.sh

```

- install anaconda on a shared path ```/opt/shared/anaconda```
- add conda initialisation script to *.bashrc* of student and ubuntu
- configure *.condarc* in */opt/shared/anaconda* to specify default channels and env_dirs as follows:

```
envs_dirs:
  - /opt/shared/envs
channels:
  - conda-forge
  - bioconda
  - defaults
```

- change permissions of env folder ```chown -R root:students envs``` and ```chmod -R g+w envs```
- create the environment for the school with ```conda env create -f aws_vm_env.yml```

NB: when a large number of tools is included in the environment, it might take a long time to resolve all compatible versions to be combined into the env.

- once the environment is created, it is convenient to export its file in order to have all versions already resolved in case it should be reused.

- add the conda environment to path for all users

```
echo "export PATH=${PATH}:/opt/shared/envs/aws-env/bin" >>~/.bashrc
echo "export PATH=${PATH}:/opt/shared/envs/aws-env/bin" >>/home/ubuntu/.bashrc
echo "export PATH=${PATH}:/opt/shared/envs/aws-env/bin" >>/home/student/.bashrc
```

- make sure the python libraries installed in the conda environment are visible when python is launched

```
echo "export PYTHONPATH=/opt/shared/envs/aws-env/lib/python3.8/site-packages" >>~/.bashrc
echo "export PYTHONPATH=/opt/shared/envs/aws-env/lib/python3.8/site-packages" >>/home/ubuntu/.bashrc
echo "export PYTHONPATH=/opt/shared/envs/aws-env/lib/python3.8/site-packages" >>/home/student/.bashrc
```


- update krona taxonomy as per instructions

- upload all data
- install RStudio Server

```
apt install r-base
apt-get install gdebi-core
wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-1.4.1717-amd64.deb
gdebi rstudio-server-1.4.1717-amd64.deb
```

- packages should be installed on the student users so they will be available without problems during the class

Install dependencies in libraries

```
apt-get install -y \
  libcurl4-openssl-dev \
  libssl-dev \
  libfontconfig1-dev \
  libxml2-dev
```

Install packages as required

```
R
install.packages("BiocManager")
BiocManager::install(c("tidyverse", "Gviz", "VariantAnnotation", "GenomicFeatures", "rtracklayer", "Biostrings", "knitr"))
BiocManager::install(c('ggtree'))
BiocManager::install(c('msa', 'seqinr', 'plotly'))
install.packages('kableExtra', repos = 'https://cloud.r-project.org')
install.packages('remotes', repos = 'https://cloud.r-project.org')
BiocManager::install(c('msa', 'seqinr', 'plotly'))

## test if they install
library(tidyverse)
library(Gviz)
library(VariantAnnotation)
library(Biostrings)
library(ggtree)
library(msa)
library(plotly)
library(msa)
```

- enable password authentication on VM

```
vim /etc/ssh/sshd_config
```
and change to *yes*

- setup jupyter notebook

```
jupyter notebook --generate-config
echo "c.NotebookApp.password = 'argon2:\$argon2id\$v=19\$m=10240,t=10,p=8\$2CeoiDPrjDLbQzuqLJ4iIg\$dF2zXRg2Dlln5xvMsEaHXQ'" | sudo tee -a /root/.jupyter/jupyter_notebook_config.py > /dev/null
echo "c.NotebookApp.password = 'argon2:\$argon2id\$v=19\$m=10240,t=10,p=8\$2CeoiDPrjDLbQzuqLJ4iIg\$dF2zXRg2Dlln5xvMsEaHXQ'" >>/home/ubuntu/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.password = 'argon2:\$argon2id\$v=19\$m=10240,t=10,p=8\$2CeoiDPrjDLbQzuqLJ4iIg\$dF2zXRg2Dlln5xvMsEaHXQ'" >>/home/student/.jupyter/jupyter_notebook_config.py


cat << EOF >jupyter.service

[Unit]
Description=Jupyter Notebook

[Service]
Type=simple
PIDFile=/run/jupyter.pid
ExecStart=jupyter lab --notebook-dir=/opt/shared/jupyter/notebook
User=student
Group=student
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target

EOF

mv jupyter.service /etc/systemd/system/.


echo "c.NotebookApp.ip = '*'" | sudo tee -a /root/.jupyter/jupyter_notebook_config.py > /dev/null
echo "c.NotebookApp.ip = '*'" >>/home/ubuntu/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.ip = '*'" >>/home/student/.jupyter/jupyter_notebook_config.py


systemctl daemon-reload
systemctl enable jupyter
systemctl start jupyter

```