write_files:
  - path: ${zookeeper_data_directory}/myid
    owner: ${zookeeper_service_user}:${zookeeper_service_group}
    permissions: 0444
    content: |
      ${myid}
