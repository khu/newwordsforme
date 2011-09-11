#!/bin/sh
#the previous line indedicates which intepretor should be used to intepret following scrip
# this script is running on a go agent
# jobs:  
#   1.copy artifcats to target node
#   2.copy deploy script to targe node
#   3.run deploy script on target node    

#copy release to target node
scp  /tmp/keepin.tar.gz $target_username@$target_ip:/tmp/

#copy deploy script to targe node
scp  ./deploy_script $target_username@$target_ip:$target_deploy_path

#deploy release
ssh root@10.29.2.11 "source /etc/profile && cd $target_deploy_path && source deploy_script && deploy keepin.tar.gz $target_deploy_path $target_app_name"