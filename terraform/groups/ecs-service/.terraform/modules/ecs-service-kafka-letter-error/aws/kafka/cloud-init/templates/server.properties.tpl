write_files:
  - path: ${kafka_home}/config/server.properties
    owner: ${kafka_service_user}:${kafka_service_group}
    permissions: 0644
    content: |
      advertised.listeners=PLAINTEXT://${hostname}:9092
      auto.create.topics.enable=false
      broker.id=${broker_id}
      broker.rack=${rack_id}
      delete.topic.enable=true
      group.initial.rebalance.delay.ms=0
      listeners=PLAINTEXT://:9092
      log.cleaner.enable=true
      log.dirs=${kafka_data_directory}
      log.retention.check.interval.ms=300000
      log.retention.hours=168
      log.segment.bytes=1073741824
      min.insync.replicas=${min_insync_replicas}
      num.io.threads=8
      num.network.threads=3
      num.partitions=1
      num.recovery.threads.per.data.dir=1
      offsets.topic.replication.factor=${offsets_topic_replication_factor}
      socket.receive.buffer.bytes=102400
      socket.request.max.bytes=104857600
      socket.send.buffer.bytes=102400
      transaction.state.log.min.isr=1
      transaction.state.log.replication.factor=1
      zookeeper.connect=${kafka_zookeeper_connect_string}
      zookeeper.connection.timeout.ms=18000
