extends Node

var max_time : int = 10
var remaining_time : int = max_time
signal updated_time

func update_time(amount):
	if amount < 0:
		for skill_resource in Global.skill_resource_list:
			skill_resource.current_cooldown = max(0,skill_resource.current_cooldown+amount)
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
