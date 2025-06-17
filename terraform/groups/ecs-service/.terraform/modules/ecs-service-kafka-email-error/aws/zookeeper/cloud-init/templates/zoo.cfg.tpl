write_files:
  - path: ${zookeeper_home}/conf/zoo.cfg
    owner: ${zookeeper_service_user}:${zookeeper_service_group}
    permissions: 0644
    content: |
      autopurge.purgeInterval=${zookeeper_autopurge_interval_hours}
      autopurge.snapRetainCount=${zookeeper_snapshot_retain_count}
      clientPort=${zookeeper_client_port}
      dataDir=${zookeeper_data_directory}
      initLimit=${zookeeper_init_limit_ticks}
      snapCount=${zookeeper_snap_count}
      syncLimit=${zookeeper_sync_limit_ticks}
      tickTime=${zookeeper_tick_time}
      %{ for entry in ensemble }
      ${entry}%{ endfor }
