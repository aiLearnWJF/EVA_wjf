#!/usr/bin/env bash
# 第一个是主机
ip_array=("10.168.4.169" "10.168.4.129" "10.168.4.209")
eth_array=("eth0" "eth2" "eth0")
# ip_array=("10.168.4.169" "10.168.4.129")
# eth_array=("eth0" "eth2")
nnodes=${#ip_array[@]}
master_addr="10.168.4.169"

# 先清理
for i in "${ip_array[@]}"; do
echo ssh yckj3860@${i} "pkill -f python -9;"
ssh yckj3860@${i} "pkill -f python -9;"
sleep 1
done

cnt=0
cd /vehicle/yckj3860/code/EVA_wjf/docker
for i in "${ip_array[@]}"; do
echo "$i"
echo "正在启动第${cnt}台机器"
ssh yckj3860@${i} "cd /vehicle/yckj3860/code/EVA_wjf/docker && bash start_docker.sh ${nnodes} $cnt ${master_addr} ${eth_array[$cnt]}"
let "cnt++"
done

