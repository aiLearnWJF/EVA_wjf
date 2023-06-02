# 运行命令:/mnt/pfs/data/yckj1563/miniconda3/envs/py37_torch1_7_evaclip/bin/python model_soup_merge_wjf.py
import torch    
import os  
import glob
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
    # 如果给的是pt格式，直接加入，如果给的目录，在该目录下搜索添加pt,有先后顺序
    base_prefix = "/mnt/pfs/data/yckj1563/projects/EVA_wjf/"
    model_paths = ["pretrained/EVA01_CLIP_g_14_psz14_s11B.pt", \
            "EVA-CLIP/rei/logs/2023_05_26-13_04_18-model_EVA01-CLIP-g-14-lr_0.00034-b_2176-j_8-p_amp_bf16/checkpoints", \
            "EVA-CLIP/rei/logs/2023_05_29-13_12_47-model_EVA01-CLIP-g-14-lr_0.0034-b_2176-j_8-p_amp_bf16/checkpoints", \
            "EVA-CLIP/rei/logs/2023_05_30-15_27_01-model_EVA01-CLIP-g-14-lr_0.00034-b_1632-j_8-p_amp_bf16/checkpoints", \
            "EVA-CLIP/rei/logs/2023_05_31-15_09_35-model_EVA01-CLIP-g-14-lr_0.34-b_2176-j_8-p_amp_bf16/checkpoints", \
            ]
    model_list = []
    for model_path in model_paths:
        if model_path.split("/")[-1][-3:] == ".pt":
            model_list.append(base_prefix + model_path)
        else:
            sub_model_path = glob.glob(base_prefix + model_path + "/*[3-9].pt")
            sub_model_path.sort(key=lambda x: int(x[:-3].split("_")[-1]))
            if len(sub_model_path) >0 :
                model_list = model_list + sub_model_path
    print("total model list lenth is : %d ,contents is:"%len(model_list))
    for i in model_list:
        print(i)

    greedy_soup_ingredients = [model_list[0]]
    greedy_soup_params = torch.load(model_list[0], map_location=torch.device('cpu'))
    if "state_dict" in greedy_soup_params.keys():
            greedy_soup_params = greedy_soup_params['state_dict']
    best_val_acc_so_far = 78.5

    for i in range(1, len(model_list)):
        print(f'Testing model {i} ')

        # Get the potential greedy soup, which consists of the greedy soup with the new model added.
        new_ingredient_params = torch.load(i, map_location=torch.device('cpu'))
        if "state_dict" in new_ingredient_params.keys():
            new_ingredient_params = new_ingredient_params['state_dict']

        num_ingredients = len(greedy_soup_ingredients)
        potential_greedy_soup_params = {
            k : greedy_soup_params[k].clone() * (num_ingredients / (num_ingredients + 1.)) + 
                new_ingredient_params[k].clone() * (1. / (num_ingredients + 1))
            for k in new_ingredient_params if k in state_dict_base_kyes
        }

        # Run the potential greedy soup on the held-out val set.
        model = get_model_from_sd(potential_greedy_soup_params, base_model)
        held_out_val_accuracy = test_model_on_dataset(model, held_out_val_set)

        # If accuracy on the held-out val set increases, add the new model to the greedy soup.
        print(f'Potential greedy soup val acc {held_out_val_accuracy}, best so far {best_val_acc_so_far}.')
        if held_out_val_accuracy > best_val_acc_so_far:
            greedy_soup_ingredients.append(sorted_models[i])
            best_val_acc_so_far = held_out_val_accuracy
            greedy_soup_params = potential_greedy_soup_params
            print(f'Adding to soup. New soup is {greedy_soup_ingredients}')


    print("end")
if __name__=="__main__":
    # uniform_model_soup()
    greedy_soup()