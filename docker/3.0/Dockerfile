FROM alpine:3.19

CMD ["/bin/sh"]

LABEL maintainer="damalis"

RUN apk update && apk upgrade \
	&& apk --update --no-cache add tzdata shadow build-base linux-pam-dev unzip vsftpd openssl \
	&& rm -rf /tmp/* /var/cache/apk/*

# ensure www-data user exists
RUN set -x ; \
	addgroup -g 82 -S www-data ; \
	adduser -u 82 -D -S -G www-data www-data && exit 0 ; exit 1
# 82 is the standard uid/gid for "www-data" in Alpine
# https://git.alpinelinux.org/cgit/aports/tree/main/apache2/apache2.pre-install?h=v3.14.0
# https://git.alpinelinux.org/cgit/aports/tree/main/lighttpd/lighttpd.pre-install?h=v3.14.0
# https://git.alpinelinux.org/cgit/aports/tree/main/nginx/nginx.pre-install?h=v3.14.0

ENV LETSENCRYPT_CONF_PREFIX ${LETSENCRYPT_CONF_PREFIX:-/etc/letsencrypt}
ENV FTP_USER ${FTP_USER:-user}
ENV FTP_PASS ${FTP_PASS:-pass}
ENV PASV_ENABLE ${PASV_ENABLE:-YES}
ENV PASV_ADDRESS ${PASV_ADDRESS:-127.0.0.1}
ENV PASV_ADDR_RESOLVE ${PASV_ADDR_RESOLVE:-NO}
ENV PASV_MIN_PORT ${PASV_MIN_PORT:-21100}
ENV PASV_MAX_PORT ${PASV_MAX_PORT:-21110}
ENV SYSLOG_ENABLE ${SYSLOG_ENABLE:-NO}
ENV LOCAL_ROOT ${LOCAL_ROOT:-/var/www/html}
ENV TZ ${TZ:-America/Los_Angeles}

RUN mkdir -p /var/log/vsftpd

COPY vsftpd-example.conf /etc/vsftpd/
COPY vsftpd_virtual /etc/pam.d/
COPY libpam-pwdfile.zip /tmp/

RUN unzip -q /tmp/libpam-pwdfile.zip -d /tmp/ \
    && cd /tmp/libpam-pwdfile \
    && make install \
    && cd .. \
    && rm -rf /tmp/libpam-pwdfile \
    && rm -f /tmp/libpam-pwdfile.zip

COPY entrypoint.sh /usr/sbin/
RUN chmod +x /usr/sbin/entrypoint.sh

EXPOSE 20-21 ${PASV_MIN_PORT}-${PASV_MAX_PORT}

WORKDIR ${LOCAL_ROOT}

ENTRYPOINT ["/usr/sbin/entrypoint.sh"]
