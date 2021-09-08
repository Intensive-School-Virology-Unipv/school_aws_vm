FROM rocker/rstudio

RUN apt-get install -y  libcurl4-openssl-dev libfontconfig1-dev libxml2 libxml2-dev libz-dev

RUN Rscript -e "install.packages('BiocManager', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "BiocManager::install(c('tidyverse', 'Gviz', 'VariantAnnotation', 'GenomicFeatures', 'rtracklayer', 'Biostrings', 'knitr'))"
RUN Rscript -e "BiocManager::install(c('ggtree'))"
RUN Rscript -e "BiocManager::install(c('msa', 'seqinr', 'plotly'))"
RUN Rscript -e "install.packages('kableExtra', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "install.packages('remotes', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "install.packages(c('msa', 'seqinr', 'plotly'), repos = 'https://cloud.r-project.org')"



FROM jupyter/datascience-notebook

# Install the conda environment
COPY aws_vm_env.yml /
RUN conda env create -f /aws_vm_env.yml && conda clean -a

# Add conda installation dir to PATH (instead of doing 'conda activate')
ENV PATH /opt/conda/envs/aws-env/bin:$PATH
ENV PYTHONPATH /opt/conda/envs/aws-env/lib/python3.8/site-packages