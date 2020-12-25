class Timer(object):
	# region Timer Register
	__handler_dict = None

	def register_timer_func(self, name, func):
		"""
		注册一个Timer function函数，将名称和函数绑定到一个字典当中
		:param name: Timer的名称
		:param func: Timer的函数体
		:return:
		"""
		if self.__handler_dict is None:
			self.__handler_dict = {}
		self.__handler_dict[name] = func
	# endregion

	# region Timer Context
	__in_timer_context = False
	def __enter__(self):
		self.__in_timer_context = True

	def __exit__(self, exc_type, exc_val, exc_tb):
		self.__in_timer_context = False
	# endregion

	# region Timer Processing
	__current_time = None # 保证先写后读
	# 都是只在process中使用的变量，用来保存在timer中创建的和timer相关的命令
	__cancelled_timers = None
	__force_clear_all_timers = False

	def set_time(self, time):
		"""
		暂时设置一个时间
		通常在Timer函数体外部调用start_timer时调用
		:param time:
		:return:
		"""
		if self.__current_time is not None: # 只在外部调用，不能再Timer Func内部调用
			return
		self.__current_time = time

	def process_all_timers(self, time):
		"""
		Timer主处理函数
		:param time: 当前时间
		:return:
		"""
		if self.running_timers is None or self.__running_timers_is_empty():
			return

		self.__current_time = time

		self.__reset_temp_added_timers()
		self.__cancelled_timers = []
		self.__force_clear_all_timers = False

		for timer_id, info in self.__running_timers_items():
			if timer_id in self.__cancelled_timers: # 已经删除的timers就不用继续处理
				continue

			func_name=info[0]
			tick_time=info[1]
			func=self.__handler_dict[func_name]

			if self.__current_time >= tick_time:
				with self:
					ret=func()

				if self.__force_clear_all_timers: # 如果发现了强制清空的命令，就直接停用停止迭代
					break

				if ret is None:
					self.__cancelled_timers.append(timer_id)
				else:
					info[1] = self.__current_time + ret

		if self.__force_clear_all_timers:
			self.__reset_running_timers()

		self.__update_running_timers() # 将执行中创建的timer加入
		for i in self.__cancelled_timers: # 将执行过程中停用的timer全部停用掉
			self.__del_running_timer(i)
		self.__current_time = None
	# endregion

	# region __Internal_Methods
	# 考虑到内置字典容器的不保序特性，running_timers可能用别的自定义字典容器替代，所以要将这里集中封装下接口
	# __added_timers同样也是字典类容器，需要使用同样的方式对待
	running_timers = None
	__added_timers = None # 只在主Tick中使用的暂存变量，并且是先清空再使用
	def __reset_running_timers(self):
		self.running_timers={}

	def __add_running_timer(self, timer_id, name, time):
		if self.running_timers is None:
			self.__reset_running_timers()
		self.running_timers[timer_id] = [name, time]

	def __del_running_timer(self, timer_id):
		if self.__contain_running_timers(timer_id):
			del self.running_timers[timer_id]

	def __update_running_timers(self):
		self.running_timers.update(self.__added_timers)

	def __contain_running_timers(self, timer_id):
		return timer_id in self.running_timers

	def __running_timers_items(self):
		return self.running_timers.items()

	def __running_timers_is_empty(self):
		return len(self.running_timers) == 0

	def __reset_temp_added_timers(self):
		self.__added_timers = {}

	def __add_temp_added_timers(self, timer_id, name, time):
		self.__added_timers[timer_id] = [name, time]
	# endregion

	# region Timer Management
	assigned_timer_id = 0

	def start_timer(self, name, first_tick_delay):
		"""
		开启一个Timer
		在Timer函数内部使用没有任何限制
		在Timer函数之外使用的话，使用前一定要先调用set_time来确定一个基准时间，否则会报错
		:param name: Timer的名称
		:param first_tick_delay:
		:return:
		"""
		if self.running_timers is None:
			self.__reset_running_timers()

		assert name in self.__handler_dict

		timer_id = self.assigned_timer_id
		if self.__in_timer_context:
			self.__add_temp_added_timers(timer_id, name, self.__current_time + first_tick_delay)
			self.assigned_timer_id += 1
			return timer_id

		self.__add_running_timer(timer_id, name, self.__current_time + first_tick_delay)
		self.assigned_timer_id+=1
		return timer_id

	def stop_timer(self, timer_id):
		"""
		根据Timer ID停用一个Timer
		:param timer_id:
		:return:
		"""
		if self.__in_timer_context:
			self.__cancelled_timers.append(timer_id)
			return

		if self.running_timers is None or not self.__contain_running_timers(timer_id):
			return

		self.__del_running_timer(timer_id)

	def stop_timers_by_name(self,name):
		"""
		根据Timer的名称停用Timer
		:param name: 被停用的Timers的名称
		:return:
		"""
		timer_id_set=[timer_id for timer_id,info in self.__running_timers_items() if info[0] == name]
		for timer_id in timer_id_set:
			self.stop_timer(timer_id)

	def stop_all_timers(self):
		"""
		停止所有正在运行的Timer
		:return:
		"""
		if self.__in_timer_context:
			self.__force_clear_all_timers = True
			self.__reset_temp_added_timers() # 将在timer中创建的新的timer也清空掉
			return

		self.__reset_running_timers()
		# endregion
