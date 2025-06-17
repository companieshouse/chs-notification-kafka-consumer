#!/bin/bash
# Redirect the user-data output to the console logs
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# Disable source / destination check. It cannot be disabled from the launch configuration and is required to intercept traffic
instanceid=`curl -s http://169.254.169.254/latest/meta-data/instance-id`
echo "Disabling source-dest check for: $instanceid"
aws ec2 modify-instance-attribute --no-source-dest-check --instance-id $instanceid --region ${REGION}

#Setup Cloudwatch logging/metrics and scheduled update cron
/usr/local/bin/ansible-playbook /root/deployment-script.yml -e '${ANSIBLE_INPUTS}'
