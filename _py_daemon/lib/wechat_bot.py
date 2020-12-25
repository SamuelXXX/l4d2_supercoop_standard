import requests
import json

WECHAT_BOT_URL= 'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=d36233f1-3850-4c12-9861-74ce7f019d47'

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