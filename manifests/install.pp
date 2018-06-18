# == Class: patchwork2::install
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
class patchwork2::install {
  include ::git

  if $patchwork2::manage_python {
    class { '::python':
      version    => $patchwork2::python_package,
      dev        => true,
      pip        => true,
      virtualenv => true,
      gunicorn   => false,
    }
  }

  # Create a virtualenv and install patchwork's requirements.txt
  python::pyvenv { $patchwork2::virtualenv_dir:
    version => $patchwork2::python_version,
    owner   => $patchwork2::user,
    group   => $patchwork2::group,
    require => [
      Class['::python'],
      Vcsrepo[$patchwork2::install_dir],
    ],
  }

  python::requirements { '/opt/patchwork/requirements-prod.txt':
    virtualenv => $patchwork2::virtualenv_dir,
    owner      => $patchwork2::user,
    group      => $patchwork2::group,
    require    => [
      Class['::python'],
      Python::Pyvenv[$patchwork2::virtualenv_dir],
      Vcsrepo[$patchwork2::install_dir],
    ],
  }

  # If 'latest' version is given the repo will track master and keep up
  # to date; provided patchwork uses master as their development branch
  case $patchwork2::version {
    'latest': {
      $vcsrepo_ensure = 'latest'
      $revision       = 'master'
    }
    default: {
      $vcsrepo_ensure = 'present'
      $revision       = $patchwork2::version
    }
  }

  user { 'patchwork':
    ensure  => present,
    comment => 'User for managing Patchwork',
    name    => $patchwork2::user,
    home    => $patchwork2::install_dir,
    system  => true,
  }

  file { $patchwork2::install_dir:
    ensure => 'directory',
    owner  => $patchwork2::user,
    group  => $patchwork2::group,
  }

  vcsrepo { $patchwork2::install_dir:
    ensure   => $vcsrepo_ensure,
    provider => 'git',
    user     => $patchwork2::user,
    group    => $patchwork2::group,
    source   => $patchwork2::source_repo,
    revision => $revision,
    force    => true,
    require  => File[$patchwork2::install_dir],
  }

  file { '/etc/logrotate.d/patchwork':
    ensure => 'file',
    source => 'puppet:///modules/patchwork/logrotate.d/patchwork',
  }

}
