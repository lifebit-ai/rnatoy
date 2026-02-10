FROM continuumio/miniconda3:v25.11.1
LABEL name="quay.io/lifebitaiorg/rnatoy" \
      description="A docker container for rnatoy pipeline" \
      maintainer="David Pineyro <david.pineyro@lifebit.ai>"

RUN conda config --add channels defaults && \
    conda config --add channels bioconda && \
    conda config --add channels conda-forge

COPY environment.yml /
ARG ENV_NAME="rnatoy"
RUN conda env create -f environment.yml -n ${ENV_NAME} && \
    conda clean -a

# Add conda installation dir to PATH
ENV PATH /opt/conda/envs/${ENV_NAME}/bin:$PATH

# Dump the details of the installed packages to a file for posterity
RUN conda env export --name ${ENV_NAME} > ${ENV_NAME}_exported.yml

CMD ["/bin/bash"]

ENTRYPOINT [""]
