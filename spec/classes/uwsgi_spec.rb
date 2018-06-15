require 'spec_helper'

describe 'patchwork', :type => 'class' do
  context 'uwsgi' do
    context 'with defaults for all parameters' do
      it { should compile }
      it { should contain_class('patchwork::uwsgi') }
      it { should contain_class('uwsgi') }
      it { should contain_file('/var/log/patchwork')
           .with({
               'ensure' => 'directory',
           })
      }
      it { should contain_uwsgi__app('patchwork')
        .with({
          'ensure'              => 'present',
          'application_options' => {
            'virtualenv' => '/opt/patchwork/venv',
            'chdir'      => '/opt/patchwork',
            'pythonpath' => '/opt/patchwork',
            'module'     => 'patchwork.wsgi:application',
            'manage-script-name' => true,
            'mount' => '/=patchwork.wsgi:application',
            'static-map' => '/static=/opt/patchwork/htdocs',
            'logto'      => '/var/log/patchwork/uwsgi.log',
            'master'     => true,
            'http-socket' => ':9000',
            'processes' => 4,
            'threads'   => 2,
            'plugins'   =>'python3',
          }
        })
      }
    end
    context 'with overrides for options' do
      let(:params) {{
        :uwsgi_overrides => {
            'http-socket' => ':2222',
            'mount' => '/patchwork=patchwork.wsgi:application',
            'master' => false,
            'threads' => 8,
        }
      }}
      it { should contain_uwsgi__app('patchwork')
           .with({
              'application_options' => {
                'virtualenv' => '/opt/patchwork/venv',
                'chdir'      => '/opt/patchwork',
                'pythonpath' => '/opt/patchwork',
                'module'     => 'patchwork.wsgi:application',
                'manage-script-name' => true,
                'mount' => '/patchwork=patchwork.wsgi:application',
                'static-map' => '/static=/opt/patchwork/htdocs',
                'logto'      => '/var/log/patchwork/uwsgi.log',
                'master'     => false,
                'http-socket' => ':2222',
                'processes' => 4,
                'threads'   => 8,
                'plugins'   =>'python3',
             }
           })
      }
    end
  end
end
