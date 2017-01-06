#!/bin/bash
if which whiptail >/dev/null; then
    echo exists
else
    echo does not exist
    yum install whiptail
fi
PCT=0
( 
while test $PCT != 100; 
do
PCT=`expr $PCT + 10`; 
echo $PCT; 
sleep 1; 
done; ) | whiptail --title "Bismillah Backup 1 server" --gauge "BACKUP untuk domain di server yang sama. Di tunggu sek hu. Loading baca BISMILLAH mugi berkah website. amin :)" 20 70 0
whiptail --title "Credit" --msgbox "Simple Install and backup code:  From Dev : Aji Pangestu :)" 10 60

web_lama=$(whiptail --title "domain web lama" --inputbox "masukan domain web lama: " 10 60 example.com 3>&1 1>&2 2>&3)
	 	exitstatus=$?
	   	if [ $exitstatus = 0 ]; then
		echo $web_lama
		else
			exit
		fi
web_baru=$(whiptail --title "domain web baru" --inputbox "masukan domain web baru: " 10 60 example.com 3>&1 1>&2 2>&3)
	 	exitstatus=$?
	   	if [ $exitstatus = 0 ]; then
		echo $web_baru
		else
			exit
		fi

	echo $web_baru/public_html/
	DIRECTORY=$web_baru/public_html/
	if [ ! -d "$DIRECTORY" ]; then
  	echo kosong
  	exit
	fi
	cd $web_baru/public_html/
	pwd
	echo '------------- Download Wordpress ----'
	wget https://wordpress.org/wordpress-4.6.1.zip
	unzip wordpress-4.6.1.zip
	cd wordpress
	mv * ../
	cd ..
	rm wordpress-4.6.1.zip
	rmdir wordpress
	dbname=$(whiptail --title "Nama Database Baru" --inputbox "masukan Nama Database web baru: " 10 60 db 3>&1 1>&2 2>&3)
		exitstatus=$?
	   	if [ $exitstatus = 0 ]; then
		echo $dbname
		else
			exit
		fi
	dbuser=$(whiptail --title "User Database" --inputbox "masukan User databse: " 10 60 user 3>&1 1>&2 2>&3)
		exitstatus=$?
	   	if [ $exitstatus = 0 ]; then
		echo $dbuser
		else
			exit
		fi
	dbpass=$(whiptail --title "Password Database" --inputbox "masukan Pasword Database " 10 60 pass 3>&1 1>&2 2>&3)
		exitstatus=$?
	   	if [ $exitstatus = 0 ]; then
	   		echo password
		else
			exit
		fi

	sed "s/database_name_here/$dbname/g" wp-config-sample.php > wp-config1.php
	rm wp-config-sample.php
	sed "s/username_here/$dbuser/g" wp-config1.php > wp-config2.php
	rm wp-config1.php
	sed "s/password_here/$dbpass/g" wp-config2.php > wp-config.php
	rm wp-config2.php
	chown -R admin:admin 
	whiptail --title "Wordpress Done" --msgbox "Selesai Install Wordpress" 10 60
	

	echo proses mv ke $web_lama/public_html/wp-content/ dan $web_baru/public_html/
	mv /home/admin/web/$web_lama/public_html/wp-content/uploads/ /home/admin/web/$web_baru/public_html/wp-content/
	rm -r -f /home/admin/web/$web_baru/public_html/wp-content/themes/
	rm -r -f /home/admin/web/$web_baru/public_html/wp-content/plugins/ 
	mv /home/admin/web/$web_lama/public_html/wp-content/themes/ /home/admin/web/$web_baru/public_html/wp-content/

	whiptail --title "PENTING" --msgbox "PENTING. Di Install dulu wordpressnya buka domain baru yang mau di backup install wordpressnya dlu baru lanjut OKE .. !!" 10 60

	dbname_lama=$(whiptail --title "Nama Database lama" --inputbox "masukan Nama Database Lama: " 10 60 db 3>&1 1>&2 2>&3)
	backupdb=$(whiptail --title "Nama backup sql lama" --inputbox "masukan Nama Backup sql lama: " 10 60 backup_$dbname_lama 3>&1 1>&2 2>&3)

	echo Proses backup database	mysqldump -u $dbuser -p --opt $dbname_lama > $backupdb	
	mysqldump -u $dbuser -p$dbpass --opt $dbname_lama > $backupdb


	echo Proses restore backup database	 $dbname  < $backupdb	
	mysql -u $dbuser -p$dbpass $dbname  < $backupdb

   echo mysql -u $dbuser -p$dbpass $dbname  -e "UPDATE wp_posts SET post_content = replace(post_content, '$web_lama', '$web_baru')"

   mysql -u $dbuser -p$dbpass $dbname  -e "UPDATE wp_posts SET 	guid = replace(	guid, '$web_lama', '$web_baru')"
   mysql -u $dbuser -p$dbpass $dbname  -e "UPDATE wp_options SET 	option_value = replace(	option_value, '$web_lama', '$web_baru')"

   chown -R admin:admin *

   whiptail --title "Alhamdulillah" --msgbox "Sampun Selesai hu. Alhamdulillah mugi lancar webpe" 10 60


	# echo Proses Move database ke server baru $n_database $username@$ipwebbaru:/home/
	






