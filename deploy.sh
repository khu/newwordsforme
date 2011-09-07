ssh root@10.29.2.11  /bin/bash<<\EOF &
	source /etc/profile
	cd /home/ubuntu/ 
	source deploy_script
	fetch_release reaapi 10.29.2.6 /tmp/app-release keepin.tar
	deploy keepin.tar /home/ubuntu/ keepin &
EOF