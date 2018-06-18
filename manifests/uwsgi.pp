# == Class: patchwork2::uwsgi
#
# Manages the configuration of uwsgi
#
# === Authors
#
# Trevor Bramwell <tbramwell@linuxfoundation.org>
# Konstantin Ryabitsev <konstantin@linuxfoundation.org>
#
# === Copyright
#
# Copyright (C) 2015-2018 by The Linux Foundation
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
class patchwork2::uwsgi {

  include ::uwsgi

  if (has_key($patchwork2::uwsgi_config, 'logto')) {
    $log_dir = dirname($patchwork2::uwsgi_config['logto'])
    validate_absolute_path($log_dir)

    file { $log_dir:
      ensure => 'directory',
      owner  => $patchwork2::user,
      group  => $patchwork2::group,
    }
  }

  package { $patchwork2::uwsgi_plugin_package:
    ensure => present,
  }

  uwsgi::app { 'patchwork':
    ensure              => 'present',
    uid                 => $patchwork2::user,
    gid                 => $patchwork2::group,
    application_options => $patchwork2::uwsgi_config,
    require             => [
      Package[$patchwork2::uwsgi_plugin_package],
    ],
  }

}
