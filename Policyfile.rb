# Policyfile.rb - Describe how you want Chef to build your system.
#
# For more information on the Policyfile feature, visit
# https://github.com/opscode/chef-dk/blob/master/POLICYFILE_README.md

# A name that describes what the system you're building with Chef does.
name 'home_server'

# Where to find external cookbooks:
default_source :community

run_list(
         'build-essential',
         'packages',
         'users',
         'sudo',
         'runit',
         'ntp',
         'openssh',
         'postfix',
         'chef-client-runit',
#         'housepub-datadog',
         'plexapp',
         'housepub-annoyances',
         'housepub-dnsmasq',
         'dnsmasq'
        )

cookbook 'packages', git: 'https://github.com/mattray/packages-cookbook', branch: 'multipackage'
cookbook 'users', path: '../housepub-chef-repo/cookbooks/users'
cookbook 'housepub-datadog', git: 'https://github.com/jtimberman/housepub-datadog.git', tag: '0.2.0'
cookbook 'housepub-annoyances', git: 'https://github.com/jtimberman/housepub-annoyances.git'
cookbook 'housepub-dnsmasq', git: 'https://github.com/jtimberman/housepub-dnsmasq.git'
cookbook 'dnsmasq', git: 'https://github.com/hw-cookbooks/dnsmasq.git', ref: '889f22f'

# Attributes drive recipes
default['authorization']['sudo'].tap do |sudo|
  sudo['passwordless'] = true
  sudo['groups']       = ['wheel']
  sudo['users']        = ['jtimberman']
end

default['rsyslog'].tap do |rsyslog|
  rsyslog['server']   = true
  rsyslog['protocol'] = 'udp'
end

default['postfix'].tap do |postfix|
  postfix['myorigin']            = 'housepub.org'
  postfix['mydomain']            = 'housepub.org'
  postfix['spool_dir']           = '/srv/export/mail'
  postfix['mail_type']           = 'client'
  postfix['relayhost']           = 'pop.dnvr.qwest.net'
  postfix['mail_relay_networks'] = '127.0.0.0/8 10.13.37.0/24'
end

default['ntp'].tap do |ntp|
  ntp['servers'] = ['0.us.pool.ntp.org', 'time.apple.com']
end

default['packages'] = %W(dmidecode emacs-nox ethtool git iftop iperf3
                         iproute lsof lvm2 nmap nmap-ncat rsync telnet
                         the_silver_searcher tmux tree znc vim git
                         ruby ruby-devel rubygem-pry zsh)

default['openssh']['server'].tap do |sshd|
  sshd['use_dns']                  = 'no'
  sshd['use_privilege_separation'] = 'yes'
  sshd['password_authentication']  = 'no'
end

default['runit'].tap do |runit|
  runit['sv_bin']       = '/sbin/sv'
  runit['sv_dir']       = '/etc/sv'
  runit['chpst_bin']    = '/sbin/chpst'
  runit['service_dir']  = '/etc/service'
  runit['lsb_init_dir'] = '/etc/init.d'
  runit['executable']   = '/sbin/runit'
  runit['start']        = '/etc/init.d/runit-start start'
  runit['stop']         = '/etc/init.d/runit-start stop'
  runit['reload']       = '/etc/init.d/runit-start reload'
end

default['annoyances']['rhel']['delete_existing_firewall_rules'] = false

default['dnsmasq'].tap do |dnsmasq|
  dnsmasq['dns'].tap do |dns|
    dns['server'] = '205.171.2.65'
  end

  dnsmasq['dhcp'].tap do |dhcp|
    dhcp['domain'] = 'int.housepub.org'
    dhcp['tftp-root'] = '/var/lib/tftpboot'
  end
end
