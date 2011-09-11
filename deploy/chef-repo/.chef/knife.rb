current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "iamhukai"
client_key               "#{current_dir}/iamhukai.pem"
validation_client_name   "yaoji-validator"
validation_key           "#{current_dir}/yaoji-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/yaoji"
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]
