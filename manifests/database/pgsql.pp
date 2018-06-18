# == Class: patchwork2::database::pgsql
#
# Creates the patchwork database on a local or remote pgsql server.
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
class patchwork2::database::pgsql {
  include ::patchwork

  # Managing pgsql databases is too complicated, so we are going
  # to just include the server here and let you do the rest via your
  # profile/hiera.
  if $patchwork2::manage_database {
    include ::postgresql::server
  }
}
