#!/usr/bin/env bash
# 第一个是主机
# ip_array=("10.168.4.169" "10.168.4.129" "10.168.4.209")
# eth_array=("eth0" "eth2" "eth0")
ip_array=("192.168.48.11" "192.168.48.12" "192.168.48.13" "192.168.48.14")
eth_array=("eth0" "eth0" "eth0" "eth0")
nnodes=${#ip_array[@]}
master_addr="192.168.48.11"

# 先清理
for i in "${ip_array[@]}"; do
echo ssh ${i} "pkill -f python -9;"
ssh ${i} "pkill -f python -9;"
sleep 1
done

cnt=0
name=$1
for i in "${ip_array[@]}"; do
echo "$i"
echo "正在启动编号为${cnt}的机器"
ssh ${i} "cd /mnt/pfs/data/yckj1563/projects/EVA_wjf/baiduyun && ./configs/${name}.sh ${nnodes} $cnt ${master_addr} ${eth_array[$cnt]} ${name} &"
let "cnt++"
done

# sleep 8h
# > outputs/${name}_${cnt}.log 2>&1

# master上开启监控
# ssh ${master_addr} "cd /mnt/pfs/data/yckj1563/projects/EVA_wjf/ && /mnt/pfs/data/yckj1563/miniconda3/envs/py37_torch1_7_evaclip/bin/python inspect_warning.py"