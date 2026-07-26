extends Node

var max_time : int = 12
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
			ManagerList.teacher_manager.damage_teacher(-1) #heals by 1
	for student in ManagerList.student_manager.students:
		student.time_passed()
	remaining_time += amount
	if remaining_time <= 0:
		stop_class()
	updated_time.emit()

func stop_class():
	ManagerList.student_manager.reset_class()
	remaining_time = max_time
	Global.bottom_panel.reset_chouchou()
	

func _ready() -> void:
	ManagerList.timer_manager = self
