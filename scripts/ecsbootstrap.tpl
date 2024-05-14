#!/bin/bash

touch /home/ec2-user/config_out.txt
yum install -y aws-cli

#associating the EC2 instances with the cluster
echo '#!/usr/bin/env bash' > /home/ec2-user/ecs_config.sh
echo 'sleep 120' >> /home/ec2-user/ecs_config.sh
echo 'echo ECS_CLUSTER=clixx-CLUSTER >> /etc/ecs/ecs.config' >> /home/ec2-user/ecs_config.sh
chmod 744 /home/ec2-user/ecs_config.sh

#Running in child shell
sh /home/ec2-user/ecs_config.sh 1>/home/ec2-user/config_out.txt 2>/home/ec2-user/config_out.txt & disown

sudo yum update -y

sudo yum install mysql -y

#Starting Docker 
sudo amazon-linux-extras install docker -y
sudo systemctl start docker


#EFS MOUNT
mkdir -p ${MOUNT_POINT}
chown ec2-user:ec2-user ${MOUNT_POINT}
sudo echo ${EFS_DNS}:/ ${MOUNT_POINT} nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,_netdev 0 0 >> /etc/fstab
mount -a -t nfs4

sudo /sbin/sysctl -w net.ipv4.tcp_keepalive_time=200 net.ipv4.tcp_keepalive_intvl=200 net.ipv4.tcp_keepalive_probes=5

sleep 100

sudo yum update -y ecs-init

#Executing update statement
mysql -h "${DB_HOST}" -u "${DB_USER}" -p"${DB_PASS}" "${DB_NAME}" <<EOF
UPDATE wp_options SET option_value = '${LB_DNS}' WHERE option_value LIKE '%NLB%';
EOF
