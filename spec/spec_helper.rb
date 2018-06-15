RSpec.configure do |c|
  c.mock_with :rspec
end
require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |c|
  c.default_facts = {
    :osfamily                  => 'RedHat',
    :operatingsystem           => 'CentOS',
    :ipaddress                 => '172.16.32.42',
    :operatingsystemmajrelease => '7',
    :operatingsystemrelease    => '7.0',
    :fqdn                      => 'patchwork.example.com',
    :hostname                  => 'patchwork',
    :path                      => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    :virtualenv_version        => '1.10.1'
  }
  c.hiera_config = File.expand_path(File.join(__FILE__, '../fixtures/hiera.yaml'))
  c.fail_fast = true
end

at_exit { RSpec::Puppet::Coverage.report! }
