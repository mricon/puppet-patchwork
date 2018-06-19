# == Class: patchwork2::params
#
# Parameter definition for patchwork. See init.pp for documentation.
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
class patchwork2::params {
  $install_dir      = '/opt/patchwork'
  $virtualenv_dir   = '/opt/patchwork/venv'
  $urlpath          = '/'
  $version          = 'master'
  $user             = 'patchwork'
  $group            = 'patchwork'
  $source_repo      = 'git://github.com/getpatchwork/patchwork'
  $manage_database  = false
  $database_flavor  = 'mysql'
  $database_name    = 'patchwork'
  $database_host    = 'localhost'
  $database_port    = 3306
  $database_user    = 'patchwork'
  $database_pass    = 'patchwork'
  $database_tag     = "${database_flavor}-patchwork"
  $manage_python    = true
  $python_package   = 'python3'
  $python_version   = '3'

  $uwsgi_options    = {
    virtualenv         => $virtualenv_dir,
    chdir              => $install_dir,
    pythonpath         => $install_dir,
    module             => 'patchwork.wsgi:application',
    manage-script-name => true,
    mount              => '%(url)=%(module)',
    static-map         => "/static=${install_dir}/static",
    logto              => '/var/log/patchwork/uwsgi.log',
    master             => true,
    http-socket        => ':9000',
    processes          => 4,
    threads            => 2,
    plugins            => 'python3',
  }

  $uwsgi_plugin_package = 'uwsgi-plugin-python3'

  $collect_exported = false
  $cron_minutes     = '10'
}
