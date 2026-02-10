FROM ubuntu:20.04
LABEL name="quay.io/lifebitaiorg/rnatoy" \
      description="A docker container for rnatoy pipeline" \
      maintainer="David Pineyro <david.pineyro@lifebit.ai>"

# Set environment variables to prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
# Add tools to PATH so they can be called directly
ENV PATH=$PATH:/opt/bowtie2:/opt/tophat:/opt/cufflinks

# 1. Install System Dependencies
# 'procps' is required for Nextflow metrics
# 'python2' is required for TopHat2
# 'libncurses5' is required for older bio-binaries (TopHat/Cufflinks)
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    unzip \
    tar \
    bzip2 \
    ca-certificates \
    build-essential \
    zlib1g-dev \
    libncurses5-dev \
    libncurses5 \
    samtools \
    python2 \
    procps \
    && rm -rf /var/lib/apt/lists/*

# 2. Fix Python environment
# TopHat expects 'python' to be Python 2
RUN ln -s /usr/bin/python2 /usr/bin/python

# 3. Install Bowtie2 (v2.2.7)
WORKDIR /opt
RUN wget -q -O bowtie.zip https://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.2.7/bowtie2-2.2.7-linux-x86_64.zip/download && \
    unzip bowtie.zip -d /opt/ && \
    mv /opt/bowtie2-2.2.7 /opt/bowtie2 && \
    rm bowtie.zip

# 4. Install Cufflinks (v2.2.1)
RUN wget -q http://cole-trapnell-lab.github.io/cufflinks/assets/downloads/cufflinks-2.2.1.Linux_x86_64.tar.gz -O- \
    | tar xz -C /opt/ && \
    mv /opt/cufflinks-2.2.1.Linux_x86_64 /opt/cufflinks

# 5. Install TopHat2 (v2.1.0)
RUN wget -q https://ccb.jhu.edu/software/tophat/downloads/tophat-2.1.0.Linux_x86_64.tar.gz -O- \
    | tar xz -C /opt/ && \
    mv /opt/tophat-2.1.0.Linux_x86_64 /opt/tophat

WORKDIR /data
