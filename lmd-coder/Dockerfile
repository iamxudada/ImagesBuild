FROM quay.io/supiedt/npu-driver:C8.R3.A1

LABEL maintainer="xulinchun xulinchun0806@outlook.com"
LABEL org.opencontainers.image.authors="xulinchun xulinchun0806@outlook.com" \
      org.opencontainers.image.base.name="ubuntu 22.04" \
      org.opencontainers.image.npu_name="Ascend 910" \
      org.opencontainers.image.npu_driver_version="23.0.0" \
      org.opencontainers.image.npu_framework_version="7.1.0.3.220" \
      org.opencontainers.image.cann_version="8.0.RC3.Alpha1" \
      org.opencontainers.image.created="2024-08-18T00:00:00Z" \
      org.opencontainers.image.description="LMD CODER" \
      org.opencontainers.image.documentation="" \
      org.opencontainers.image.licenses="GPLv2.1" \
      org.opencontainers.image.ref.name="lmd-coder" \
      org.opencontainers.image.source="" \
      org.opencontainers.image.title="lmd-coder" \ 
      org.opencontainers.image.vendor="xulinchun" \
      org.opencontainers.image.version="v1"

ADD JetBrainsMono.zip /usr/share/fonts/JetBrainsMono

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && apt-get -qq update \
    && apt-get -qq install -y curl vim locales fontconfig git \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get -qq install -y nodejs \
    && locale-gen en_US.UTF-8 \
    && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
    && bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" \
    && dpkg -i code-server_4.91.1.deb \
    && fc-cache -fv \
    && apt-get clean all && apt-get autoremove -y \
    && rm -rf /tmp/* /root/.cache/pip
