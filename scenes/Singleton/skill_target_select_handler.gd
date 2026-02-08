extends Node

var groupdesks := []
var students := []

signal groupdesk_pressed(desk)

signal student_pressed(student)

##Make the player select a table, then Returns an array of students at the selected groupdesk
func select_groupdesk()-> Array:
	for student in students:
		student.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	
	for groupdesk in groupdesks:
		groupdesk.disabled = false
		groupdesk.mouse_filter = Control.MOUSE_FILTER_STOP
		groupdesk.pressed.connect(groupdesk_pressed.emit.bind(groupdesk))
		for desk in groupdesk.get_children():
			if desk is Desk:
				desk.self_modulate = Color(1.0, 1.0, 0.0, 1.0)
		
		
	var selected_groupdesk = await groupdesk_pressed
	var selected_students = []
	for desk in selected_groupdesk.get_children():
		if desk is Desk:
			selected_students.append(desk.student)
	
	for groupdesk in groupdesks:
		groupdesk.pressed.disconnect(groupdesk_pressed.emit)
		groupdesk.disabled = true
		groupdesk.mouse_filter = Control.MOUSE_FILTER_IGNORE
		for desk in groupdesk.get_children():
			if desk is Desk:
				desk.self_modulate = Color.WHITE
	
	for student in students:
		student.mouse_filter = Control.MOUSE_FILTER_STOP
		
	return selected_students

func select_student() -> Array :
	for student in students:
		if student.untouchable == false:
			student.pressed.connect(student_pressed.emit.bind(student))
			student.modulate = Color(1.0, 1.0, 0.0, 1.0)

	var selected_student = await student_pressed
	for student in students:
		if student.untouchable == false:
			student.pressed.disconnect(student_pressed.emit)
			student.modulate = Color.WHITE
	var array_selected_student = [selected_student]
	return array_selected_student
