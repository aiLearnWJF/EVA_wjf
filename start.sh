export CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7
export PYTHONPATH="/home/yckj3860/code/EVA_wjf/EVA-CLIP/rei"


# ┌────────────────────────────────────────────────────────────────────────┐
# │  直接测试比对相似度        
# └────────────────────────────────────────────────────────────────────────┘
# /vehicle/yckj3860/miniconda3/envs/py37_torch1_7_evaclip/bin/python test_my.py

# ┌────────────────────────────────────────────────────────────────────────┐
# │              测试imagenet精度      
# └────────────────────────────────────────────────────────────────────────┘
MODEL_NAME=EVA02-CLIP-B-16
PRETRAINED=/home/yckj3860/.cache/huggingface/hub/models--QuanSun--EVA-CLIP/snapshots/63d255690a20d26438e10737a86246a94e8cc2c1/EVA02_CLIP_B_psz16_s8B.pt
DATA_PATH=/vehicle/dataset/imagenet/
cd EVA-CLIP/rei

/vehicle/yckj3860/miniconda3/envs/py37_torch1_7_evaclip/bin/python -m torch.distributed.launch --nproc_per_node=1 --nnodes=1 --node_rank=0 \
	--master_addr='localhost' --master_port=12355 --use_env training/main.py \
        --imagenet-val ${DATA_PATH} \
        --model ${MODEL_NAME} \
        --pretrained ${PRETRAINED} \
        --force-custom-clip

# ┌────────────────────────────────────────────────────────────────────────┐
# │              预训练      
# └────────────────────────────────────────────────────────────────────────┘
# MODEL=EVA02-CLIP-B-16
# PRETRAINED_IMAGE=eva #/home/yckj3860/.cache/huggingface/hub/models--QuanSun--EVA-CLIP/snapshots/63d255690a20d26438e10737a86246a94e8cc2c1/EVA02_CLIP_B_psz16_s8B.pt
# PRETRAINED_TEXT=openai #/home/yckj3860/.cache/clip/ViT-B-16.pt
# PRETRAINED_VISUAL_MODEL=EVA02-B-16
# PRETRAINED_TEXT_MODEL=OpenaiCLIP-B-16

# # can automaticaly download and load pretrained models by follwing 4 lines; please check details in pretrained.py
# # PRETRAINED_IMAGE=eva
# # PRETRAINED_TEXT=openai
# # PRETRAINED_VISUAL_MODEL=EVA02-B-16
# # PRETRAINED_TEXT_MODEL=OpenaiCLIP-B-16

# # Following OpenCLIP, we preprocess data by webdataset. We concat paths of LAION-2B and COYO-700M with `;`.

# MERGE_2B_DATA_PATH="/vehicle/yckj3860/data/vlm_data/mscoco/{00000..00059}.tar;/vehicle/yckj3860/data/vlm_data/CC12M/{00000..00009}.tar"
# # MERGE_2B_DATA_PATH="/vehicle/yckj3860/data/vlm_data/CC12M/{00000..00009}.tar"
# # LAION_2B_DATA_PATH="/path/to/laion2b_en_data/img_data/{000000..164090}.tar"
# VAL_DATA_PATH=/vehicle/yckj3860/data/imagenet_2012/

# cd EVA-CLIP/rei

# export WORLD_SIZE=1
# /vehicle/yckj3860/miniconda3/envs/py37_torch1_7_evaclip/bin/python -m torch.distributed.launch --nproc_per_node=8 \
#        	--nnodes=1 --node_rank=0 \
# 	--master_addr='localhost' --master_port=12356 --use_env \
#     training/main.py \
#         --save-frequency 1 \
#         --zeroshot-frequency 1 \
#         --report-to="tensorboard" \
#         --wandb-project-name="eva-clip" \
#         --wandb-notes="eva02_clip_B_16" \
#         --train-num-samples 40000000 \
#         --dataset-resampled \
#         --train-data-list=${MERGE_2B_DATA_PATH} \
#         --dataset-type-list="webdataset;webdataset" \
#         --imagenet-val=${VAL_DATA_PATH} \
#         --warmup 2000 \
#         --batch-size=256 \
#         --epochs=200 \
#         --lr=5e-5 \
#         --visual-lr=2e-5 \
#         --text-lr=2e-6 \
#         --wd=0.05 \
#         --visual-wd=0.05 \
#         --text-wd=0.05 \
#         --ld=1.0 \
#         --visual-ld=0.75 \
#         --text-ld=0.75 \
#         --grad-clip-norm=5.0 \
#         --smoothing=0. \
#         --workers=4 \
#         --model=${MODEL} \
#         --pretrained-image=${PRETRAINED_IMAGE} \
#         --pretrained-text=${PRETRAINED_TEXT} \
#         --pretrained-visual-model=${PRETRAINED_VISUAL_MODEL} \
#         --pretrained-text-model=${PRETRAINED_TEXT_MODEL} \
#         --skip-list head.weight head.bias lm_head.weight lm_head.bias mask_token text_projection logit_scale \
#         --seed 4096 \
#         --gather-with-grad \
#         --grad-checkpointing \
#         --local-loss \
#         --force-custom-clip \
#         --force-patch-dropout=0.5 \
#         --optimizer="adam" \
#         --zero-stage=1

# ┌────────────────────────────────────────────────────────────────────────┐
# │              同步到196上，慎用！必须在EVA_wjf目录下运行      
# └────────────────────────────────────────────────────────────────────────┘
# rsync -avg yckj3860@10.168.4.11:/home/yckj3860/code/EVA_wjf/* .