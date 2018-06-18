# == Class: patchwork::database::mysql
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
# Copyright 2015-2018 by The Linux Foundation
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
class patchwork::database::mysql {
  include ::patchwork

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
    ensure     => '1.3.12',
    pkgname    => 'mysqlclient',
    virtualenv => $patchwork::virtualenv_dir,
    owner      => $patchwork::user,
    require    => [
      Class['python'],
      Python::Pyvenv[$patchwork::virtualenv_dir],
    ],
  }

  if $patchwork::manage_database {
    if $patchwork::collect_exported {
      @@mysql::db { "patchwork_${::fqdn}":
        user     => $patchwork::database_user,
        password => $patchwork::database_pass,
        dbname   => $patchwork::database_name,
        host     => $::ipaddress,
        tag      => $patchwork::database_tag,
      }
    } else {
      include ::mysql::server
      mysql::db { 'patchwork':
        ensure   => 'present',
        user     => $patchwork::database_user,
        password => $patchwork::database_pass,
        host     => $::ipaddress,
      }
    }
  }
}
