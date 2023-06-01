from matplotlib import pyplot as plt
import random
import argparse


# 获取要绘制指标的列表
def get_list_dst(log_path = [""], list_index_name = [], split_char = [], strip_char = [], \
                 coff_index = [], line_coff = [], ylims = [], xlims = [], legend_labels = [], print_tb = 0, print_tb_max_rows = 9):

    if print_tb:
        # import pdb;pdb.set_trace()
        tb = PrettyTable([])
    markers=[',', '+', '.', 'o', '*', 'v', '|', '>']
    linestyles=["solid", "dotted", "dashed" , "dashdot", (0, (3, 1, 1, 1)), (0, (3, 1, 1, 1, 1, 1))]
    for log_path_index,log_path_i in enumerate(log_path):
        # 与list_index_name一一对应，保存全部value
        list_index_value = [[] for i in range(len(list_index_name))]

        log_contexts = open(log_path_i, 'r').readlines()
        for line_idx,lines in enumerate(log_contexts):
            for index_idx, index_name in enumerate(list_index_name):
                lines_start = lines.find(index_name)
                if lines_start != -1:
                    try:
                        # if index_name == "LR: ":
                        #     import pdb;pdb.set_trace()
                        # 表示换行才能找到对应的值，比如mAP
                        if line_coff[index_idx] > 0:
                            # 从头开始划分查找
                            lines_start = 0
                        #  这里的提取策略是：先保留关键词以后的内容-》划分出关键词所在数字,用split_char -> 根据coff_index选取索引,一般是0或者1 -》一定程度去不掉数字前后内容，可能没和indexname分开，再次去掉indexname -> 去掉数字前后空格，用strip_char
                        float_value = float(log_contexts[line_idx + line_coff[index_idx]][lines_start:].split(split_char[index_idx])[coff_index[index_idx]].strip(index_name).strip(strip_char[index_idx]))
                        list_index_value[index_idx].append(float_value)
                    except Exception:
                        pass
        # import pdb;pdb.set_trace()
        if len(legend_labels) == len(log_path):
            # 用指定输入的名字作为legend
            label_legend = legend_labels[log_path_index]
        else:
            # 用文件名作为legend
            label_legend = log_path_i.split("/")[-1]
        
        plot_list(list_index_value, list_index_name, ylims, xlims, makers = random.choice(markers), linestyles = random.choice(linestyles), label = label_legend, title = list_index_name)
        if print_tb:
            # 手动设置每一列的最大长度，不包括标题，不足补足，多余的截断
            max_cols = print_tb_max_rows
            # import pdb;pdb.set_trace()
            # 对不同标题循环，如 mAP和rank-1两个指标
            for index_name_idx,index_name_ in enumerate(list_index_name):
                print(index_name_idx)
                tb_col_list = list_index_value[index_name_idx]
                tb_col_list_len = len(tb_col_list)
                if tb_col_list_len >= max_cols:
                    tb_col_list = tb_col_list[:max_cols]
                else:
                    tb_col_list = tb_col_list + ["-" for tmpi in range(max_cols - tb_col_list_len)]
                tb.add_column(label_legend+"_"+index_name_, tb_col_list)
                # tb.add_column(label_legend,list_index_value[1])
                tb.set_style(MARKDOWN)
                text=tb.get_string()      #保存表格
            print(tb.get_string())    #输出表格
    plt.savefig("log_plot.jpg",bbox_inches ='tight')

def plot_list(list_dst = [],list_type = [], ylims = [], xlims = [],makers = '^',linestyles = "solid", label = "", title = ""):
    NUMS = len(list_type)
    plt.figure(0,figsize=(8,6*NUMS))
    for i in range(NUMS):
        plt.subplot(NUMS,1,i+1)
        # 坐标范围设置
        ylim1 = float(ylims[i].split("-")[0])
        ylim2 = float(ylims[i].split("-")[1])
        if not(ylim1 ==0 and ylim2 == 0):
            plt.ylim([ylim1, ylim2])
        xlim1 = float(xlims[i].split("-")[0])
        xlim2 = float(xlims[i].split("-")[1])
        if not(xlim1 ==0 and ylim2 == 0):
            plt.xlim([xlim1, xlim2])
        plt.plot(range(len(list_dst[i])), list_dst[i], marker=makers, linestyle=linestyles, label = label)
        plt.title(title[i])

        plt.legend(loc = 'best', fontsize=10)


if __name__=="__main__":
    parser = argparse.ArgumentParser(description='plot curve')
    parser.add_argument('-p', '--log_path', nargs='+',default=["logs/nonmotor/resnest_wjfPubExp_xj2t_1_2_3_4_5_6_reduction_0826_f1000/log.txt"])
    parser.add_argument('-i', '--index', type=str, default="lr,total_loss")
    parser.add_argument('-s', '--spilt_char', type=str, default=" , ")
    parser.add_argument('-t', '--strip_char', type=str, default=" ")
    parser.add_argument('-c', '--coff_index', type=str, default="1,1")
    parser.add_argument('-l', '--line_coff', type=str, default="0,0")
    parser.add_argument('-y', '--ylims', type=str, default="0-1,0-1")
    parser.add_argument('-x', '--xlims', type=str, default="0-10,0-10")
    parser.add_argument('-e', '--legend_labels', type=str, default=[])
    parser.add_argument('-tb', '--print_tb', type=int, default=0)
    parser.add_argument('-tc', '--print_tb_max_rows', type=int, default=9)
    args = parser.parse_args()

    # 下面几个变量均为一一对应
    # 表示要检索的指标关键词,如 mAP,lr
    list_index_name = args.index.split(",")
    # 表示分割的字符，用来去掉前后没用的其它数据
    split_char =  args.spilt_char.split(",")
    # 表示前后的多余符号，一般为空格，注意用 - 隔开
    strip_char =  args.strip_char.split("-")
    # 表示按照前一步分割后的目标的索引号，如果是同行，从关键词索引往后，如果不是同行，从0列开始算
    coff_index =  [int(i) for i in args.coff_index.split(",")]
    # 表示是否同行，0表示目标在关键词同行，其它表示偏移的行数
    line_coff = [int(i) for i in args.line_coff.split(",")]
    # ylims,如果不需要设置，用0-0设置就行
    ylims = [str(i) for i in args.ylims.split(",")]
    # xlims,如果不需要设置，用0-0设置就行
    xlims = [str(i) for i in args.xlims.split(",")]
    # specific_label,画图的legend设置，只有长度和log_path一致才会用，否则直接用log_path
    legend_labels = [str(i) for i in args.legend_labels.split(",")]
    # 是否打印表格
    print_tb = args.print_tb
    if print_tb:
        from prettytable import MARKDOWN,PrettyTable
    # 打印表格的最多rows，也就是最多打印多少ep,多的切除，少的补空
    print_tb_max_rows = args.print_tb_max_rows
    # 传入多个值的列表，必须格式一致
    get_list_dst(args.log_path, list_index_name, split_char, strip_char, \
                 coff_index, line_coff, ylims, xlims, legend_labels, print_tb, print_tb_max_rows)
