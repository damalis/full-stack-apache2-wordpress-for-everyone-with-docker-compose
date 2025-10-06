#!/bin/sh
set -e

if [ -z $1 ]; then
	echo "DOMAIN environment variable is not set"
	exit 1;
fi

if [ ! -f $2/ssl-dhparam.pem 2>/dev/null ]; then
	openssl dhparam -out $2/ssl-dhparam.pem 2048
fi

use_lets_encrypt_certificates() {
	echo "switching webserver to use Let's Encrypt certificate for $1"
	sed 's/#LoadModule/LoadModule/' $3/extra/httpd-vhosts.conf > $3/extra/httpd-vhosts.conf.bak
	cp $3/extra/httpd-ssl.conf.template $3/extra/httpd-ssl.conf
	sed 's/example.com/'$1'/g' $3/extra/httpd-ssl.conf > $3/extra/httpd-ssl.conf.bak
	sed '/^#\(.*\)httpd-ssl\.conf/ s/^#//' $3/httpd.conf > $3/httpd.conf.bak
}

reload_webserver() {
	cp $1/extra/httpd-vhosts.conf.bak $1/extra/httpd-vhosts.conf
	cp $1/extra/httpd-ssl.conf.bak $1/extra/httpd-ssl.conf
	cp $1/httpd.conf.bak $1/httpd.conf
	rm $1/extra/httpd-ssl.conf.bak
	rm $1/extra/httpd-vhosts.conf.bak
	rm $1/httpd.conf.bak
	echo "Starting webserver apache2 service"
	httpd -t
}

wait_for_lets_encrypt() {
	if [ -d "$2/live/$1" ]; then
		break 
	else
		until [ -d "$2/live/$1" ]; do
			echo "waiting for Let's Encrypt certificates for $1"
			sleep 5s & wait ${!}
			if [ -d "$2/live/$1" ]; then break; fi
		done
	fi;
	use_lets_encrypt_certificates "$1" "$2" "$3"
	reload_webserver "$3"
}

if [ ! -d "$2/live/$1" ]; then
	wait_for_lets_encrypt "$1" "$2" "$3" &
else
	use_lets_encrypt_certificates "$1" "$2" "$3"
	reload_webserver "$3"
fi

httpd-foreground
