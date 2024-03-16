FROM alpine:3.19

RUN set -ex && apk update && apk --update --no-cache add vsftpd

ENV FTP_USER ${FTP_USER:-user}
ENV FTP_PASS ${FTP_PASS:-pass}
ENV PASV_ADDR_RESOLVE ${PASV_ADDR_RESOLVE:-NO}
ENV PASV_ENABLE ${PASV_ENABLE:-YES}
ENV PASV_MIN_PORT ${PASV_MIN_PORT:-21100}
ENV PASV_MAX_PORT ${PASV_MAX_PORT:-21110}
ENV SYSLOG_ENABLE ${SYSLOG_ENABLE:-NO}
ENV LOCAL_ROOT ${LOCAL_ROOT:-}
ENV TZ ${TZ}

RUN mkdir -p /home/vsftpd/${FTP_USER}
RUN chown -R ftp:ftp /home/vsftpd/
RUN mkdir -p /var/log/vsftpd

COPY vsftpd.conf /etc/vsftpd/vsftpd.conf

COPY entrypoint.sh /usr/sbin/entrypoint.sh
RUN chmod +x /usr/sbin/entrypoint.sh

EXPOSE 22 990 21100-21110

WORKDIR /var/www/html

ENTRYPOINT ["entrypoint.sh"]
