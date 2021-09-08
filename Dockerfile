FROM conda/miniconda3
LABEL authors='Francesco Lescai' \
      description='Docker image containing all software requirements to run the virtual labs of the UniPV Intensive School on Emerging Viral Threats'

# Install procps so that Nextflow can poll CPU usage
RUN apt-get update && apt-get install -y procps && apt-get clean -y

# Install the conda environment
COPY docker_aws-env.yml /
RUN conda env create -f /docker_aws-env.yml && conda clean -a

# Add conda installation dir to PATH (instead of doing 'conda activate')
ENV PATH /usr/local/envs/aws-env/bin:$PATH
ENV PYTHONPATH /usr/local/envs/aws-env/lib/python3.8/site-packages


RUN mkdir -p /opt/shared
RUN groupadd -g 10000 students
RUN useradd -G students student
RUN echo 'student:v1r0st3ndt0' | chpasswd

WORKDIR /opt
RUN chown -R root:students shared
RUN chmod -R g+w shared

WORKDIR /usr/local
RUN chown -R root:students envs
RUN chmod -R g+w envs

RUN apt-get install -y gdebi-core wget
RUN apt-get install -y --no-install-recommends software-properties-common dirmngr
RUN wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
RUN add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
RUN apt-get install -y --no-install-recommends r-base

WORKDIR /opt
RUN wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-1.4.1717-amd64.deb
RUN gdebi rstudio-server-1.4.1717-amd64.deb

RUN apt-get install -y  libcurl4-openssl-dev libfontconfig1-dev libxml2 libxml2-dev

RUN Rscript -e "install.packages('BiocManager', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "install.packages(c('tidyverse', 'Gviz', 'VariantAnnotation', 'GenomicFeatures', 'rtracklayer', 'Biostrings', 'knitr'), repos = 'https://cloud.r-project.org')"
RUN Rscript -e "install.packages('ggtree', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "install.packages(c('msa', 'seqinr', 'plotly'), repos = 'https://cloud.r-project.org')"
RUN Rscript -e "install.packages('kableExtra', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "install.packages('remotes', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "install.packages(c('msa', 'seqinr', 'plotly'), repos = 'https://cloud.r-project.org')"


RUN jupyter notebook --generate-config
RUN echo "c.NotebookApp.password = 'argon2:\$argon2id\$v=19\$m=10240,t=10,p=8\$2CeoiDPrjDLbQzuqLJ4iIg\$dF2zXRg2Dlln5xvMsEaHXQ'" | tee -a /root/.jupyter/jupyter_notebook_config.py > /dev/null
RUN mkdir -p /home/student/.jupyter/
RUN chown -R student:students /home/student
RUN cp /root/.jupyter/jupyter_notebook_config.py /home/student/.jupyter/jupyter_notebook_config.py
RUN chown student:students /home/student/.jupyter/jupyter_notebook_config.py
COPY jupyter.service /etc/systemd/system/

RUN echo "c.NotebookApp.ip = '*'" | tee -a /root/.jupyter/jupyter_notebook_config.py > /dev/null
RUN echo "c.NotebookApp.ip = '*'" >>/home/student/.jupyter/jupyter_notebook_config.py

RUN mkdir -p /opt/shared/DATA
WORKDIR /opt/shared/DATA
RUN apt-get install -y git
RUN git clone https://github.com/Intensive-School-Virology-Unipv/metaviromics_class.git
RUN git clone https://github.com/Intensive-School-Virology-Unipv/metaviromics_data.git
RUN git clone https://github.com/Intensive-School-Virology-Unipv/new_variants_class.git
RUN git clone https://github.com/Intensive-School-Virology-Unipv/new_variants_data.git
RUN git clone https://github.com/Intensive-School-Virology-Unipv/variant_calling_class.git
RUN git clone https://github.com/Intensive-School-Virology-Unipv/variant_calling_data.git

WORKDIR /
RUN /usr/local/envs/aws-env/bin/python -m bash_kernel.install
RUN apt-get install -y systemd
RUN mkdir -p /opt/shared/jupyter/notebook
ENTRYPOINT /etc/init.d/dbus start && systemctl daemon-reload && systemctl enable jupyter && /bin/bash