# patchwork

#### Table of Contents

1. [Overview](#overview)
2. [Usage - Configuration options and additional functionality](#usage)
3. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)
6. [Release Notes/Changelog - What the module does and why it is useful](#release-noteschangelog)

## Overview

[![Build Status](https://travis-ci.org/mricon/puppet-patchwork.png)](https://travis-ci.org/mricon/puppet-patchwork)

A Puppet module for managing deployments of
[Patchwork](http://http://jk.ozlabs.org/projects/patchwork/) - the
web-based patch tracking system

## Usage

To use this module you can either directly include it in your module
tree, or add the following to your `Puppetfile`:

```
  mod 'mricon-patchwork'
```

A node should then be assigned the relevant patchwork classes.

```puppet
  class { 'patchwork':
    version => 'v2.1.0'
  }
  class { 'patchwork::config':
    secret_key    => 'CHANGEME',
    allowed_hosts => ['localhost', '.example.com']
  }
```

A secret key can be generated with the following Linux command:

```shell
  $ pwgen -sync 50 1 | tr -d "'\""
```

If you're using Hiera, a basic yaml configuration might look like:

```yaml
  patchwork::version: 'v2.1.0'
  patchwork::config::secret_key: 'CHANGEME'
  patchwork::config::allowed_hosts:
     - 'localhost'
     - '.example.com'
```

After Pachwork has been installed and configured, it is up to you to
manage the application deployment. This includes:

 - Initializing / Migrating the Database: `python3 manage.py migrate --noinput`
 - Loading fixtures `python3 manage.py loaddata default_tags default_states`
 - Collecting Static files: `python3 manage.py collectstatic`
 - Creating admin(s)/superuser(s): `python3 manage.py createsuperuser`

## Reference

For pre-2.0 release, please refer to the source code.

## Limitations

This module has been tested to work with Puppet 4 on the following
operating systems:

 - CentOS 7

## Development

Patches can be submitted by forking this repo and submitting a
pull-request. Along with code changes, patches must include with the
following materials:

 - Tests
 - Documentation

## Release Notes/Changelog

Please see the [CHANGELOG](CHANGELOG.md) for a list of changes available
in the current and previous releases.
