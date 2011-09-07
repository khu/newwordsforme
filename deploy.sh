#!/bin/sh
#the previous line indedicates which intepretor should be used to intepret following scrip
# this script is running on a go agent
# jobs:  
#   1.copy artifcats to target node
#   2.copy deploy script to targe node
#   3.run deploy script on target node    

#copy release to target node
scp  /tmp/keepin.tar.gz root@10.29.2.11:/tmp/
#copy deploy script to targe node
scp  ~/projects/keepin/deploy_script root@10.29.2.11:/home/ubuntu

#deploy release
ssh root@10.29.2.11  /bin/bash<<\EOF &
	source /etc/profile
	cd /home/ubuntu/
	source deploy_script
	deploy keepin.tar.gz /home/ubuntu/ keepin
EOF
