FROM alpine:3.12 as prep

ENV BUILD_VERSION=4.34-9745-beta \
    SHA256_SUM=a2d7951f4fafcef96ab8341a948a8d09ca02030e4161c5e90a34882aa8b34224

RUN wget https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/archive/v${BUILD_VERSION}.tar.gz \
    && echo "${SHA256_SUM}  v${BUILD_VERSION}.tar.gz" | sha256sum -c \
    && mkdir -p /usr/local/src \
    && tar -x -C /usr/local/src/ -f v${BUILD_VERSION}.tar.gz \
    && rm v${BUILD_VERSION}.tar.gz

FROM alpine:3.12 as build

COPY --from=prep /usr/local/src /usr/local/src

ENV LANG=en_US.UTF-8

RUN apk add -U build-base ncurses-dev openssl-dev readline-dev zip zlib-dev \
    && cd /usr/local/src/SoftEtherVPN_Stable-* \
    && ./configure \
    && make \
    && make install \
    && touch /usr/vpnserver/vpn_server.config \
    && zip -r9 /artifacts.zip /usr/vpn* /usr/bin/vpn*

FROM alpine:3.12

COPY --from=build /artifacts.zip /

COPY entrypoint.sh /
COPY start.sh /
COPY server-setup.sh /
COPY client-setup.sh /

ENV LANG=en_US.UTF-8

RUN apk add -U --no-cache bash iptables openssl-dev \
    && chmod +x /entrypoint.sh /start.sh /server-setup.sh /client-setup.sh \
    && unzip -o /artifacts.zip -d / \
    && rm /artifacts.zip \
    && rm -rf /opt \
    && ln -s /usr/vpnserver /opt \
    && find /usr/bin/vpn* -type f ! -name vpnserver \
       -exec sh -c 'ln -s {} /opt/$(basename {})' \;

WORKDIR /

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 80:80/tcp 85:85/tcp 443:443/tcp 500:500/udp 992:992/tcp 4500:4500/udp 1701:1701/tcp 1194:1194/udp 5555:5555/tcp

CMD ["/start.sh"]