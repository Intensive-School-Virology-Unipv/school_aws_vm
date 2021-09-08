FROM rocker/rstudio

RUN apt-get clean
RUN apt-get update
RUN apt-get install -y libcurl4-openssl-dev libfontconfig1-dev libxml2 libxml2-dev libz-dev libbz2-dev libclang-dev liblzma-dev

RUN Rscript -e "install.packages('BiocManager', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "BiocManager::install(c('tidyverse', 'Gviz', 'VariantAnnotation', 'GenomicFeatures', 'rtracklayer', 'Biostrings', 'knitr'))"
RUN Rscript -e "BiocManager::install(c('ggtree'))"
RUN Rscript -e "BiocManager::install(c('msa', 'seqinr', 'plotly'))"
RUN Rscript -e "install.packages('kableExtra', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "install.packages('remotes', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "install.packages(c('msa', 'seqinr', 'plotly'), repos = 'https://cloud.r-project.org')"

RUN mkdir -p /opt/shared/DATA
WORKDIR /opt/shared/DATA
RUN apt-get install -y git
RUN git clone https://github.com/Intensive-School-Virology-Unipv/metaviromics_class.git
RUN git clone https://github.com/Intensive-School-Virology-Unipv/metaviromics_data.git
RUN git clone https://github.com/Intensive-School-Virology-Unipv/new_variants_class.git
RUN git clone https://github.com/Intensive-School-Virology-Unipv/new_variants_data.git
RUN git clone https://github.com/Intensive-School-Virology-Unipv/variant_calling_class.git
RUN git clone https://github.com/Intensive-School-Virology-Unipv/variant_calling_data.git