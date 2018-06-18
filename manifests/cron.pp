# == Class: patchwork::cron
#
# Manages patchworks' cron job for expiring registrations and sending patch
# change notification
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
class patchwork::cron {
  cron { 'patchwork':
    ensure      => present,
    command     => "${patchwork::virtualenv_dir}/bin/python ${patchwork::install_dir}/manage.py cron",
    environment => 'PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin',
    user        => $patchwork::user,
    minute      => "*/${patchwork::cron_minutes}",
  }

}
