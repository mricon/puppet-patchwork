require 'spec_helper'

describe 'patchwork2', :type => 'class' do
  context 'with defaults for parameters used by cron' do
    it { should compile }
    it { should contain_cron('patchwork').with(
      'command' => '/opt/patchwork/venv/bin/python /opt/patchwork/manage.py cron',
      'minute' => '*/10',
    )}
  end
  context 'with different parameters' do
    let(:params) {{
      :virtualenv_dir => '/fakevirtualenv',
      :install_dir    => '/foo/lib',
      :cron_minutes   => '20',
    }}
    it { should contain_cron('patchwork').with(
      'command' => '/fakevirtualenv/bin/python /foo/lib/manage.py cron',
      'user'    => 'patchwork',
      'minute' => '*/20',
    )}
    it { should contain_file('/foo/lib/patchwork/settings/production.py')
           .with_content(/NOTIFICATION_DELAY_MINUTES = 20/)}
  end
end
