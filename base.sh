#!/bin/bash
#####iptables修改##########
IPADD=`ifconfig |grep 'Ethernet  HWaddr' -A3|grep 'inet add'|awk -F: '{print $2}'|awk '{print $1}'|egrep -v "^10|^192.168|^172.1|^172.2|^172.2|^172.30|^172.31|^127.0.0.1"`
########安装基础包###########
function baseyum-install() {
	yum  install -y wireshark  tcpdump telnet httpd php wget ncurses-devel python-devel vim ntp lrzsz
	yum -y groupinstall 'Development tools'
}

function baseservice-start() {
	mv /opt/rtt/rtt.sh /opt/
	chmod +x /opt/rtt.sh
	######解决因selinux问题导致出现403下载错误的解决BUG####
	chcon -R -t httpd_sys_content_t /var/www/html
	######站点部署##############
	# 启动服务
	service httpd start
	# 时间同步~
	ntpdate ntp1.aliyun.com
	# 写入硬件时间
	hwclock -w
	if [ -d /data/rtt ];then
	date +%s >>/data/rtt/time
	else 
	mkdir -p /data/rtt/
	date +%s >>/data/rtt/time
	fi 
	# 关闭防火墙
	service iptables stop
	# 网站测试图片下载
	# curl -L http://www.onemt.com/static/images/game_2.jpg -o /var/www/html/logo.png
	curl -L https://www.google.com.hk/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png -o /var/www/html/logo.png
	######调整计划任务和时区、时间同步#####
	echo "0 * * * * root /usr/sbin/ntpdate ntp1.aliyun.com; /sbin/hwclock --systohc" >> /etc/crontab
	#####海外服务器开启这个
	cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime -r
	# 执行计划任务（自动抓包，10分钟重启一次抓包软件wireshark）
	echo "*/10 * * * * root sh -x /opt/rtt.sh 2>&1 > /dev/null" >> /etc/crontab
       # 执行计划任务（保障磁盘空间每30分钟删除一次wireshark抓包文件-删除wireshark临时文件）
	echo "*/30 * * * * root rm -rf /tmp/wireshark_eth0*" >> /etc/crontab
	# 执行计划任务（保障网页服务不卡死，12小时重启一次httpd服务）
	echo "* 12 * * * root service httpd restart" >> /etc/crontab
}

function uninstall() {
	yum erase -y wireshark  tcpdump telnet httpd php wget ncurses-devel python-devel vim ntp lrzsz
	yum -y  groupremove 'Development tools'
}


function rtt() {
	baseyum-install
	baseservice-start
}

rtt
######reboot
