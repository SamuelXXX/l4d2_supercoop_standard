# 进程监控的daemon
import os
import global_config
import server_tag
import subprocess

SERVER_PROCESS_NAME="srcds.exe"

server_proc_dict={}

# region Server Operations
def restart_server_process(cmd):
	"""
	重启服务器，会打印bot_log
	:param cmd:
	:return:
	"""
	from wechat_bot import bot_log
	bot_log("\n".join(["**服务器意外关闭**",
					   "**服务器编号：**" + server_tag.SERVER_NAME,
					   "**服务器IP：**" + server_tag.SERVER_IP]))

	bot_log("\n".join(["**尝试重启服务器**\n" +"服务器启动命令：" + cmd]))

	restart_succeed = start_server_process(cmd)

	if restart_succeed:
		bot_log("\n".join(["**重启服务器成功**"]))
	else:
		bot_log("\n".join(["**重启服务器失败！！！\n检查服务器启动路径配置**"]))

def start_server_process(cmd):
	"""
	正常启动服务器并记录pid
	:param cmd:
	:return:
	"""
	global server_proc_dict
	proc=None
	try:
		proc=subprocess.Popen(cmd)
	except:
		return False
	else:
		server_proc_dict[cmd] = proc
		return True

def kill_server_process(cmd):
	"""
	杀死进程，暂时不用
	:param cmd:
	:return:
	"""
	if cmd not in server_proc_dict:
		return
	server_proc_dict[cmd].kill()

def kill_all_server_process():
	"""
	杀死所有的服务器进程
	:return:
	"""
	for proc in server_proc_dict.values():
		proc.kill()
# endregion

# region Routines
def check_server_proc_running(proc):
	lines = os.popen('tasklist | findstr ' + SERVER_PROCESS_NAME).readlines()
	server_pids=[int(line.split()[1]) for line in lines]
	return proc.pid in server_pids

def check_server_process():
	global server_proc_dict
	try:
		for cmd, proc in server_proc_dict.items():
			if not check_server_proc_running(proc):
				restart_server_process(cmd)
	except:
		print("程序错误")

def process_monitor_routine():
	check_server_process()
	return global_config.getfloat("PROC","PROC_CHECK_RUNNING_TIME")
# endregion

for cmd in server_tag.SERVER_CMD:
	print("启动服务器：%s"%cmd)
	start_server_process(cmd)

if __name__ == "__main__":
	import time
	from timer import Timer

	timer_core = Timer()
	timer_core.register_timer_func("proc_daemon_routine", process_monitor_routine)

	timer_core.set_time(time.time())
	timer_core.start_timer("proc_daemon_routine", 0)

	while True:
		timer_core.process_all_timers(time.time())