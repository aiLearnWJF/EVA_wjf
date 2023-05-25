export CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7
export PYTHONPATH="/vehicle/yckj3860/code/EVA_wjf/EVA-CLIP/rei"
# py37_torch1_7_evaclip eva_clip


# ┌────────────────────────────────────────────────────────────────────────┐
# │  直接测试比对相似度        
# └────────────────────────────────────────────────────────────────────────┘
# /vehicle/yckj3860/miniconda3/envs/py37_torch1_7_evaclip/bin/python test_my.py

# ┌────────────────────────────────────────────────────────────────────────┐
# │              测试imagenet精度      
# └────────────────────────────────────────────────────────────────────────┘
MODEL_NAME=EVA02-CLIP-B-16
# PRETRAINED=/vehicle/yckj3860/code/EVA_wjf/pretrained/EVA02_CLIP_B_psz16_s8B.pt
PRETRAINED=/vehicle/yckj3860/code/EVA_wjf/EVA-CLIP/rei/logs/2023_05_17-14_14_48-model_EVA02-CLIP-B-16-lr_5e-05-b_784-j_2-p_amp/checkpoints/epoch_15/EVA02_CLIP_B_psz16_s8B.pt
DATA_PATH=/vehicle/dataset/imagenet/val/
cd EVA-CLIP/rei

/vehicle/yckj3860/miniconda3/envs/py37_torch1_7_evaclip/bin/python -m torch.distributed.launch --nproc_per_node=1 --nnodes=1 --node_rank=0 \
	--master_addr='localhost' --master_port=12355 --use_env training/main.py \
        --imagenet-val ${DATA_PATH} \
        --model ${MODEL_NAME} \
        --pretrained ${PRETRAINED} \
        --force-custom-clip

# ┌────────────────────────────────────────────────────────────────────────┐
# │              可视化      
# └────────────────────────────────────────────────────────────────────────┘
#  /vehicle/yckj3860/miniconda3/envs/py37_torch1_7_evaclip/bin/tensorboard --logdir
# #  个人pc上
#  ssh -L 16006:127.0.0.1:6006 yckj3860@10.168.4.11