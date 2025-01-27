#!/usr/bin/python3
# 输入example
# /mnt/pfs/data/yckj1563/miniconda3/envs/py37_torch1_7_evaclip/bin/python inspect_warning.py --delay 120 --gpu_mem_thr 20 --gpu_usage_thr 50 --cpu_mem_thr 20 --sleepaw 3600
# 监控程序是否正常运行，报警或者自动resume程序
import smtplib
from email.mime.text import MIMEText
from email.header import Header

import GPUtil
import time
import psutil

import argparse

def email_sender(content = "Python 邮件发送测试...", subject = "Python SMTP 邮件测试"):
	# 第三方 SMTP 服务
	mail_host="smtp.qq.com"  #设置服务器
	mail_user="1576850974@qq.com"    #用户名
	mail_pass="vfthlfomlupshdbd"   #口令 

	sender = '1576850974@qq.com'   # 这里必须和上面mail_user一致
	receivers = ['1576850974@qq.com']  # 接收邮件，可设置任意其他邮箱

	# 邮件内容
	message = MIMEText(content, 'plain', 'utf-8')
	message['From'] = Header("jerry <1576850974@qq.com>")
	message['To'] =  Header(subject, 'utf-8')
	
	#  邮件标题
	message['Subject'] = Header(subject, 'utf-8')
	
	
	try:
		smtpObj = smtplib.SMTP() 
		smtpObj.connect(mail_host, 25)    # 25 为 SMTP 端口号
		smtpObj.login(mail_user,mail_pass)
		smtpObj.sendmail(sender, receivers, message.as_string())
		print ("邮件发送成功")
	except smtplib.SMTPException:
		print ("Error: 无法发送邮件")

# email_sender(content="程序运行出错", subject="程序监控情况")




def get_gpu_info():
    '''
    :return:
    '''
    Gpus = GPUtil.getGPUs()
    gpulist = []
    # GPUtil.showUtilization()
    
    # 获取多个GPU的信息，存在列表里
    for gpu in Gpus:
        # print('gpu.id:', gpu.id)
        # print('GPU总量：', gpu.memoryTotal)
        # print('GPU使用量：', gpu.memoryUsed)
        # print('gpu使用占比:', gpu.memoryUtil * 100)
        # 按GPU逐个添加信息
        gpulist.append([ gpu.id, gpu.memoryTotal/1024, gpu.memoryUsed/1024,gpu.memoryUtil * 100])

    return gpulist


def get_cpu_info():
    ''' :return:
    memtotal: 总内存
    memfree: 空闲内存
    memused: Linux: total - free,已使用内存
    mempercent: 已使用内存占比
    cpu: 各个CPU使用占比
    '''
    mem = psutil.virtual_memory()
    memtotal = mem.total
    memfree = mem.free
    mempercent = mem.percent
    memused = mem.used
    cpu = psutil.cpu_percent(percpu=True)

    return memtotal, memfree, memused, mempercent, cpu


# 主函数
def main():
    stopped_num = 10000000     # （设置一个最大获取次数，防止记录文本爆炸）
    parser = argparse.ArgumentParser(description='inspect warning')
    parser.add_argument('-d', '--delay', type=int, default=120)
    parser.add_argument('-f', '--frame_thr', type=int, default=5)
    parser.add_argument('-g', '--gpu_mem_thr', type=float, default=20)
    parser.add_argument('-u', '--gpu_usage_thr', type=float, default=50)
    parser.add_argument('-c', '--cpu_mem_thr', type=float, default=20)
    parser.add_argument('-s', '--sleepaw', type=int, default=3600)

    args = parser.parse_args()
    delay = args.delay  # 采样信息时间间隔 s
    frame_thr = args.frame_thr # 历史帧数累计平均
    gpu_mem_thr = args.gpu_mem_thr # 平均小于这个会报警，单位G
    gpu_usage_thr = args.gpu_usage_thr # 平均小于这个会报警,单位百分比
    cpu_mem_thr = args.cpu_mem_thr # 平均小于这个会报警, 单位g
    sleepaw = args.sleepaw # 发送邮件后的sleep时间

    times = 0
    list_inspect_info = [] # 保存gpumem gpuusage cpumem
    warning_times = 0
    while True:
        # 最大循环次数
        if times < stopped_num:
            # 打印当前时间
            t_c = time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time()))
            # 获取CPU信息
            cpu_info = get_cpu_info()
            # 获取GPU信息
            gpu_info = get_gpu_info()
            # 添加时间间隙
            # 打印监控信息
            average_mem = 0
            average_usage = 0
            print(t_c)
            for gpu_info_ in gpu_info:
                average_mem += gpu_info_[2]
                average_usage += gpu_info_[3]
                print("gpu id:%d, total mem:%.3f, used mem:%.3f, usage%.3f"%(gpu_info_[0],gpu_info_[1],gpu_info_[2],gpu_info_[3]))
            average_mem = average_mem/len(gpu_info)
            average_usage = average_usage/len(gpu_info)
            print("\ngpu average used mem:%.3f,gpu average usage:%.3f"%(average_mem,average_usage))
            
            print("\nused mem percent:%.3f "%cpu_info[3])
            list_inspect_info.append([average_mem, average_usage, cpu_info[3]])
            time.sleep(delay)

            # 判断程序是否挂掉,用滑动窗口累计
            average_gpumem_warning = 0
            average_usage_warning = 0
            average_cpumem_warning = 0
            if len(list_inspect_info) > frame_thr:
                # 获取过去frame_thr帧数的平均值
                for list_inspect_info_ in list_inspect_info[-frame_thr:]:
                     average_gpumem_warning += list_inspect_info_[0]
                     average_usage_warning += list_inspect_info_[1]
                     average_cpumem_warning += list_inspect_info_[2]
                average_gpumem_warning = average_gpumem_warning/frame_thr
                average_usage_warning = average_usage_warning/frame_thr
                average_cpumem_warning = average_cpumem_warning/frame_thr
                
                warning_state = False
                warning_str = ""
                if average_gpumem_warning < gpu_mem_thr:
                     warning_state = True
                     warning_str += "average gpumem is %f G, lower than %f G, please check\n\n"%(average_gpumem_warning,gpu_mem_thr)
                if average_usage_warning < gpu_usage_thr:
                     warning_state = True
                     warning_str += "average gpu usage is %f percent, lower than %f percent, please check\n\n"%(average_usage_warning,gpu_usage_thr)
                if average_cpumem_warning < cpu_mem_thr:
                     warning_state = True
                     warning_str += "average cpumem is %f G, lower than %f G, please check\n\n"%(average_cpumem_warning,cpu_mem_thr)
                if warning_state:
                     warning_times += 1
                # 达到特定帧数才开始发送邮件，并且发完sleep一段时间
                if warning_state and warning_times >= 2:
                    email_sender(content=warning_str, subject="训练完成或多机训练终止")
                    warning_times = 0
                    time.sleep(sleepaw)
            times += 1
        else:
            break


if __name__ == '__main__':
    main()
