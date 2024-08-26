FROM quay.io/supiedt/npu-driver:C8.R3.A1

LABEL maintainer="xulinchun xulinchun0806@outlook.com" \
      org.opencontainers.image.authors="xulinchun xulinchun0806@outlook.com" \
      org.opencontainers.image.base.name="ubuntu:20.04" \
      org.opencontainers.image.created="2024-08-06T00:00:00Z" \
      org.opencontainers.image.description="LMD TRAIN LLAMA_FACTORY" \
      org.opencontainers.image.documentation="" \
      org.opencontainers.image.licenses="GPLv2.1" \
      org.opencontainers.image.ref.name="lmd-train-llama_factory" \
      org.opencontainers.image.source="" \
      org.opencontainers.image.title="lmd-train-llama_factory" \
      org.opencontainers.image.vendor="xulinchun" \
      org.opencontainers.image.version="v1"

COPY lmd-train/entrypoint.sh /workspace
COPY lmd-train/workspace/src lmd-train/workspace/pyproject.toml \
    lmd-train/workspace/setup.py lmd-train/workspace/requirements.txt lmd-train/workspace/LICENSE lmd-train/workspace/README.md \
    /workspace/

RUN pip3 install --no-cache-dir --upgrade --quiet --default-timeout=1000 pip setuptools wheel \
    && pip3 install --no-cache-dir --quiet --default-timeout=1000 -e ".[torch-npu,deepspeed,qwen,modelscope]" \
    && pip3 cache purge && rm -rf /tmp/* /root/.cache/* \
    && chmod +x /workspace/entrypoint.sh