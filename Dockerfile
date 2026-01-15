FROM --platform=$TARGETPLATFORM ubuntu:noble

ARG TARGETARCH
# ZenithProxy uses the name "aarch64" instead of docker's "arm64"
ENV ZENITH_ARCH_ID=${TARGETARCH/arm64/aarch64}

RUN apt-get update \
    && apt-get install -y wget unzip \
    && mkdir -p /usr/share/zenithproxy \
    && cd /usr/share/zenithproxy \
    && wget "https://github.com/rfresh2/ZenithProxy/releases/download/launcher-v3/ZenithProxy-launcher-linux-$ZENITH_ARCH_ID.zip" \
    && unzip "ZenithProxy-launcher-linux-$ZENITH_ARCH_ID.zip" \
    && rm "ZenithProxy-launcher-linux-$ZENITH_ARCH_ID.zip" \
    && chmod +x /usr/share/zenithproxy/launch

RUN mkdir -p /defaults /opt/ZenithProxy

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 25565
WORKDIR /opt/ZenithProxy
VOLUME /opt/ZenithProxy
ENTRYPOINT ["/entrypoint.sh"]
