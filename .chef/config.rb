current_dir = File.dirname(__FILE__)

chef_server_url        'https://api.opscode.com/organizations/joshtest'
node_name              'jtimberman'
client_key             "#{ENV['HOME']}/.chef/#{ENV['USER']}.pem"

cookbook_path [
  "#{current_dir}/../cookbooks",
  "#{current_dir}/../vendor/cookbooks"
]

cookbook_copyright 'Joshua Timberman'
cookbook_license   'apachev2'
cookbook_email     'cookbooks@housepub.org'
