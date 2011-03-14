current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                'vagrant'
client_key               "#{current_dir}/vagrant.pem"
validation_client_name   'chef-validator'
validation_key           "#{current_dir}/validation.pem"
chef_server_url          'http://33.33.33.10:4000'
cache_type               'BasicFile'
cache_options( :path => "#{current_dir}/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks", "#{current_dir}/../site-cookbooks"]
