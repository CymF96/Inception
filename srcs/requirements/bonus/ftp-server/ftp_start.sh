#!bin/bash

if [ ! -f /etc/vsftpd/vsftpd.conf ]; then

	mv /tmp/vsftpd.conf /etc/vsftpd/vsftpd.conf

	adduser --gecos "" --disabled-password $TP_USER
	echo "$FTP_USER":"$FTP_USER_PWD" | chpasswd
	mkdir -p $FTP_DIR
	chown -R $FTP_USER $FTP_DIR
	echo $FTP_USER | tee -a /ect/vsftpd/vsftpd.userlist

	echo "FTP successfully setup!"
fi

echo "FTP already started"
exec "$@"