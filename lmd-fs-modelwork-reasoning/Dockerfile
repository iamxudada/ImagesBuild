FROM quay.io/supiedt/npu-driver:C8.R3.A1

LABEL maintainer="xulinchun xulinchun0806@outlook.com" \
      org.opencontainers.image.authors="xulinchun xulinchun0806@outlook.com" \
      org.opencontainers.image.base.name="ubuntu:20.04" \
      org.opencontainers.image.created="2024-08-06T00:00:00Z" \
      org.opencontainers.image.description="LMD FS MODELWORK REASONING" \
      org.opencontainers.image.documentation="" \
      org.opencontainers.image.licenses="GPLv2.1" \
      org.opencontainers.image.ref.name="lmd-fs-modelwork-reasoning" \
      org.opencontainers.image.source="" \
      org.opencontainers.image.title="lmd-fs-modelwork-reasoning" \
      org.opencontainers.image.vendor="xulinchun" \
      org.opencontainers.image.version="v1"

ARG PIP_INDEX=https://pypi.org/simple
ARG TORCH_INDEX=https://download.pytorch.org/whl/cpu

RUN pip3 config set global.index-url "$PIP_INDEX" \
    && pip3 config set global.extra-index-url "$TORCH_INDEX" \
    && pip3 install --no-cache-dir --upgrade --quiet --default-timeout=1000 pip setuptools wheel \
    && pip3 install --no-cache-dir --quiet --default-timeout=1000 -e ".[model_worker]" \
    && pip3 cache purge && rm -rf /tmp/* /root/.cache/pip \
    && chmod +x /usr/bin/start-modelwork