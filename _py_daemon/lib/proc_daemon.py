# 进程监控的daemon
import os
import global_config
import server_tag
SERVER_PROCESS_NAME="srcds.exe"

server_pid_list=[]

def launch_server_process():
	from wechat_bot import bot_log
	bot_log("\n".join(["**尝试重启服务器**"]))
	try:
		os.startfile(server_tag.SERVER_PATH)
	except:
		bot_log("\n".join(["**重启服务器失败！！！\n检查服务器启动路径配置**"]))
	else:
		bot_log("\n".join(["**重启服务器成功**"]))

def check_server_process():
	from wechat_bot import bot_log
	import server_tag
	try:
		print('>>>tasklist | findstr ' + SERVER_PROCESS_NAME)
		lines = os.popen('tasklist | findstr ' + SERVER_PROCESS_NAME).readlines()
		global server_pid_list
		if len(lines)>len(server_pid_list): # 有新增的服务器进程
			server_pid_list=[int(line.split()[1]) for line in lines]
			bot_log("\n".join(["**新服务器启动**",
							   "**服务器编号：**"+server_tag.SERVER_NAME,
							   "**服务器IP：**"+server_tag.SERVER_IP,
							   "**当前服务器总数：**"+str(len(server_pid_list))]))

		elif len(lines)<len(server_pid_list): # 有服务器意外关闭
			server_pid_list=[int(line.split()[1]) for line in lines]
			bot_log("\n".join(["**服务器意外关闭！！！！！**",
							   "**服务器编号：**" + server_tag.SERVER_NAME,
							   "**服务器IP：**" + server_tag.SERVER_IP,
							  "**当前服务器总数：**" + str(len(server_pid_list))]))
			launch_server_process()

		else:
			pass
		print(server_pid_list)

	except:
		print("程序错误")
		return False

def process_monitor_routine():
	check_server_process()
	return global_config.getfloat("PROC","PROC_CHECK_RUNNING_TIME")

if __name__ == "__main__":
	import time
	from timer import Timer

	timer_core = Timer()
	timer_core.register_timer_func("proc_daemon_routine", process_monitor_routine)

	timer_core.set_time(time.time())
	timer_core.start_timer("proc_daemon_routine", 0)

	while True:
		timer_core.process_all_timers(time.time())