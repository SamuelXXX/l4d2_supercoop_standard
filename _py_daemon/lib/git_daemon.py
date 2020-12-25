import subprocess
import server_tag
import global_config

def bot_log_git_pull(git_pull_log):
	"""
	向微信机器人推送一条普通信息
	:return:
	"""
	from wechat_bot import bot_log

	SERVER_NAME = server_tag.SERVER_NAME
	SERVER_IP = server_tag.SERVER_IP

	msg = "\n".join(["**服务器Git Pull更新**", "**服务器编号：**" + SERVER_NAME, "**服务器IP:**" + SERVER_IP,
					 "\nGit Pull Log:\n\n" + git_pull_log])
	return bot_log(msg)


def action_git_pull():
	print(">>>Try Git Pull...")
	pull_proc = subprocess.Popen("git pull", stdout=subprocess.PIPE)
	lines = pull_proc.stdout.readlines()
	lines = [line.decode('utf-8') for line in lines]
	for line in lines:
		print(line)

	if len(lines) <= 2:
		return global_config.getfloat("GIT","GIT_PULL_FAIL_RETRY_TIME")

	on_update_received()
	bot_log_git_pull("\n".join(lines))
	return global_config.getfloat("GIT","GIT_PULL_SUCCEED_RETRY_TIME")

def on_update_received():
	server_tag.reparse_server_tags() # 有更新的话需要重新parse一次server_tags
	global_config.reparse()  # 有更新的话需要重新parse一次配置文件


if __name__ == "__main__":
	import time
	from timer import Timer

	timer_core = Timer()
	timer_core.register_timer_func("git_pull_routine", action_git_pull)

	timer_core.set_time(time.time())
	timer_core.start_timer("git_pull_routine", 0)

	while True:
		timer_core.process_all_timers(time.time())
