SERVER_NAME="Invalid Server Name"
SERVER_IP="Invalid IP"
SERVER_PATH=[]

def reparse_server_tags():
	with open("server_tag.txt") as f:
		global SERVER_NAME
		global SERVER_IP
		global SERVER_PATH
		tags=f.readlines()
		SERVER_NAME = tags[0].replace('\n','')
		SERVER_IP= tags[1].replace('\n','')
		SERVER_PATH = [path.replace('\n','') for path in tags[2:]]

reparse_server_tags() # 导入的时候解析一次server_tag