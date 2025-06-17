write_files:
  - path: /etc/systemd/system/zookeeper.service
    owner: root:root
    permissions: 0644
    content: |
      [Unit]
      Description=Zookeeper Daemon
      Documentation=http://zookeeper.apache.org
      Requires=network.target
      After=network.target

      [Service]
      Type=forking
      WorkingDirectory=${zookeeper_home}
      User=${zookeeper_service_user}
      Group=${zookeeper_service_group}
      ExecStart=${zookeeper_home}/bin/zkServer.sh start ${zookeeper_home}/conf/zoo.cfg
      ExecStop=${zookeeper_home}/bin/zkServer.sh stop ${zookeeper_home}/conf/zoo.cfg
      ExecReload=${zookeeper_home}/bin/zkServer.sh restart ${zookeeper_home}/conf/zoo.cfg
      TimeoutSec=30
      Restart=on-failure

      [Install]
      WantedBy=default.target
