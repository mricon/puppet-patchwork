require 'spec_helper'

describe 'patchwork::config', :type => 'class' do
  context 'with defaults for all parameters' do
    it { should compile }
    it { should contain_file('/opt/patchwork/patchwork/settings/production.py')
           .with_content(/LANGUAGE_CODE = 'en_US'/)
           .with_content(/FORCE_HTTPS_LINKS = False/)
           .with_content(/ENABLE_XMLRPC = False/)
           .with_content(/DEFAULT_PATCHES_PER_PAGE = 10/)
           .with_content(/DEFAULT_FROM_EMAIL = 'Patchwork <patchwork@patchwork.example.com>'/)
           .with_content(/NOTIFICATION_DELAY_MINUTES = 10/)
           .with_content(/TIME_ZONE = 'Etc\/UTC'/)
           .with_content(/'BACKEND': 'django.core.cache.backends.locmem.LocMemCache'/)
           .without_content(/'TIMEOUT'/)
           .without_content(/'LOCATION'/)
           .without_content(/'OPTIONS'/)
           .with_content(/ADMINS = \(\s+\)/)
           .with_content(/ALLOWED_HOSTS = \(\s+\)/)
    }
  end
  context 'with changes to all parameters' do
    let(:params) {{
      :time_zone => 'US/PST',
      :from_email => '<foo@example.com>',
      :notification_delay => '20',
      :patches_per_page => '80',
      :language_code => 'fi-SE',
      :cache_timeout => 'None',
      :cache_location => ['some other place'],
      :cache_options => {
        'TEST' => "'some variable'",
        'TEST2' => 12345
      },
      :force_https_links => 'True',
      :enable_xmlrpc => 'True',
      :admins => {'Patchwork Admin' => 'patchwork@example.com'},
      :allowed_hosts => ['192.168.0.0/24','foo.example.com'],
    }}
    it { should compile }
    it { should contain_file('/opt/patchwork/patchwork/settings/production.py')
           .with(
               'owner' => 'patchwork',
               'group' => 'patchwork',
               'show_diff' => 'false',
            )
           .with_content(/LANGUAGE_CODE = 'fi-SE'/)
           .with_content(/TIME_ZONE = 'US\/PST'/)
           .with_content(/DEFAULT_FROM_EMAIL = '<foo@example.com>'/)
           .with_content(/NOTIFICATION_DELAY_MINUTES = 20/)
           .with_content(/ENABLE_XMLRPC = True/)
           .with_content(/FORCE_HTTPS_LINKS = True/)
           .with_content(/'LOCATION': \[\s+'some other place',\s+\]/)
           .with_content(/'TIMEOUT': None,/)
           .with_content(/'TEST': 'some variable',/)
           .with_content(/'TEST2': 12345,/)
           .with_content(/DEFAULT_PATCHES_PER_PAGE = 80/)
           .with_content(/ADMINS = \(\s+\('Patchwork Admin', 'patchwork@example.com'\),\s\)/)
           .with_content(/ALLOWED_HOSTS = \(\s+'192\.168\.0\.0\/24',\s+'foo\.example\.com',\s\)/)
    }
  end
end
