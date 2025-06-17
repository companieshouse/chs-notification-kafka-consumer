write_files:
  - path: ${zookeeper_home}/conf/zookeeper-env.sh
    owner: ${zookeeper_service_user}:${zookeeper_service_group}
    permissions: 0755
    content: |
      # This is prepended to #JVMFLAGS
      SERVER_JVMFLAGS="-Xms${zookeeper_heap_mb}m"

      ZK_SERVER_HEAP="${zookeeper_heap_mb}"
      ZOO_LOG4J_PROP="INFO,ROLLINGFILE"
