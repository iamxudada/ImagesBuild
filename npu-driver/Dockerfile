FROM ubuntu:22.04

LABEL maintainer="xulinchun xulinchun0806@outlook.com" \
      org.opencontainers.image.authors="xulinchun xulinchun0806@outlook.com" \
      org.opencontainers.image.base.name="ubuntu:20.04" \
      org.opencontainers.image.created="2024-08-06T00:00:00Z" \
      org.opencontainers.image.description="ASCEND DRIVER CANN 8.0.0.RC3.ALPHA001" \
      org.opencontainers.image.documentation="" \
      org.opencontainers.image.licenses="GPLv2.1" \
      org.opencontainers.image.ref.name="npu-driver" \
      org.opencontainers.image.source="" \
      org.opencontainers.image.title="npu-driver" \
      org.opencontainers.image.vendor="xulinchun" \
      org.opencontainers.image.version="C8.R3.A1"

WORKDIR /workspace

ARG PIP_INDEX=https://pypi.org/simple
ARG TORCH_INDEX=https://download.pytorch.org/whl/cpu

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && apt-get -qq update \
    && apt-get -qq install -y \
    ca-certificates gcc make unzip wget \
    build-essential libncurses5-dev libgdbm-dev python3.10 python3-dev python3-pip  \
    && ln -snf `which python3.10` /usr/bin/python && ln -snf `which pip3` /usr/bin/pip \
    && useradd -d /home/HwHiAiUser -u 1000 -m -s /usr/sbin/nologin HwHiAiUser \
    && wget -q https://ascend-repo.obs.cn-east-2.myhuaweicloud.com/Milan-ASL/Milan-ASL%20V100R001C19SPC802/Ascend-cann-toolkit_8.0.RC3.alpha001_linux-$(uname -m).run -O /tmp/cann-toolkit.run \
    && wget -q https://ascend-repo.obs.cn-east-2.myhuaweicloud.com/Milan-ASL/Milan-ASL%20V100R001C19SPC802/Ascend-cann-kernels-910_8.0.RC3.alpha001_linux.run -O /tmp/cann-kernels.run \
    && chmod +x /tmp/*.run \
    && echo y | bash /tmp/cann-toolkit.run --quiet --full --install-for-all \
    && echo y | bash /tmp/cann-kernels.run --quiet --install --install-for-all \
    && pip3 config set global.index-url "$PIP_INDEX" \
    && pip3 config set global.extra-index-url "$TORCH_INDEX" \
    && pip3 install --no-cache-dir --quiet --default-timeout=1000 \
    /usr/local/Ascend/ascend-toolkit/latest/fwkacllib/lib64/te-*.whl \
    /usr/local/Ascend/ascend-toolkit/latest/fwkacllib/lib64/hccl-*.whl \
    /usr/local/Ascend/ascend-toolkit/latest/tools/hccl_parser-*.whl \
    && apt-get clean all && apt-get autoremove -y \
    && pip3 cache purge && rm -rf /tmp/* /root/.cache/pip

ENV PATH=/usr/local/Ascend/ascend-toolkit/latest/bin:/usr/local/Ascend/ascend-toolkit/latest/compiler/ccec_compiler/bin:$PATH \
    LD_LIBRARY_PATH=/usr/local/Ascend/driver/lib64/common:/usr/local/Ascend/driver/lib64/driver:/usr/local/Ascend/driver/lib64:/usr/local/Ascend/ascend-toolkit/latest/tools/aml/lib64:/usr/local/Ascend/ascend-toolkit/latest/tools/aml/lib64/plugin:/usr/local/Ascend/ascend-toolkit/latest/lib64:/usr/local/Ascend/ascend-toolkit/latest/lib64/plugin/opskernel:/usr/local/Ascend/ascend-toolkit/latest/lib64/plugin/nnengine:/usr/local/Ascend/ascend-toolkit/latest/opp/built-in/op_impl/ai_core/tbe/op_tiling/lib/linux/aarch64:/usr/local/Ascend/driver/lib64:/usr/local/Ascend/driver/lib64/common:/usr/local/Ascend/driver/lib64/driver:/usr/local/Ascend/nnrt/latest/lib64:/usr/local/Ascend/driver/lib64:/usr/local/Ascend/driver/lib64/common:/usr/local/Ascend/driver/lib64/driver:$LD_LIBRARY_PATH \
    PYTHONPATH=/usr/local/Ascend/ascend-toolkit/latest/python/site-packages:/usr/local/Ascend/ascend-toolkit/latest/opp/op_impl/built-in/ai_core/tbe:$PYTHONPATH \
    ASCEND_AICPU_PATH=/usr/local/Ascend/ascend-toolkit/latest \
    ASCEND_OPP_PATH=/usr/local/Ascend/ascend-toolkit/latest/opp \
    TOOLCHAIN_HOME=/usr/local/Ascend/ascend-toolkit/latest/toolkit \
    ASCEND_AUTOML_PATH=/usr/local/Ascend/ascend-toolkit/latest/tools