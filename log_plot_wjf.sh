# eva log, inputs type: list
# /mnt/pfs/data/yckj1563/miniconda3/envs/py37_torch1_7_evaclip/bin/python log_plot_wjf.py \
#     --log_path  baiduyun/outputs/Eva_clip_0526_EVA01_CLIP_g_14_plus_psz14_s11B_baseline_0.log \
#         baiduyun/outputs/Eva_clip_0526_EVA01_CLIP_g_14_plus_psz14_s11B_lr00_1_0.log \
#         baiduyun/outputs/Eva_clip_0526_EVA01_CLIP_g_14_plus_psz14_s11B_lr0_1_bs0_50_0.log \
#         baiduyun/outputs/Eva_clip_0526_EVA01_CLIP_g_14_plus_psz14_s11B_lr0_1_bs0_75_0.log \
#         baiduyun/outputs/Eva_clip_0526_EVA01_CLIP_g_14_plus_psz14_s11B_lr0_1_lrv001_lrt001_0.log \
#         baiduyun/outputs/Eva_clip_0526_EVA01_CLIP_g_14_plus_psz14_s11B_lr0_1_0.log \
#         baiduyun/outputs/Eva_clip_0526_EVA01_CLIP_g_14_plus_psz14_s11B__lrv_00_1_lrt_0_1_0.log \
#         baiduyun/outputs/Eva_clip_0526_EVA01_CLIP_g_14_plus_psz14_s11B_lrv_0_1_lrt_00_1_0.log \
#         baiduyun/outputs/Eva_clip_0526_EVA01_CLIP_g_14_plus_psz14_s11B_baseline_lr10_warm10.log \
#     --index "imagenet-zeroshot-val-top1:,imagenet-zeroshot-val-top5,Loss:" \
#     --spilt_char "	, , " \
#     --strip_char " - - " \
#     --coff_index "0,1,1" \
#     --line_coff "0,0,0" \
#     --ylims "0.5-1,0-1,0-4"

# 0530 test
/mnt/pfs/data/yckj1563/miniconda3/envs/py37_torch1_7_evaclip/bin/python log_plot_wjf.py \
    --log_path  baiduyun/test_log/1.log \
        baiduyun/test_log/2.log \
        baiduyun/test_log/3.log \
        baiduyun/test_log/4.log \
        baiduyun/test_log/5.log \
        baiduyun/test_log/6.log \
        baiduyun/test_log/7.log \
        baiduyun/test_log/8.log \
        baiduyun/test_log/Eva_clip_0526_EVA01_CLIP_g_14_plus_psz14_s11B_baseline_lr10_warm10_0_test.log \
        baiduyun/outputs/Eva_clip_0526_EVA01_CLIP_g_14_plus_psz14_s11B_baseline_bs0_75_step500_0.log \
    --index "imagenet-zeroshot-val-top1:,imagenet-zeroshot-val-top5" \
    --spilt_char "	, " \
    --strip_char " - " \
    --coff_index "0,1" \
    --line_coff "0,0" \
    --ylims "0.78-0.79,0.95-0.96" \
    --legend_labels "baseline,lr00_1,lr0_1_bs0_50,lr0_1_bs0_75,lr0_1_lrv001_lrt001,lr0_1,lrv_00_1_lrt_0_1,lrv_0_1_lrt_00_1,lr10_warm10_0_test,bs0_75_step500" \
    --print_tb 1

# lr
# /mnt/pfs/data/yckj1563/miniconda3/envs/py37_torch1_7_evaclip/bin/python log_plot_wjf.py \
#     --log_path baiduyun/outputs/Eva_clip_0526_EVA01_CLIP_g_14_plus_psz14_s11B_baseline_bs0_75_step500_0.log \
#     --index "imagenet-zeroshot-val-top1:,imagenet-zeroshot-val-top5,LR_visual: " \
#     --spilt_char "	, , " \
#     --strip_char " - - " \
#     --coff_index "0,1,2" \
#     --line_coff "0,0,0" \
#     --ylims "0-0,0-0,0-0" \
#     --legend_labels "bs0_75_step500" \
#     --print_tb 0