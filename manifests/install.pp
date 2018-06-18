# == Class: patchwork::install
#
# Manages the installation of Patchwork
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
class patchwork::install {
  include ::git

  if $patchwork::manage_python {
    class { '::python':
      version    => $patchwork::python_package,
      dev        => true,
      pip        => true,
      virtualenv => true,
      gunicorn   => false,
    }
  }

  # Create a virtualenv and install patchwork's requirements.txt
  python::pyvenv { $patchwork::virtualenv_dir:
    version => $patchwork::python_version,
    owner   => $patchwork::user,
    group   => $patchwork::group,
    require => [
      Class['::python'],
      Vcsrepo[$patchwork::install_dir],
    ],
  }

  python::requirements { '/opt/patchwork/requirements-prod.txt':
    virtualenv => $patchwork::virtualenv_dir,
    owner      => $patchwork::user,
    group      => $patchwork::group,
    require    => [
      Class['::python'],
      Python::Pyvenv[$patchwork::virtualenv_dir],
      Vcsrepo[$patchwork::install_dir],
    ],
  }

  # If 'latest' version is given the repo will track master and keep up
  # to date; provided patchwork uses master as their development branch
  case $patchwork::version {
    'latest': {
      $vcsrepo_ensure = 'latest'
      $revision       = 'master'
    }
    default: {
      $vcsrepo_ensure = 'present'
      $revision       = $patchwork::version
    }
  }

  user { 'patchwork':
    ensure  => present,
    comment => 'User for managing Patchwork',
    name    => $patchwork::user,
    home    => $patchwork::install_dir,
    system  => true,
  }

  file { $patchwork::install_dir:
    ensure => 'directory',
    owner  => $patchwork::user,
    group  => $patchwork::group,
  }

  vcsrepo { $patchwork::install_dir:
    ensure   => $vcsrepo_ensure,
    provider => 'git',
    user     => $patchwork::user,
    group    => $patchwork::group,
    source   => $patchwork::source_repo,
    revision => $revision,
    force    => true,
    require  => File[$patchwork::install_dir],
  }

  file { '/etc/logrotate.d/patchwork':
    ensure => 'file',
    source => 'puppet:///modules/patchwork/logrotate.d/patchwork',
  }

}
