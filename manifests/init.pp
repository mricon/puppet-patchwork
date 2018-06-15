# == Class: patchwork
#
# Manages the installation and configuration of Patchwork
#
#  http://jk.ozlabs.org/projects/patchwork/
#  https://patchwork.readthedocs.org/en/latest/
#
# === Parameters
#
# [*install_dir*]
#   The directory where patchwork should be installed.
#
#   Default: '/opt/patchwork'
#
# [*virtualenv_dir*]
#   The directory where the virtualenv should reside.
#
#   Default: '/opt/patchwork/venv'
#
# [*version*]
#   Version of patchwork that should be installed.
#   If 'latest' is specified, the installation will track the tip of the
#   patchwork 'master' branch, otherwise the repo will be ensured
#   'present' overwriting any local changes that take place.
#
#   Default: 'master'
#
# [*user*]
#   User that owns patchwork files and runs the application.
#
#   Default 'patchwork'
#
# [*group*]
#   Group that has access to patchwork files.
#
#   Default 'patchwork'
#
# [*source_repo*]
#   git repo URL for cloning patchwork. Useful for installing your own fork
#   / patched version of patchwork.
#
#   Default: 'git://github.com/getpatchwork/patchwork'
#
# [*manage_database*]
#   Installs a local MySQL server.
#
#   Default: true
#
# [*uwsgi_overrides*]
#   Items in the hash will replace the defaults listed in
#   `uwsgi_options` of the params class.
#
#   Default: {}
#
# [*database_name*]
#   The name of the patchwork database.
#
#   Default: 'patchwork'
#
# [*database_host*]
#   Database hostname of the client should connect to.
#
#   Databases created either through 'patchwork::collect_exported'
#   or 'patchwork::manage_database' use '$::ipaddress' for the
#   host.
#
#   Default: 'localhost'
#
# [*database_user*]
#   The username for connection to the database.
#
#   Default: 'patchwork'
#
# [*database_pass*]
#   The password associated with the database username.
#
#   Default: 'patchwork'
#
# [*database_tag*]
#   Exported resource tag to for collecting the database resource onto a
#   database server.
#
#   Default: 'mysql-patchwork'
#
# [*collect_exported*]
#
#   Changes database definition from a regular resource to an exported
#   resource and allows for creating the database on another server. Also see:
#   'patchwork::database_tag'
#
#   Default: false
#
# [*cron_minutes*]
#
#   Patchwork uses a cron script to clean up expired registrations, and send
#   notifications of patch changes (for projects with this enabled). This
#   setting defines the number of minutes between patchwork cron job runs.
#
#   There is no need to modify 'notification_delay' since
#   setting 'cron_minutes' will also set 'patchwork::config::notification_delay'.
#
#   Default: 10
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
class patchwork (
  Pattern['^\/']     $install_dir        = $patchwork::params::install_dir,
  Pattern['^\/']     $virtualenv_dir     = $patchwork::params::virtualenv_dir,
  Pattern['^\/']     $urlpath            = $patchwork::params::urlpath,
  String             $version            = $patchwork::params::version,
  String             $user               = $patchwork::params::user,
  String             $group              = $patchwork::params::group,
  String             $source_repo        = $patchwork::params::source_repo,
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

  # can be */20, for example, so not an integer
  String                $cron_minutes      = $patchwork::params::cron_minutes,
  Boolean               $collect_exported  = $patchwork::params::collect_exported,

) inherits patchwork::params {

  $uwsgi_config = merge($patchwork::params::uwsgi_options, $uwsgi_overrides)

  anchor { 'patchwork:begin': }
  anchor { 'patchwork:end': }

  include '::patchwork::install'
  include '::patchwork::database'
  include '::patchwork::config'
  include '::patchwork::uwsgi'
  include '::patchwork::cron'

  Anchor['patchwork:begin']
    ->Class['::patchwork::install']
    ->Class['::patchwork::database']
    ->Class['::patchwork::config']
    ->Class['::patchwork::uwsgi']
    ->Class['::patchwork::cron']
    ->Anchor['patchwork:end']

}
