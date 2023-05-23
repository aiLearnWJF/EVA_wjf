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
# MODEL_NAME=EVA02-CLIP-B-16
# # PRETRAINED=/vehicle/yckj3860/code/EVA_wjf/pretrained/EVA02_CLIP_B_psz16_s8B.pt
# PRETRAINED=/vehicle/yckj3860/code/EVA_wjf/EVA-CLIP/rei/logs/2023_05_17-14_14_48-model_EVA02-CLIP-B-16-lr_5e-05-b_784-j_2-p_amp/checkpoints/epoch_15/EVA02_CLIP_B_psz16_s8B.pt
# DATA_PATH=/vehicle/dataset/imagenet/val/
# cd EVA-CLIP/rei

# /vehicle/yckj3860/miniconda3/envs/py37_torch1_7_evaclip/bin/python -m torch.distributed.launch --nproc_per_node=1 --nnodes=1 --node_rank=0 \
# 	--master_addr='localhost' --master_port=12355 --use_env training/main.py \
#         --imagenet-val ${DATA_PATH} \
#         --model ${MODEL_NAME} \
#         --pretrained ${PRETRAINED} \
#         --force-custom-clip

# ┌────────────────────────────────────────────────────────────────────────┐
# │              预训练      
# └────────────────────────────────────────────────────────────────────────┘
MODEL=EVA02-CLIP-B-16
# PRETRAINED 是载入完整权重，后两个是分别载入权重，好像会有问题，初始很低
PRETRAINED=/vehicle/yckj3860/code/EVA_wjf/pretrained/EVA02_CLIP_B_psz16_s8B.pt
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

MERGE_2B_DATA_PATH="/data2/opensource/LAION-400M/laion400m-data/{00000..00100}.tar"
# MERGE_2B_DATA_PATH="/vehicle/yckj3860/data/vlm_data/mscoco/{00000..00059}.tar;/data2/opensource/CC12M//{00000..00009}.tar;/data2/opensource/LAION-400M/laion400m-data/{00000..00100}.tar;/home/yckj1563/data/CommonPool/small/shards/{00000000..00000050}.tar;/data2/opensource/SBU/{00000..00050}.tar"
# MERGE_2B_DATA_PATH="/data2/opensource/LAION-400M/laion400m-data/{00000..00100}.tar"
VAL_DATA_PATH=/vehicle/dataset/imagenet/val/

cd /vehicle/yckj3860/code/EVA_wjf/EVA-CLIP/rei
# export WORLD_SIZE=1
/vehicle/yckj3860/miniconda3/envs/py37_torch1_7_evaclip/bin/python -m torch.distributed.launch --nproc_per_node=8 \
       	--nnodes=1 --node_rank=0 \
	--master_addr='localhost' --master_port=12357 --use_env \
    training/main.py \
        --save-frequency 1 \
        --zeroshot-frequency 1 \
        --report-to="tensorboard" \
        --wandb-project-name="eva-clip" \
        --wandb-notes="eva02_clip_B_16" \
        --train-num-samples 6000000 \
        --dataset-resampled \
        --train-data-list=${MERGE_2B_DATA_PATH} \
        --dataset-type-list="webdataset" \
        --imagenet-val=${VAL_DATA_PATH} \
        --warmup 2000 \
        --batch-size=256 \
        --epochs=20 \
        --lr=5e-5 \
        --visual-lr=1e-4 \
        --text-lr=1e-5 \
        --wd=0.05 \
        --visual-wd=0.05 \
        --text-wd=0.05 \
        --ld=1.0 \
        --visual-ld=0.75 \
        --text-ld=0.75 \
        --grad-clip-norm=5.0 \
        --smoothing=0. \
        --workers=2 \
        --model=${MODEL} \
        --pretrained ${PRETRAINED} \
        --skip-list head.weight head.bias lm_head.weight lm_head.bias mask_token text_projection logit_scale \
        --seed 4096 \
        --gather-with-grad \
        --grad-checkpointing \
        --local-loss \
        --force-custom-clip \
        --force-patch-dropout=0.5 \
        --optimizer="adam" \
        --zero-stage=1 \
        --grad-accumulation-steps 2 \
        --precision "amp" \
        --enable-deepspeed

# ┌────────────────────────────────────────────────────────────────────────┐
# │              同步到196上，慎用！必须在EVA_wjf目录下运行      
# └────────────────────────────────────────────────────────────────────────┘
# rsync -avg yckj3860@10.168.4.11:/home/yckj3860/code/EVA_wjf/* .