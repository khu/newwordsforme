# aws_ebs_volume "mysql_data_volume" do
#   provider "aws_ebs_volume"
#   aws_access_key node[:runa][:aws_access_key]
#   aws_secret_access_key node[:runa][:aws_secret_access_key]
#   size 10
#   availability_zone node[:runa][:availability_zone]
#   device node[:runa][:device]
#   action [:create, :attach]
#   not_if "ls /dev/" + node[:runa][:device]
#   Chef::Log.info("successfully created the volumn")
# end
bash "create the folder to mount" do
  code "mkdir /var/lib/mysql"
  not_if "ls /var/lib/mysql"
end

mount "/var/lib/mysql" do
  device "/dev/sdh"
  fstype "tmpfs"
  action [ :enable, :mount ]
  # Do not execute if its already mounted
  not_if "cat /proc/mounts | grep /var/lib/mysql"
end

bash "Changing the owner:group for Mysql data and log folders" do
  code <<-EOC
    user = "ubuntu"
    useradd mysql -U
    chown -R mysql:mysql /var/lib/mysql
    chown -R mysql:mysql /var/local/log
  EOC
  not_if "id mysql"
end

link node[:mysql][:ec2_path] do
  to node[:mysql][:data_dir]
  not_if "test -e  #{node[:mysql][:ec2_path]}"
end


