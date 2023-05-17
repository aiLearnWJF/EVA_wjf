ARG PYTORCH="1.9.0"
ARG CUDA="11.1"
ARG CUDNN="8"
FROM pytorch/pytorch:${PYTORCH}-cuda${CUDA}-cudnn${CUDNN}-devel

RUN rm /etc/apt/sources.list.d/cuda.list \
  && rm /etc/apt/sources.list.d/nvidia-ml.list \
  && apt-get update \
  && apt-get install ninja-build

EXPOSE 8080 8081 8082
# VOLUME # 挂载的目录 
# EXPOSE # 暴露端口配置 
# CMD