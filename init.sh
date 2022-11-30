cp /etc/sysctl.conf /etc/sysctl.conf.bak
if cat /etc/sysctl.conf | grep "anten" > /dev/null ;then
echo ""
else
cat >> /etc/sysctl.conf <<EOF
#system  add
fs.file-max=65535
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_synack_retries = 5
net.ipv4.tcp_syn_retries = 5
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 120
net.ipv4.ip_local_port_range = 1024  65535
kernel.shmall = 2097152
kernel.shmmax = 2147483648
kernel.shmmni = 4096
kernel.sem = 5010 641280 5010 128
net.core.wmem_default=262144
net.core.wmem_max=262144
net.core.rmem_default=4194304
net.core.rmem_max=4194304
net.ipv4.tcp_fin_timeout = 10
net.ipv4.tcp_keepalive_time = 30
net.ipv4.tcp_window_scaling = 0
net.ipv4.tcp_sack = 0
kernel.hung_task_timeout_secs = 0
EOF
fi

sysctl -p

if cat /etc/security/limits.conf | grep "* soft nofile 65535" > /dev/null;then
    echo ""
else
    echo "* soft nofile 65535" >> /etc/security/limits.conf
fi
if cat /etc/security/limits.conf | grep "* hard nofile 65535" > /dev/null ;then
    echo ""
else
    echo "* hard nofile 65535" >> /etc/security/limits.conf
fi


#修改預設128  定義了系统中每一個端口最大的Listen lenth,這是全域變數
echo 1000 >/proc/sys/net/core/somaxconn

systemctl stop firewalld
systemctl disable firewalld
setenforce 0

yum -y update
yum -y install net-tools vim epel-release

# selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
