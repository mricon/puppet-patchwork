# == Class: patchwork2::database::mysql
#
# Creates the patchwork database on a local or remote mysql server.
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
class patchwork2::database::mysql {
  include ::patchwork2

  # Manually install mariadb-devel until mysql module updates with the code
  # that fixes this.
  #  include '::mysql::bindings::daemon_dev'
  package { 'mysql-daemon_dev':
    ensure => 'present',
    name   => 'mariadb-devel',
  }
  # Install mysql python bindings
  class { '::mysql::bindings':
    python_enable => true,
  }

  python::pip { 'mysqlclient':
    ensure     => present,
    pkgname    => 'mysqlclient',
    virtualenv => $patchwork2::virtualenv_dir,
    owner      => $patchwork2::user,
    require    => [
      Class['python'],
      Python::Pyvenv[$patchwork2::virtualenv_dir],
    ],
  }

  if $patchwork2::manage_database {
    if $patchwork2::collect_exported {
      @@mysql::db { "patchwork_${::fqdn}":
        user     => $patchwork2::database_user,
        password => $patchwork2::database_pass,
        dbname   => $patchwork2::database_name,
        host     => $::ipaddress,
        tag      => $patchwork2::database_tag,
      }
    } else {
      include ::mysql::server
      mysql::db { 'patchwork':
        ensure   => 'present',
        user     => $patchwork2::database_user,
        password => $patchwork2::database_pass,
        host     => $::ipaddress,
      }
    }
  }
}
