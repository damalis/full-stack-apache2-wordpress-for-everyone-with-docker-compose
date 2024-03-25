#!/bin/sh -e

set -e

# to create and store user names and passwords is to use 
# the Openssl could be used to produce a MD5 based BSD password with algorithm 1:
echo "${FTP_USER}:$(openssl passwd -1 ${FTP_PASS})" > /etc/vsftpd/.passwd

# Set passive address and resolve parameters:
if [ "${PASV_ADDR_RESOLVE}" = "NO" ]; then
   PASV_ADDRESS=$(/sbin/ip route|awk '/src/ { print $7 }')
fi

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
echo "ftpd_banner=Welcome to ${PASV_ADDRESS} FTP service." >> $VSFTPD_CONF
echo "" >> $VSFTPD_CONF

# Run the vsftpd server
echo "Running vsftpd"
/usr/sbin/vsftpd $VSFTPD_CONF

# nc -zv $(/sbin/ip route|awk '/src/ { print $7 }')
