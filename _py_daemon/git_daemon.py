import subprocess
import time
from timer import Timer
import requests
import json

FETCH_DELAY=60.0
PULL_DELAY=600.0

with open("server_tag.txt") as f:
	tags=f.readlines()
	SERVER_NAME=tags[0].replace('\n','')
	SERVER_IP=tags[1].replace('\n','')

WECHAT_BOT_URL= 'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=d49629b9-6e79-41dc-8d2b-ccb6d85228f8'

def bot_log(msg):
	"""
	向微信机器人推送一条普通信息
	:return:
	"""
	request_headers = {'Content-Type': 'application/json'}
	d = {
		"msgtype": "markdown",
		"markdown": {
			"content": msg
		}
	}
	r = requests.post(WECHAT_BOT_URL, headers=request_headers, data=json.dumps(d))
	return r.text

def action_git_pull():
	print(">>>Start Git Fetch...")
	fetch_proc = subprocess.Popen("git fetch", stdout=subprocess.PIPE)
	lines = fetch_proc.stdout.readlines()
	if len(lines)==0:
		print("Nothing To Pull...\n")
		return FETCH_DELAY
	else:
		for line in lines:
			print(line.decode('utf-8'))
		print(">>>Start Git Pull...")
		pull_proc = subprocess.Popen("git pull", stdout=subprocess.PIPE)
		lines = pull_proc.stdout.readlines()
		for line in lines:
			print(line.decode('utf-8'))
		return PULL_DELAY

if __name__=="__main__":
	print(SERVER_NAME)
	print(SERVER_IP)

	timer_core=Timer()
	timer_core.register_timer_func("git_pull_routine",action_git_pull)

	timer_core.set_time(time.time())
	timer_core.start_timer("git_pull_routine",0)

	while True:
		timer_core.process_all_timers(time.time())



