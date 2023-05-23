# 提前下载好原始镜像，可去掉
# sudo docker load < pytorch_1.9.0-cuda11.1-cudnn8-devel.tar
# sudo docker pull pytorch/pytorch:1.9.0-cuda11.1-cudnn8-devel

# 构建镜像名
DST_IMAGE_NAME="eva_clip:1.0"
# 构建容器名
DST_CONTAINER_NAME="eva_clip_test"
# shm-size
SHM_SIZE=120G

{
    sudo docker rm -f ${DST_CONTAINER_NAME} && \
    echo "删除容器操作成功"
} || {
    echo "删除容器失败，无该文件"
}
{
    sudo docker rmi ${DST_IMAGE_NAME} && \
    echo "删除镜像操作成功"
} || {
    echo "删除镜像失败，无该文件"
}
# 构建镜像
sudo docker build -f Dockerfile -t ${DST_IMAGE_NAME} .
echo "构建镜像成功"
# 启动镜像
echo "开始启动容器并运行..."
# 修改docker_cmd_bridge.sh控制分布式训练脚本
# 如果需要后台运行 -it 改为 -d , 通过 docker logs -f 容器名 查看进展
#-p 18022:22 -p 18080:80 -p 8234:8234  \
sudo docker run --name ${DST_CONTAINER_NAME} \
                --net=host \
                -v/vehicle:/vehicle \
                -v/data2/opensource/:/data2/opensource/  \
                -v/usr/local/cuda-11.7:/usr/local/cuda-11.7 \
                --gpus "all"  \
                --shm-size ${SHM_SIZE} \
                -d  ${DST_IMAGE_NAME}  bash /vehicle/yckj3860/code/EVA_wjf/docker/docker_cmd_bridge.sh
# 实时日志，可中断不影响程序
sudo docker logs -f ${DST_CONTAINER_NAME}