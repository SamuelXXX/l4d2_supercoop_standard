# 进程监控的daemon
import os
import global_config
import server_tag
SERVER_PROCESS_NAME="srcds.exe"

server_pid_dict={}

def re_launch_server_process(path):
	"""
	重启服务器，会打印bot_log
	:param path:
	:return:
	"""
	global server_pid_dict
	if path not in server_pid_dict:
		return

	from wechat_bot import bot_log
	bot_log("\n".join(["**服务器意外关闭**",
					   "**服务器编号：**" + server_tag.SERVER_NAME,
					   "**服务器IP：**" + server_tag.SERVER_IP,
					   "**服务器路径：**" + path]))

	pid_before_launch=get_running_server_pids()
	bot_log("\n".join(["**尝试重启服务器**\n"+"服务器路径："+path]))
	try:
		os.startfile(path)
	except:
		bot_log("\n".join(["**重启服务器失败！！！\n检查服务器启动路径配置**"]))
	else:
		bot_log("\n".join(["**重启服务器成功**"]))
		pid_after_launch=get_running_server_pids()
		for pid in pid_after_launch:
			if pid not in pid_before_launch:
				server_pid_dict[path] = pid
				break

def launch_server_process(path):
	"""
	正常启动服务器并记录pid
	:param path:
	:return:
	"""
	global server_pid_dict
	pid_before_launch = get_running_server_pids()
	try:
		os.startfile(path)
	except:
		pass
	else:
		pid_after_launch = get_running_server_pids()
		for pid in pid_after_launch:
			if pid not in pid_before_launch:
				server_pid_dict[path] = pid
				break

def kill_server_process(path):
	"""
	杀死进程，暂时不用
	:param pid:
	:return:
	"""
	if path not in server_pid_dict:
		return
	cmd = "tskill "+str(server_pid_dict[path])
	os.popen(cmd) # 无法杀死别人的进程，只能杀死子进程

def get_running_server_pids():
	"""
	获取当前pid的列表
	:return:
	"""
	print('>>>tasklist | findstr ' + SERVER_PROCESS_NAME)
	lines = os.popen('tasklist | findstr ' + SERVER_PROCESS_NAME).readlines()
	return [int(line.split()[1]) for line in lines]

def check_server_process():
	global server_pid_dict
	try:
		pids=get_running_server_pids()
		for path, pid in server_pid_dict.items():
			if pid not in pids:
				re_launch_server_process(path)
	except:
		print("程序错误")

def process_monitor_routine():
	check_server_process()
	return global_config.getfloat("PROC","PROC_CHECK_RUNNING_TIME")

for path in server_tag.SERVER_PATH:
	launch_server_process(path)

if __name__ == "__main__":
	import time
	from timer import Timer

	timer_core = Timer()
	timer_core.register_timer_func("proc_daemon_routine", process_monitor_routine)

	timer_core.set_time(time.time())
	timer_core.start_timer("proc_daemon_routine", 0)

	while True:
		timer_core.process_all_timers(time.time())