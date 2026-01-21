# Alpine version only supports `java` release channel
# but the container may be a bit smaller
# so if you need plugins, this may be an option to test
# but otherwise, i recommend using the default ubuntu dockerfile on the `linux` release channel

FROM --platform=$TARGETPLATFORM eclipse-temurin:25.0.1_8-jre-alpine-3.23

ARG TARGETARCH
# ZenithProxy uses the name "aarch64" instead of docker's "arm64"
ENV ZENITH_ARCH_ID=${TARGETARCH/arm64/aarch64}

RUN apk add bash wget unzip \
    && mkdir -p /usr/share/zenithproxy \
    && cd /usr/share/zenithproxy \
    && wget "https://github.com/rfresh2/ZenithProxy/releases/download/launcher-v3/ZenithProxy-launcher-alpine-$ZENITH_ARCH_ID.zip" \
    && unzip "ZenithProxy-launcher-alpine-$ZENITH_ARCH_ID.zip" \
    && rm "ZenithProxy-launcher-alpine-$ZENITH_ARCH_ID.zip"


RUN mkdir -p /defaults /opt/ZenithProxy

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 25565
WORKDIR /opt/ZenithProxy
VOLUME /opt/ZenithProxy
ENTRYPOINT ["/entrypoint.sh"]