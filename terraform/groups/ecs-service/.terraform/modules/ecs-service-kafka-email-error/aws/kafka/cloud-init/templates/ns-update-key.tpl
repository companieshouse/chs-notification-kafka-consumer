write_files:
  - path: ${key_path}/ns-update-key
    owner: root:root
    permissions: 0744
    content: |
      key aws.ch.internal {
        algorithm HMAC-MD5;
        secret "${key_content}";
      };
