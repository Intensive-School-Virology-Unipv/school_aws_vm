FROM jupyter/datascience-notebook

# Install the conda environment
# COPY docker_env.yml /
# RUN conda env create -f /docker_env.yml && conda clean -a
RUN conda config --system --prepend channels defaults bioconda

RUN conda install --quiet --yes conda-forge::biopython \
    conda-forge::numpy \
    conda-forge::markdown \
    conda-forge::pymdown-extensions \
    conda-forge::pygments \
    bioconda::fastqc \
    bioconda::multiqc \
    bioconda::ivar \
    bioconda::bowtie2 \
    bioconda::pangolin \
    bioconda::samtools \
    bioconda::hisat2 \
    bioconda::spades=3.15.2 \
    bioconda::clark \
    bioconda::krona \
    bioconda::snpeff=4.5covid19 \
    bioconda::mafft \
    bioconda::iqtree && \
    conda clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Add conda installation dir to PATH (instead of doing 'conda activate')
# ENV PATH /opt/conda/envs/aws-env/bin:$PATH
# ENV PYTHONPATH /opt/conda/envs/aws-env/lib/python3.8/site-packages

USER root
RUN mkdir -p /opt/shared/DATA
WORKDIR /opt/shared/DATA
RUN apt-get install -y git
RUN git clone https://github.com/Intensive-School-Virology-Unipv/metaviromics_class.git
RUN git clone https://github.com/Intensive-School-Virology-Unipv/metaviromics_data.git
RUN git clone https://github.com/Intensive-School-Virology-Unipv/new_variants_class.git
RUN git clone https://github.com/Intensive-School-Virology-Unipv/new_variants_data.git
RUN git clone https://github.com/Intensive-School-Virology-Unipv/variant_calling_class.git
RUN git clone https://github.com/Intensive-School-Virology-Unipv/variant_calling_data.git
RUN chown -R jovyan:users /opt/shared/DATA
USER jovyan