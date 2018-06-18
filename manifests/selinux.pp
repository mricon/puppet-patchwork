# == Class: patchwork2::selinux
#
# Manages selinux policy files for Patchwork
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
class patchwork2::selinux {
  include ::patchwork2

  if $patchwork2::manage_selinux {
    include ::selinux::base

    selboolean { 'httpd_can_network_connect_db':
      persistent => true,
      value      => 'on',
    }

    selinux::module {'mypatchwork':
      source => 'puppet:///modules/patchwork/mypatchwork.te',
    }

    selinux::fcontext { '/usr/sbin/uwsgi':
      ensure => present,
      setype => 'httpd_exec_t',
    }

    selinux::fcontext { '/var/run/uwsgi':
      ensure    => present,
      recursive => true,
      setype    => 'httpd_var_run_t',
    }

    selinux::fcontext { '/var/log/uwsgi':
      ensure    => present,
      recursive => true,
      setype    => 'httpd_log_t',
    }

    selinux::fcontext { '/var/log/patchwork':
      ensure    => present,
      recursive => true,
      setype    => 'httpd_log_t',
    }
  }
}
