# muti node
export NCCL_IB_HCA=mlx5_1,mlx5_2,mlx5_3,mlx5_4,mlx5_5,mlx5_6,mlx5_7,mlx5_8
export NCCL_IB_GID_INDEX=3
export NCCL_IB_TIMEOUT=22

# cuda
export PATH=/mnt/pfs/data/yckj1563/pkgs/cuda/cuda-11.7/bin:$PATH
export LD_LIBRARY_PATH=/mnt/pfs/data/yckj1563/pkgs/cuda/cuda-11.7/lib64:$LD_LIBRARY_PATH

sudo apt install ninja-build

export CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7
export PYTHONPATH="/mnt/pfs/data/yckj1563/project/EVA_wjf/EVA-CLIP/rei"
# py37_torch1_7_evaclip eva_clip

# ┌────────────────────────────────────────────────────────────────────────┐
# │              预训练      
# └────────────────────────────────────────────────────────────────────────┘
MODEL=EVA01-CLIP-g-14
# PRETRAINED 是载入完整权重，后两个是分别载入权重，好像会有问题，初始很低
PRETRAINED=/mnt/pfs/data/yckj1563/projects/EVA_wjf/pretrained/EVA01_CLIP_g_14_psz14_s11B.pt
PRETRAINED_IMAGE=eva #/home/yckj3860/.cache/huggingface/hub/models--QuanSun--EVA-CLIP/snapshots/63d255690a20d26438e10737a86246a94e8cc2c1/EVA02_CLIP_B_psz16_s8B.pt
PRETRAINED_TEXT=openai #/home/yckj3860/.cache/clip/ViT-B-16.pt
PRETRAINED_VISUAL_MODEL=EVA02-B-16
PRETRAINED_TEXT_MODEL=OpenaiCLIP-B-16

# can automaticaly download and load pretrained models by follwing 4 lines; please check details in pretrained.py
# PRETRAINED_IMAGE=eva
# PRETRAINED_TEXT=openai
# PRETRAINED_VISUAL_MODEL=EVA02-B-16
# PRETRAINED_TEXT_MODEL=OpenaiCLIP-B-16

# Following OpenCLIP, we preprocess data by webdataset. We concat paths of LAION-2B and COYO-700M with `;`.

MERGE_2B_DATA_PATH="/mnt/pfs/data/yckj1563/data/CC12M/{00000..01426}.tar"
# MERGE_2B_DATA_PATH="/vehicle/yckj3860/data/vlm_data/mscoco/{00000..00059}.tar;/data2/opensource/CC12M//{00000..00009}.tar;/data2/opensource/LAION-400M/laion400m-data/{00000..00100}.tar;/home/yckj1563/data/CommonPool/small/shards/{00000000..00000050}.tar;/data2/opensource/SBU/{00000..00050}.tar"
# MERGE_2B_DATA_PATH="/data2/opensource/LAION-400M/laion400m-data/{00000..00100}.tar"
VAL_DATA_PATH=/mnt/pfs/data/yckj1563/data/imagenet/val/

cd /mnt/pfs/data/yckj1563/projects/EVA_wjf/EVA-CLIP/rei

# export WORLD_SIZE=2
export NCCL_DEBUG=INFO
export NCCL_SOCKET_IFNAME=$4
# export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
# export PATH=/usr/local/cuda/bin:$PATH
nohup /mnt/pfs/data/yckj1563/miniconda3/envs/py37_torch1_7_evaclip/bin/python -m torch.distributed.launch --nproc_per_node=8 \
       	--nnodes=$1 --node_rank=$2 \
	--master_addr="${3}" --master_port=8234 --use_env \
    training/main.py \
        --save-frequency 1 \
        --zeroshot-frequency 1 \
        --report-to="tensorboard" \
        --wandb-project-name="eva-clip" \
        --wandb-notes="eva01_clip_g_plus_14" \
        --train-num-samples 11000000 \
        --dataset-resampled \
        --train-data-list=${MERGE_2B_DATA_PATH} \
        --dataset-type-list="webdataset;webdataset" \
        --imagenet-val=${VAL_DATA_PATH} \
        --warmup 20 \
        --batch-size=1824 \
        --epochs=7 \
        --lr=3.4e-5 \
        --visual-lr=2.7e-5 \
        --text-lr=2.7e-6 \
        --wd=0.05 \
        --visual-wd=0.05 \
        --text-wd=0.05 \
        --ld=1.0 \
        --visual-ld=0.85 \
        --text-ld=0.75 \
        --grad-clip-norm=5.0 \
        --smoothing=0. \
        --workers=8 \
        --model=${MODEL} \
        --pretrained ${PRETRAINED} \
        --skip-list head.weight head.bias lm_head.weight lm_head.bias mask_token text_projection logit_scale \
        --seed 4096 \
        --gather-with-grad \
        --grad-checkpointing \
        --local-loss \
        --force-custom-clip \
        --force-patch-dropout=0.5 \
        --precision=amp_bf16 \
        --optimizer="lamb" \
        --zero-stage=1 \
        >/mnt/pfs/data/yckj1563/projects/EVA_wjf/baiduyun/outputs/${5}_${2}.log 2>&1  &
