write_files:
  - path: /sbin/nsupdate.sh
    owner: root:root
    permissions: 0744
    content: |
      #!/bin/sh

      set -e

      ip_address=$(curl -f ${aws_instance_metadata_url}/latest/meta-data/local-ipv4)

      cat<<EOF | /usr/bin/nsupdate -k ${key_path}/ns-update-key -v
      server ${dns_server_ip}
      zone ${dns_zone_name}
      update delete ${hostname} A
      update add ${hostname} 60 A $${ip_address}
      show
      send
      EOF
