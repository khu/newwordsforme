name "app-prod-server"
description "Use this role along with runa-base and an environment role to install a mysql instance"
run_list "xfs", "keepin", "keepin", "mysql::client", "mysql::server", "mysql::server_ec2"

override_attributes({
  "runa"  => {
    "aws_access_key" => "AKIAJ5VVYWZE4W762U2Q",
    "aws_secret_access_key" => "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",
    "device"  => "/dev/sdh",
    "availability_zone" => "ap-southeast-1a",
  },
  "mysql" => {
    "server_root_password" => "root",
    "ebs_vol_dev" => "/dev/sdh",
    "ebs_vol_size" => 500
  }
})
