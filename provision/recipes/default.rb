context = ChefDK::ProvisioningData.context
require 'chef/provisioning/vagrant_driver'
with_driver 'vagrant'

vagrant_box 'opscode-fedora-21' do
  url 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_fedora-21_chef-provisionerless.box'
end

options = {
  vagrant_options: {
    'vm.box' => 'opscode-fedora-21'
  },
  convergence_options: context.convergence_options,
}

machine context.node_name do
  machine_options options
  action context.action
  converge true
end
