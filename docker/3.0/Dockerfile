FROM alpine:3.19

CMD ["/bin/sh"]

LABEL maintainer="damalis"

RUN apk update && apk upgrade && apk --update --no-cache add vsftpd tzdata

ENV LETSENCRYPT_CONF_PREFIX ${LETSENCRYPT_CONF_PREFIX:-/etc/letsencrypt}
ENV FTP_USER ${FTP_USER:-user}
ENV FTP_PASS ${FTP_PASS:-pass}
ENV PASV_ADDR_RESOLVE ${PASV_ADDR_RESOLVE:-NO}
ENV PASV_ENABLE ${PASV_ENABLE:-YES}
ENV PASV_MIN_PORT ${PASV_MIN_PORT:-21100}
ENV PASV_MAX_PORT ${PASV_MAX_PORT:-21110}
ENV SYSLOG_ENABLE ${SYSLOG_ENABLE:-NO}
ENV LOCAL_ROOT ${LOCAL_ROOT:-}
ENV TZ ${TZ}

RUN mkdir -p /home/vsftpd/
RUN chown -R ftp:ftp /home/vsftpd/
RUN mkdir -p /var/log/vsftpd/

COPY vsftpd.conf /etc/vsftpd/

COPY entrypoint.sh /usr/sbin/
RUN chmod +x /usr/sbin/entrypoint.sh

EXPOSE 20-21 ${PASV_MIN_PORT}-${PASV_MAX_PORT}

WORKDIR ${LOCAL_ROOT}

ENTRYPOINT ["entrypoint.sh"]
