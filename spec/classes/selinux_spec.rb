require 'spec_helper'

describe 'patchwork2::selinux', :type => 'class' do
  context 'with defaults for parameters used by selinux' do
    it { should compile }
    it { should contain_selboolean('httpd_can_network_connect_db')
      .with({
          'persistent' => 'true',
          'value'      => 'on',
      })
    }
    it { should contain_selinux__module('mypatchwork')
      .with({
        'source' => 'puppet:///modules/patchwork/mypatchwork.te',
      })
    }
    it { should contain_selinux__fcontext('/usr/sbin/uwsgi')
      .with({
        'ensure' => 'present',
        'setype' => 'httpd_exec_t',
      })
    }
    it { should contain_selinux__fcontext('/var/run/uwsgi')
      .with({
        'ensure'    => 'present',
        'recursive' => 'true',
        'setype'    => 'httpd_var_run_t',
      })
    }
    it { should contain_selinux__fcontext('/var/log/uwsgi')
      .with({
        'ensure'    => 'present',
        'recursive' => 'true',
        'setype'    => 'httpd_log_t',
      })
    }
    it { should contain_selinux__fcontext('/var/log/patchwork')
      .with({
        'ensure'    => 'present',
        'recursive' => 'true',
        'setype'    => 'httpd_log_t',
      })
    }
  end
end
