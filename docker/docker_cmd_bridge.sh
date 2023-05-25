# tmp
cd /usr/local && rm cuda && ln -s cuda-11.7 cuda
# single node
# cd /vehicle/yckj3860/code/EVA_wjf/docker/ && bash start_docker_main.sh

# multinode 
# node1
# cd /vehicle/yckj3860/code/EVA_wjf/docker/ && bash start_docker_mulNode1.sh
# cd /vehicle/yckj3860/code/EVA_wjf/docker/ && bash start_docker_mulNode2.sh

# 只启动一个节点
if  [ $1 -eq 1 ]
then
   cd /vehicle/yckj3860/code/EVA_wjf/docker/ && bash start_docker_main.sh
fi

if  [ $1 -gt 1 ]
then
    cd /vehicle/yckj3860/code/EVA_wjf/docker/ && bash start_docker_mulNodes.sh $1 $2 $3 $4

fi
# 启动多个节点中的0号节点
# if  [ $1 -eq 1 ]
# then
# #    cd /vehicle/yckj3860/code/EVA_wjf/docker/ && bash start_docker_mulNode1.sh
#    cd /vehicle/yckj3860/code/EVA_wjf/docker/ && bash start_docker_mulNodes.sh 3
# fi

# if  [ $1 -eq 2 ]
# then
#    cd /vehicle/yckj3860/code/EVA_wjf/docker/ && bash start_docker_mulNode2.sh
# fi

# if  [ $1 -eq 3 ]
# then
#    cd /vehicle/yckj3860/code/EVA_wjf/docker/ && bash start_docker_mulNode3.sh
# fi