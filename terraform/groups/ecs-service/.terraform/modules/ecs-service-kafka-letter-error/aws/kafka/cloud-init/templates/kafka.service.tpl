write_files:
  - path: /etc/systemd/system/kafka.service
    owner: root:root
    permissions: 0644
    content: |
      [Unit]
      Description=Apache Kafka server (broker)
      Documentation=http://kafka.apache.org/documentation.html
      Requires=network.target remote-fs.target
      After=network.target remote-fs.target

      [Service]
      Type=simple
      User=${kafka_service_user}
      Group=${kafka_service_group}
      ExecStart=${kafka_home}/bin/kafka-server-start.sh ${kafka_home}/config/server.properties
      ExecStop=${kafka_home}/bin/kafka-server-stop.sh
      Restart=on-failure
      SyslogIdentifier=kafka

      [Install]
      WantedBy=multi-user.target
