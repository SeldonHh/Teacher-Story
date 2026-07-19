extends Node

var max_time : int = 10
var remaining_time : int = max_time
signal updated_time
var healing_time: Array[int] = []

func update_time(amount):
	if amount < 0:
		for skill_resource in Global.skill_resource_list + Global.chouchou_resource_list + Global.special_skill_list:
			skill_resource.current_cooldown = max(0,skill_resource.current_cooldown+amount)
		for timer in healing_time:
			timer -= 1
			if timer <= 0:
				healing_time.erase(timer)
			ManagerList.teacher_manager.teacher_life += 1
	remaining_time += amount
	if remaining_time <= 0:
		stop_class()
	updated_time.emit()

func stop_class():
	%StudentManager.reset_all_students()
	%TeacherManager.reset_life()
	remaining_time = max_time
	

func _ready() -> void:
	ManagerList.timer_manager = self
