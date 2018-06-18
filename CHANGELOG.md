# Changelog

## 2018-06-18 - v2.0.0

* Rewrite for patchwork-2.1 and Python3
  This is a pretty significant rewrite, so the module should be considered
  incompatible with the module written for patchwork-1.0.0 by Trevor.
* Add support for posgresql databases

## 2016-06-17 - v0.4.0

* Add Cache Configuration to settings.py

  * `patchwork::config::cache_backend`
  * `patchwork::config::cache_location`
  * `patchwork::config::cache_timeout`
  * `patchwork::config::cache_options`

## 2016-04-19 - v0.3.1

* [#11] (https://github.com/bramwelt/puppet-patchwork/pull/11) Enable
  searching of httpd\_log\_t directories through selinux policy

## 2016-04-14 - v0.3.0

* Add `patchwork::selinux` manifest
* Include logrotate script
* Add missing `virtualenv_version` fact for tests
* Enable configuration for XMLRPC in settings.py

  * Adds `patchwork::config::enable_xmlrpc`

## 2016-03-22 - v0.2.2

* Bump stankevich-python dependency to at least `1.11.0`
* Fix testsing issues introduced by bumping the dependencies
* Fix parameter defaults:

  * `patchwork::user`
  * `patchwork::group`

## 2016-03-21 - v0.2.1

* [#9](https://github.com/bramwelt/puppet-patchwork/pull/9) Create databases using ipaddress for host

  * `patchwork::database_host` only used for Django settings
  * Resolves [#8](https://github.com/bramwelt/puppet-patchwork/pull/8)

## 2016-03-08 - v0.2.0

* [#6](https://github.com/bramwelt/puppet-patchwork/pull/6) Allow Overriding of uwsgi Parameters

  * Removes `patchwork::uwsgi_options`
  * Adds    `patchwork::uwsgi_overrides`

## 2016-03-02 - v0.1.2

* [#4](https://github.com/bramwelt/puppet-patchwork/pull/4) Disable reporting changes to settings.py

## 2016-02-26 - v0.1.1

* [#1](https://github.com/bramwelt/puppet-patchwork/pull/1) Ensure 'manage_database' only manages the server
* [#2](https://github.com/bramwelt/puppet-patchwork/pull/2) Use 'include' for classes declared by managed flagsbramwelt/puppet-patchwork#2) Use 'include' for classes declared by managed flags

## 2016-02-22 - v0.1.0 Initial Release

* Install Patchwork through git and manage settings.py
