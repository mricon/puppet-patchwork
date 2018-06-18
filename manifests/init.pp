# == Class: patchwork
#
# Manages the installation and configuration of Patchwork
#
#  http://jk.ozlabs.org/projects/patchwork/
#  https://patchwork.readthedocs.org/en/latest/
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
class patchwork (
  Pattern['^\/']        $install_dir     = $patchwork::params::install_dir,
  Pattern['^\/']        $virtualenv_dir  = $patchwork::params::virtualenv_dir,
  Pattern['^\/']        $urlpath         = $patchwork::params::urlpath,
  String                $version         = $patchwork::params::version,
  String                $user            = $patchwork::params::user,
  String                $group           = $patchwork::params::group,
  String                $source_repo     = $patchwork::params::source_repo,
  # Database settings
  Boolean               $manage_database = $patchwork::params::manage_database,
  Enum['pgsql','mysql'] $database_flavor = $patchwork::params::database_flavor,
  String                $database_name   = $patchwork::params::database_name,
  String                $database_host   = $patchwork::params::database_host,
  Integer               $database_port   = $patchwork::params::database_port,
  String                $database_user   = $patchwork::params::database_user,
  String                $database_pass   = $patchwork::params::database_pass,
  String                $database_tag    = $patchwork::params::database_tag,

  Boolean               $manage_python   = $patchwork::params::manage_python,
  String                $python_package  = $patchwork::params::python_package,
  String                $python_version  = $patchwork::params::python_version,

  Optional[Hash]        $uwsgi_overrides      = {},
  String                $uwsgi_plugin_package = $patchwork::params::uwsgi_plugin_package,

  Boolean               $manage_selinux   = $patchwork::params::manage_selinux,

  String                $cron_minutes     = $patchwork::params::cron_minutes,
  Boolean               $collect_exported = $patchwork::params::collect_exported,

) inherits patchwork::params {

  $uwsgi_config = merge($patchwork::params::uwsgi_options, $uwsgi_overrides)

  anchor { 'patchwork:begin': }
  anchor { 'patchwork:end': }

  include '::patchwork::install'
  include '::patchwork::database'
  include '::patchwork::config'
  include '::patchwork::uwsgi'
  include '::patchwork::selinux'
  include '::patchwork::cron'

  Anchor['patchwork:begin']
    ->Class['::patchwork::install']
    ->Class['::patchwork::database']
    ->Class['::patchwork::config']
    ->Class['::patchwork::uwsgi']
    ->Class['::patchwork::selinux']
    ->Class['::patchwork::cron']
    ->Anchor['patchwork:end']

}
