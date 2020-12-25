import sys
sys.path.insert(0,"./lib")

import git_daemon
import proc_daemon
import time
from timer import Timer

if __name__ == "__main__":

	timer_core = Timer()
	timer_core.register_timer_func("git_daemon_routine", git_daemon.action_git_pull)
	timer_core.register_timer_func("proc_daemon_routine", proc_daemon.process_monitor_routine)

	timer_core.set_time(time.time())
	timer_core.start_timer("git_daemon_routine", 0)
	timer_core.start_timer("proc_daemon_routine", 0)

	while True:
		timer_core.process_all_timers(time.time())
