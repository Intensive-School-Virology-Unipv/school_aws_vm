# Intensive School on Emerging Viral Threats

## Table of Contents

* [Setting up AWS Virtual Machine](#setting-up-aws)
* [Running a Docker container](#running-docker)
    * [Installing docker](#installing-docker)
    * [Using Jupyter](#using-jupyter)
    * [Using RStudio](#using-rstudio)



## Setting up AWS

A detailed setup for the Amazon Virtual machine can be found [here](setup_vm.md)


## Running Docker

Students who wish to keep exercising, following the virtual labs can use our Docker container, as explained below.

### Installing Docker

Depending on the OS you are running, installation instructions might vary.

Please, do follow the detailed guide available on Docker [website](https://docs.docker.com/get-docker/)


### Using Jupyter

In order to access the Jupyter notebooks, you need to run the *jupyter* container.

You can do so, by using the following command. This assumes:

- you will connect through your browser, at the URL *localhost:8888*
- you have a folder called *jupyter* in the folder you are launching the command from

Should this not be the case, please do modify the following command appropriately:


```{bash}
docker run -d --rm \
-p 8888:8888 \
-v "${PWD}"/jupyter:/home/jovyan/work \
ghcr.io/intensive-school-virology-unipv/jupyter:main
```

In order to verify the container is up and running, you can type:


```{bash}
docker ps
```

This command is also important to get the container ID.


When Jupyter is started, a token is printed on screen with the authentication to the notebook. We need to grab this token from the logs, since we started the container in a detatched mode.

We can do this using the container ID you grabbed in the previous step in the following command:

```{bash}
docker logs --tail 3 CONTAINERID
```

this will point to something like:

```
or http://127.0.0.1:8888/?token=abd4122c459c43ccede675a5c65e837d90b1f6b9be64e1ce
```

You can use that URL in your browser.
The notebook will open where the code and data from the virtual laboratories has been saved.

### Using Rstudio

In order to use RStudio server, you should run the *rstudio* container with the command below.

This assumes:

- you will connect through your browser, at the URL *localhost:8787*
- you have a folder called *rstudio* in the folder you are launching the command from
- this will be mapped in the home of Rstudio under the name *local*

Should this not be the case, please do modify the following command appropriately:

```{bash}
docker run -d --rm \
-p 127.0.0.1:8787:8787 \
-v "${PWD}"/rstudio:/home/rstudio/local \
-e DISABLE_AUTH=true \
ghcr.io/intensive-school-virology-unipv/rstudio:main
```

The school code and data is located in the container at the path ```/opt/shared/DATA```: you can navigate through the RStudio interface to this location and retrieve the notebook you need.