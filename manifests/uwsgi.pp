# == Class: patchwork::uwsgi
#
# Manages the configuration of uwsgi
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# === Authors
#
# Trevor Bramwell <tbramwell@linuxfoundation.org>
#
# === Copyright
#
# Copyright 2015 Trevor Bramwell
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
class patchwork::uwsgi {

  include ::uwsgi

  if (has_key($patchwork::uwsgi_config, 'logto')) {
    $log_dir = dirname($patchwork::uwsgi_config['logto'])
    validate_absolute_path($log_dir)

    file { $log_dir:
      ensure => 'directory',
      owner  => $patchwork::user,
      group  => $patchwork::group,
    }
  }

  package { $patchwork::uwsgi_plugin_package:
    ensure => present,
  }

  uwsgi::app { 'patchwork':
    ensure              => 'present',
    uid                 => $patchwork::user,
    gid                 => $patchwork::group,
    application_options => $patchwork::uwsgi_config,
    require             => [
      Package[$patchwork::uwsgi_plugin_package],
    ],
  }

}
