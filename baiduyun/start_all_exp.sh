# bash start_mul_together.sh Eva_clip_0526_EVA01_CLIP_g_14_plus_psz14_s11B_baseline
# bash start_mul_together.sh Eva_clip_0526_EVA01_CLIP_g_14_plus_psz14_s11B_lr00_1
# bash start_mul_together.sh Eva_clip_0526_EVA01_CLIP_g_14_plus_psz14_s11B_lr0_1_bs0_50
# bash start_mul_together.sh Eva_clip_0526_EVA01_CLIP_g_14_plus_psz14_s11B_lr0_1_bs0_75
# bash start_mul_together.sh Eva_clip_0526_EVA01_CLIP_g_14_plus_psz14_s11B_lr0_1_lrv001_lrt001
# bash start_mul_together.sh Eva_clip_0526_EVA01_CLIP_g_14_plus_psz14_s11B_lr0_1
# bash start_mul_together.sh Eva_clip_0526_EVA01_CLIP_g_14_plus_psz14_s11B__lrv_00_1_lrt_0_1
# bash start_mul_together.sh Eva_clip_0526_EVA01_CLIP_g_14_plus_psz14_s11B_lrv_0_1_lrt_00_1
# bash start_mul_together.sh Eva_clip_0526_EVA01_CLIP_g_14_psz14_s11B_realnoplus

# 529
# sleep 1h
# bash start_mul_together.sh Eva_clip_0526_EVA01_CLIP_g_14_plus_psz14_s11B_baseline_lr10_warm10
# bash start_mul_together.sh Eva_clip_0526_EVA01_CLIP_g_14_plus_psz14_s11B_baseline_ep21

# 530
# sleep 4h
# bash start_mul_together.sh Eva_clip_0526_EVA01_CLIP_g_14_plus_psz14_s11B_baseline_bs0_75_step500

# 531
# bash start_mul_together.sh Eva_clip_0526_EVA01_CLIP_g_14_plus_psz14_s11B_baseline_lr50_step500
# bash start_mul_together.sh Eva_clip_0526_EVA01_CLIP_g_14_plus_psz14_s11B_baseline_lr1000_lrv10_lrt10_step500_ep15

#61
bash start_mul_together.sh L_Eva_clip_0526_EVA02_CLIP_L_14_baseline

# inspect
# /mnt/pfs/data/yckj1563/miniconda3/envs/py37_torch1_7_evaclip/bin/python inspect_warning.py  --delay 120 --gpu_mem_thr 20 --gpu_usage_thr 50 --cpu_mem_thr 50 --sleepaw 36000