cd ../keepin-release
tar --exclude=.git -cvf  keepin.tar  keepin/
cp  keepin.tar /etc/puppet/modules/keepin-deployment/files/keepin.tar