# == Class: patchwork2
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
class patchwork2 (
  Pattern['^\/']        $install_dir     = $patchwork2::params::install_dir,
  Pattern['^\/']        $virtualenv_dir  = $patchwork2::params::virtualenv_dir,
  Pattern['^\/']        $urlpath         = $patchwork2::params::urlpath,
  String                $version         = $patchwork2::params::version,
  String                $user            = $patchwork2::params::user,
  String                $group           = $patchwork2::params::group,
  String                $source_repo     = $patchwork2::params::source_repo,
  # Database settings
  Boolean               $manage_database = $patchwork2::params::manage_database,
  Enum['pgsql','mysql'] $database_flavor = $patchwork2::params::database_flavor,
  String                $database_name   = $patchwork2::params::database_name,
  String                $database_host   = $patchwork2::params::database_host,
  Integer               $database_port   = $patchwork2::params::database_port,
  String                $database_user   = $patchwork2::params::database_user,
  String                $database_pass   = $patchwork2::params::database_pass,
  String                $database_tag    = $patchwork2::params::database_tag,

  Boolean               $manage_python   = $patchwork2::params::manage_python,
  String                $python_package  = $patchwork2::params::python_package,
  String                $python_version  = $patchwork2::params::python_version,

  Optional[Hash]        $uwsgi_overrides      = {},
  String                $uwsgi_plugin_package = $patchwork2::params::uwsgi_plugin_package,

  String                $cron_minutes     = $patchwork2::params::cron_minutes,
  Boolean               $collect_exported = $patchwork2::params::collect_exported,

) inherits patchwork2::params {

  $uwsgi_config = merge($patchwork2::params::uwsgi_options, $uwsgi_overrides)

  anchor { 'patchwork2:begin': }
  anchor { 'patchwork2:end': }

  include '::patchwork2::install'
  include '::patchwork2::database'
  include '::patchwork2::config'
  include '::patchwork2::uwsgi'
  include '::patchwork2::cron'

  Anchor['patchwork2:begin']
    ->Class['::patchwork2::install']
    ->Class['::patchwork2::database']
    ->Class['::patchwork2::config']
    ->Class['::patchwork2::uwsgi']
    ->Class['::patchwork2::cron']
    ->Anchor['patchwork2:end']

}
