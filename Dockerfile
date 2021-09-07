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

RUN apt-get install -y r-base
RUN apt-get install -y gdebi-core
WORKDIR /opt
RUN wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-1.4.1717-amd64.deb
RUN gdebi rstudio-server-1.4.1717-amd64.deb

RUN Rscript -e "install.packages('BiocManager')"
RUN Rscript -e "BiocManager::install(c('tidyverse', 'Gviz', 'VariantAnnotation', 'GenomicFeatures', 'rtracklayer', 'Biostrings', 'knitr'))"
RUN Rscript -e "BiocManager::install(c('ggtree'))"
RUN Rscript -e "BiocManager::install(c('msa', 'seqinr', 'plotly'))"
RUN Rscript -e "install.packages('kableExtra', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "install.packages('remotes', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "BiocManager::install(c('msa', 'seqinr', 'plotly'))"


RUN jupyter notebook --generate-config
RUN echo "c.NotebookApp.password = 'argon2:\$argon2id\$v=19\$m=10240,t=10,p=8\$2CeoiDPrjDLbQzuqLJ4iIg\$dF2zXRg2Dlln5xvMsEaHXQ'" | sudo tee -a /root/.jupyter/jupyter_notebook_config.py > /dev/null
RUN echo "c.NotebookApp.password = 'argon2:\$argon2id\$v=19\$m=10240,t=10,p=8\$2CeoiDPrjDLbQzuqLJ4iIg\$dF2zXRg2Dlln5xvMsEaHXQ'" >>/home/student/.jupyter/jupyter_notebook_config.py

COPY jupyter.service /etc/systemd/system/

RUN echo "c.NotebookApp.ip = '*'" | tee -a /root/.jupyter/jupyter_notebook_config.py > /dev/null
RUN echo "c.NotebookApp.ip = '*'" >>/home/ubuntu/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.ip = '*'" >>/home/student/.jupyter/jupyter_notebook_config.py

RUN mkdir -p /opt/shared/DATA
WORKDIR /opt/shared/DATA
RUN git clone https://github.com/Intensive-School-Virology-Unipv/metaviromics_class.git
RUN git clone https://github.com/Intensive-School-Virology-Unipv/metaviromics_data.git
RUN git clone https://github.com/Intensive-School-Virology-Unipv/new_variants_class.git
RUN git clone https://github.com/Intensive-School-Virology-Unipv/new_variants_data.git
RUN git clone https://github.com/Intensive-School-Virology-Unipv/variant_calling_class.git
RUN git clone https://github.com/Intensive-School-Virology-Unipv/variant_calling_data.git

WORKDIR /
RUN conda activate aws-env
RUN python -m bash_kernel.install

RUN systemctl daemon-reload
RUN systemctl enable jupyter
ENTRYPOINT systemctl start jupyter && rstudio-server start && /bin/bash