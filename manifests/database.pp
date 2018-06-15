class patchwork::database {
  case $patchwork::database_flavor {
    'pgsql': { include ::patchwork::database::pgsql }
    'mysql': { include ::patchwork::database::mysql }
  }
}
