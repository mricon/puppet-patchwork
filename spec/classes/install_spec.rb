require 'spec_helper'

describe 'patchwork2', :type => 'class' do
  context 'install' do
    context 'with defaults for all parameters' do
      it { should contain_class('git') }
      it { should contain_class('python') }
      # Uncomment this once the mysql module has been updated
      #it { should contain_class('mysql::bindings::daemon_dev') }
      # Remove the following check once mysql has been updated
      it { should contain_package('mysql-daemon_dev')
        .with({
          'ensure' => 'present',
          'name' => 'mariadb-devel',
        })
      }
      it { should contain_class('mysql::bindings')
        .with({
          'python_enable' => 'true'
        })
      }
      it { should contain_user('patchwork')
           .with({
               'ensure'  => 'present',
               'comment' => 'User for managing Patchwork',
               'home'    => '/opt/patchwork',
               'system'  => true,
           })
      }
      it { should contain_vcsrepo('/opt/patchwork')
        .with({
          'ensure' => 'present',
          'user'   => 'patchwork',
          'group'  => 'patchwork',
          'source' => 'git://github.com/getpatchwork/patchwork',
          'revision' => 'master',
        })
      }
      it { should contain_file('/etc/logrotate.d/patchwork')
        .with({
          'ensure' => 'file',
          'source' => 'puppet:///modules/patchwork/logrotate.d/patchwork',
        })
      }
      it { should contain_python__pyvenv('/opt/patchwork/venv')
        .with({
          'owner'        => 'patchwork',
          'group'        => 'patchwork',
        })
      }
      it { should contain_python__requirements('/opt/patchwork/requirements-prod.txt')
        .with({
          'virtualenv' => '/opt/patchwork/venv',
          'owner'      => 'patchwork',
        })
      }
    end
    context 'with unmanaged database' do
      let(:params) {{
        :manage_database => false,
      }}
      it { should_not contain_class('mysql::server') }
      it { should contain_package('mysql-daemon_dev') }
      it { should contain_class('mysql::bindings') }
    end
    context 'with specific patchwork version' do
      let(:params) {{
        :version => '1.2.3',
      }}
      it { should contain_vcsrepo('/opt/patchwork')
        .with({
          'ensure' => 'present',
          'source' => 'git://github.com/getpatchwork/patchwork',
          'revision' => '1.2.3',
          'user'     => 'patchwork',
          'group'    => 'patchwork',
        })
      }
    end
    context 'with latest patchwork version' do
      let(:params) {{
        :version => 'latest',
      }}
      it { should contain_vcsrepo('/opt/patchwork')
        .with({
          'ensure' => 'latest',
          'source' => 'git://github.com/getpatchwork/patchwork',
          'revision' => 'master',
          'user'     => 'patchwork',
          'group'    => 'patchwork',
        })
      }
    end
    context 'with hiera version data' do
      let (:facts) {{
          :fqdn => 'patchwork.example'
      }}
      it { should contain_vcsrepo('/opt/patchwork')
        .with({
          'ensure' => 'present',
          'source' => 'git://github.com/getpatchwork/patchwork',
          'revision' => 'v2.1.0',
          'user'     => 'patchwork-user',
          'group'    => 'patchwork-group',
        })
      }
    end
  end
end
