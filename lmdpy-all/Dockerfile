FROM quay.io/supiedt/npu-driver:C8.R3.A1

LABEL maintainer="xulinchun xulinchun0806@outlook.com"
LABEL org.opencontainers.image.authors="xulinchun xulinchun0806@outlook.com" \
      org.opencontainers.image.base.name="ubuntu 22.04" \
      org.opencontainers.image.npu_name="Ascend 910" \
      org.opencontainers.image.npu_driver_version="23.0.0" \
      org.opencontainers.image.npu_framework_version="7.1.0.3.220" \
      org.opencontainers.image.cann_version="8.0.RC3.Alpha1" \
      org.opencontainers.image.created="2024-08-18T00:00:00Z" \
      org.opencontainers.image.description="LMD PY ALL" \
      org.opencontainers.image.documentation="" \
      org.opencontainers.image.licenses="GPLv2.1" \
      org.opencontainers.image.ref.name="lmd-py-all" \
      org.opencontainers.image.source="" \
      org.opencontainers.image.title="lmd-py-all" \ 
      org.opencontainers.image.vendor="xulinchun" \
      org.opencontainers.image.version="v1"

COPY lmdpy-all/start-py /usr/bin/
COPY lmdpy-all/requirements /workspace
WORKDIR /workspace

ARG PIP_INDEX=https://pypi.org/simple
ARG TORCH_INDEX=https://download.pytorch.org/whl/cpu

RUN pip3 config set global.index-url "$PIP_INDEX" \
    && pip3 config set global.extra-index-url "$TORCH_INDEX" \
    && wget -q https://mirror.nju.edu.cn/anaconda/miniconda/Miniconda3-py310_24.5.0-0-Linux-$(uname -m).sh \
    && bash Miniconda3-py310_24.5.0-0-Linux-$(uname -m).sh -u -b -p /miniconda \
    && rm -f Miniconda3-py310_24.5.0-0-Linux-$(uname -m).sh \
    && /miniconda/bin/conda init bash \
    && /miniconda/bin/conda create -n main python=3.10 -y \
    && /miniconda/bin/conda create -n embedding python=3.10 -y \
    && /miniconda/bin/conda create -n rerank python=3.10 -y \
    && /miniconda/bin/conda create -n ngram python=3.10 -y
