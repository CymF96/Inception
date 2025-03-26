#!bin/bash

if [ ! -f /etc/vsftpd/vsftpd.conf ]; then

	mkdir /etc/vsftpd
	mv /tmp/vsftpd.conf /etc/vsftpd/vsftpd.conf

	adduser --gecos "" --disabled-password $FTP_USER
	echo "$FTP_USER":"$FTP_USER_PWD" | chpasswd
	mkdir -p $FTP_DIR
	echo "ftp testing file" | tee $FTP_DIR/test.txt
	chown -R $FTP_USER $FTP_DIR
	echo $FTP_USER | tee -a /ect/vsftpd/vsftpd.userlist

	echo "FTP successfully setup!"
fi

echo "FTP already started"
exec "$@"