FROM jupyter/datascience-notebook

# Install the conda environment
COPY docker_env.yml /
RUN conda env create -f /docker_env.yml && conda clean -a

# Add conda installation dir to PATH (instead of doing 'conda activate')
ENV PATH /opt/conda/envs/aws-env/bin:$PATH
ENV PYTHONPATH /opt/conda/envs/aws-env/lib/python3.8/site-packages

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