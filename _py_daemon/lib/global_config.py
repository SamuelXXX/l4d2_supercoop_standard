import configparser

global_config_path="./daemon_config.ini"
parser=configparser.ConfigParser()
parser.read(global_config_path)

def reparse():
	parser.read(global_config_path)

def getfloat(section_name,key):
	return parser.getfloat(section_name,key)

def getbool(section_name,key):
	return parser.getboolean(section_name,key)
