context = ChefDK::ProvisioningData.context
valid_groups = %w(testing staging development ec2 vmware ssh)

case context.policy_group
when 'testing', 'staging', 'development'

  # require 'chef/provisioning/vagrant_driver'
  # with_driver 'vagrant'

  # options = {
  #   vagrant_options: {
  #     'vm.box' => 'opscode-fedora-21',
  #   },
  #   vagrant_config: "config.vm.synced_folder '.', '/vagrant', disabled: true",
  #   convergence_options: context.convergence_options,
  # }

  # vagrant_box 'opscode-fedora-21' do
  #   url 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_fedora-21_chef-provisionerless.box'
  # end

when 'ec2'

  require 'chef/provisioning/aws'
  with_driver 'aws::us-west-2'

  options =   {
    username: 'fedora',
    bootstrap_options: {
      image_id: 'ami-3980aa09',
      key_name: 'jtimberman',
      instance_type: 'm3.medium'
    },
    convergence_options: context.convergence_options,
  }

when 'vmware', 'ssh'

  require 'chef/provisioning/ssh_driver'
  with_driver 'ssh'

  options =   {
    transport_options: {
      username: 'root',
      host: '192.168.21.131',
      ssh_options: {
        use_agent: true
      }
    },
    convergence_options: context.convergence_options,
  }

when 'cask'
  require 'chef/provisioning/ssh_driver'
  with_drivr 'ssh'

  options = {
    transport_options: {
      username: 'root',
      host: '10.13.37.20',
      ssh_options: {
        use_agent: true
      }
    },
    convergence_options: context.convergence_options,
  }

when 'windows'
  require 'chef/provisioning/vagrant_driver'
  with_driver 'vagrant'

  options = {
    vagrant_options: {
                      'vm.box' => 'chef/windows-8.1-professional'
                     },
    vagrant_config: "config.vm.synced_folder '.', '/vagrant', disabled: true",
    convergence_options: context.convergence_options
  }
else
  raise "Invalid group, #{context.policy_group}. Valid groups are: #{valid_groups.join(' ')}"
end

machine context.node_name do
  machine_options options
  action context.action
  converge true
end
