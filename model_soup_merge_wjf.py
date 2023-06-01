# 运行命令:/mnt/pfs/data/yckj1563/miniconda3/envs/py37_torch1_7_evaclip/bin/python model_soup_merge_wjf.py
import torch    
import os  
# 不使用贪婪，手动指定模型
def uniform_model_soup():
    model_paths = ["pretrained/EVA01_CLIP_g_14_psz14_s11B.pt", \
                "EVA-CLIP/rei/logs/2023_05_26-13_04_18-model_EVA01-CLIP-g-14-lr_0.00034-b_2176-j_8-p_amp_bf16/checkpoints/epoch_7.pt", \
                "EVA-CLIP/rei/logs/2023_05_29-13_12_47-model_EVA01-CLIP-g-14-lr_0.0034-b_2176-j_8-p_amp_bf16/checkpoints/epoch_7.pt", \
                "EVA-CLIP/rei/logs/2023_05_30-15_27_01-model_EVA01-CLIP-g-14-lr_0.00034-b_1632-j_8-p_amp_bf16/checkpoints/epoch_7.pt", \
                "EVA-CLIP/rei/logs/2023_05_31-15_09_35-model_EVA01-CLIP-g-14-lr_0.34-b_2176-j_8-p_amp_bf16/checkpoints/epoch_7.pt", \
                ]
    NUM_MODELS = len(model_paths)
    state_dict0 = None
    for j, model_path in enumerate(model_paths):
        print(f'Adding model {j} of  to uniform soup.')

        assert os.path.exists(model_path)
        state_dict = torch.load(model_path, map_location=torch.device('cpu'))
        if "state_dict" in state_dict.keys():
            state_dict = state_dict['state_dict']
        if j == 0:
            # 只合并第一个文件有的key
            state_dict_base_kyes = state_dict.keys()
            uniform_soup = {k : v * (1./NUM_MODELS) for k, v in state_dict.items()}
        else:
            uniform_soup = {k : v * (1./NUM_MODELS) + uniform_soup[k] for k, v in state_dict.items()  if k in state_dict_base_kyes}
    torch.save(uniform_soup, "model_soup_output.pt")
def greedy_soup():
    pass
if __name__=="__main__":
    uniform_model_soup()