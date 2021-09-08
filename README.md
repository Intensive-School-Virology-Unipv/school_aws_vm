# Intensive School on Emerging Viral Threats

## Table of Contents

* [Setting up AWS Virtual Machine](#setting-up-aws)
* [Running a Docker container](#running-docker)
    * [Installing docker](#installing-docker)
    * [Running the container](#running-the-container)
    * [Using Jupyter](#using-jupyter)
    * [Using RStudio](#using-rstudio)



## Setting up AWS

A detailed setup for the Amazon Virtual machine can be found [here](setup_vm.md)


## Running Docker

Students who wish to keep exercising, following the virtual labs can use our Docker container, as explained below.

### Installing Docker

Depending on the OS you are running, installation instructions might vary.

Please, do follow the detailed guide available on Docker [website](https://docs.docker.com/get-docker/)

### Running the container

Once you have Docker up and running, you can download our container using the following command:

```{bash}
docker pull ghcr.io/intensive-school-virology-unipv/viroschool:v1.00
```

Then, docker can be run in detatched mode, making sure you expose the necessary ports:


```{bash}
docker run -d --rm \
-p 127.0.0.1:8787:8787 \
-p 8888:8888 \
-v "${PWD}"/jupyter:/home/jovyan/work \
-v "${PWD}"/rstudio:/home/rstudio \
-e DISABLE_AUTH=true \
ghcr.io/intensive-school-virology-unipv/viroschool:v1.00
```

Please note, in the above example we have made available 2 folders in the directory you're launching the command from: one is for RStudio and one is for Jupyter notebooks.

In order to verify the container is up and running, you can type:


```{bash}
docker ps
```

This command is also important to get the container ID.

### Using Jupyter

When Jupyter is started, a token is printed on screen with the authentication to the notebook. We need to grab this token from the logs, since we started the container in a detatched mode.

We can do this following this command:

```{bash}
docker logs --tail 3 CONTAINERID
```

this will point to something like:

```
or http://127.0.0.1:8888/?token=abd4122c459c43ccede675a5c65e837d90b1f6b9be64e1ce
```

You can use that URL in your browser.

### Using Rstudio
