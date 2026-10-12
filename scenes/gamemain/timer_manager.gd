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
			ManagerList.teacher_manager.damage_teacher(-1) #heals by 1
	for student in ManagerList.student_manager.students:
		student.time_passed()
	remaining_time += amount
	updated_time.emit()
	if remaining_time <= 0:
		stop_class()

func start_classtime():
	remaining_time = max_time

func stop_class():
	for skill_resource in Global.skill_resource_list + Global.chouchou_resource_list + Global.special_skill_list:
		skill_resource.current_cooldown = 0
	healing_time.clear()
	ManagerList.student_manager.reset_class()
	Global.bottom_panel.reset_chouchou()
	Global.bottom_panel.set_skills_rest_mode()
	remaining_time = 1
	if randf() <= .5: %GameSpace.set_camera_to_home()
	else: %GameSpace.set_camera_to_teacher_room() #TODO: CHANGE THIS
	ManagerList.mission_manager.current_class_count += 1

func _ready() -> void:
	ManagerList.timer_manager = self
