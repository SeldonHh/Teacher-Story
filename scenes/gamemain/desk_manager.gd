extends Node

var desks := []

func _ready() -> void:
	ManagerList.desk_manager = self

func assign_student_to_another_desk(student:Student,target_desk:Desk):
	var other_student = null
	if target_desk.student != null:
		other_student = target_desk.student
	for desk in desks:
		if desk.student == student:
			desk.student = other_student
			desk.play_pouf()
	target_desk.student = student
	target_desk.play_pouf()

func get_room_desk_list():
	var room_desk = []
	for desk in desks:
		if desk.matiere == ManagerList.mission_manager.current_mission_resource.matiere:
			room_desk.append(desk)
	return room_desk
