#!/bin/sh -e

set -e

# Add the FTP_USER, change his password and declare him as the owner of his home folder and all subfolders
addgroup -g 433 -S ${FTP_USER}
adduser -u 431 -D -G ${FTP_USER} -h /home/vsftpd/${FTP_USER} -s /bin/false ${FTP_USER}
echo "${FTP_USER}:${FTP_PASS}" | /usr/sbin/chpasswd
chown -R ${FTP_USER}:${FTP_USER} /home/vsftpd/

# Building the configuration file
VSFTPD_CONF=/etc/vsftpd/vsftpd.conf
more /etc/vsftpd/vsftpd-example.conf > $VSFTPD_CONF

# Update the vsftpd.conf according to env variables
echo "Update the vsftpd.conf according to env variables"
echo "pasv_enable=${PASV_ENABLE}" >> $VSFTPD_CONF
echo "pasv_addr_resolve=${PASV_ADDR_RESOLVE}" >> $VSFTPD_CONF
echo "pasv_address=${PASV_ADDRESS}" >> $VSFTPD_CONF
echo "pasv_min_port=${PASV_MIN_PORT}" >> $VSFTPD_CONF
echo "pasv_max_port=${PASV_MAX_PORT}" >> $VSFTPD_CONF
echo "syslog_enable=${SYSLOG_ENABLE}" >> $VSFTPD_CONF
echo "local_root=${LOCAL_ROOT}" >> $VSFTPD_CONF
echo "rsa_cert_file=${LETSENCRYPT_CONF_PREFIX}/live/${DOMAIN_NAME}/fullchain.pem" >> $VSFTPD_CONF
echo "rsa_private_key_file=${LETSENCRYPT_CONF_PREFIX}/live/${DOMAIN_NAME}/privkey.pem" >> $VSFTPD_CONF
echo "ftpd_banner=Welcome to ${DOMAIN_NAME} FTP service." >> $VSFTPD_CONF
echo "" >> $VSFTPD_CONF

# Run the vsftpd server
echo "Running vsftpd"
/usr/sbin/vsftpd $VSFTPD_CONF
