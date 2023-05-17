# 提前下载好原始镜像，可去掉
sudo docker pull pytorch/pytorch:1.9.0-cuda11.1-cudnn8-devel

DST_IMAGE_NAME="eva_clip:1.0"
DST_CONTAINER_NAME="eva_clip_test"

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

# 启动镜像
# sudo docker run --name ${DST_CONTAINER_NAME} -it ${DST_IMAGE_NAME} pwd
sudo docker run --name ${DST_CONTAINER_NAME} \
                -p 18022:22 -p 18080:80 -p 8234:1234  \
                -v/vehicle:/vehicle \
                -v/data2/opensource/:/data2/opensource/  \
                --gpus "all"  \
                -it  ${DST_IMAGE_NAME}  bash /vehicle/yckj3860/code/EVA_wjf/docker_bridge.sh