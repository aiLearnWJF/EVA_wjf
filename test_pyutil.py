# 启动命令：nohup /mnt/pfs/data/yckj1563/miniconda3/envs/py37_torch1_7_evaclip/bin/python test_pyutil.py /mnt/pfs/data/yckj1563/projects/EVA_wjf/test_pyutil_tee.log 2>&1 &
import os
# myfile = 'test_pyutil.log'
MODEL_NAME="EVA01-CLIP-g-14"
# PRETRAINED=/mnt/pfs/data/yckj1563/projects/EVA_wjf/pretrained/EVA01_CLIP_g_14_psz14_s11B.pt
# PRETRAINED_L=['/mnt/pfs/data/yckj1563/projects/EVA_wjf/EVA-CLIP/rei/logs/2023_05_26-13_04_18-model_EVA01-CLIP-g-14-lr_0.00034-b_2176-j_8-p_amp_bf16','/mnt/pfs/data/yckj1563/projects/EVA_wjf/EVA-CLIP/rei/logs/2023_05_26-21_04_26-model_EVA01-CLIP-g-14-lr_3.4e-06-b_2176-j_8-p_amp_bf16','/mnt/pfs/data/yckj1563/projects/EVA_wjf/EVA-CLIP/rei/logs/2023_05_27-05_04_32-model_EVA01-CLIP-g-14-lr_3.4e-05-b_1216-j_8-p_amp_bf16','/mnt/pfs/data/yckj1563/projects/EVA_wjf/EVA-CLIP/rei/logs/2023_05_27-13_04_41-model_EVA01-CLIP-g-14-lr_3.4e-05-b_1824-j_8-p_amp_bf16','/mnt/pfs/data/yckj1563/projects/EVA_wjf/EVA-CLIP/rei/logs/2023_05_27-21_04_47-model_EVA01-CLIP-g-14-lr_3.4e-05-b_2176-j_8-p_amp_bf16','/mnt/pfs/data/yckj1563/projects/EVA_wjf/EVA-CLIP/rei/logs/2023_05_28-05_04_53-model_EVA01-CLIP-g-14-lr_3.4e-05-b_2176-j_8-p_amp_bf16','/mnt/pfs/data/yckj1563/projects/EVA_wjf/EVA-CLIP/rei/logs/2023_05_28-13_05_00-model_EVA01-CLIP-g-14-lr_3.4e-05-b_2176-j_8-p_amp_bf16','/mnt/pfs/data/yckj1563/projects/EVA_wjf/EVA-CLIP/rei/logs/2023_05_28-21_05_08-model_EVA01-CLIP-g-14-lr_3.4e-05-b_2176-j_8-p_amp_bf16']
PRETRAINED_L=['/mnt/pfs/data/yckj1563/projects/EVA_wjf/EVA-CLIP/rei/logs/2023_05_31-15_09_35-model_EVA01-CLIP-g-14-lr_0.34-b_2176-j_8-p_amp_bf16']
DATA_PATH="/mnt/pfs/data/yckj1563/data/imagenet/val/"
EpochNums_per_model = 11
# cd EVA-CLIP/rei

# f_myfile = open(myfile, 'w')
for PRETRAINED in PRETRAINED_L:
    for ep in range(EpochNums_per_model):
        # ep = 6
        pretrained_path = PRETRAINED + "/checkpoints/epoch_%d.pt"%(ep+1)
        mycmd = "export CUDA_VISIBLE_DEVICES='7' && export PYTHONPATH='/vehicle/yckj3860/code/EVA_wjf/EVA-CLIP/rei' && cd EVA-CLIP/rei && /mnt/pfs/data/yckj1563/miniconda3/envs/py37_torch1_7_evaclip/bin/python -m torch.distributed.launch --nproc_per_node=1 --nnodes=1 --node_rank=0 --master_addr='localhost' --master_port=12362 --use_env training/main.py --imagenet-val %s --model %s --pretrained %s --force-custom-clip  --batch-size=64 && sleep 20"%( DATA_PATH,MODEL_NAME,pretrained_path)
        s = "".join(os.popen(mycmd).readlines())
    # print(s)
    # f_myfile.write(s)
    # f_myfile.flush()
# f_myfile.close()

