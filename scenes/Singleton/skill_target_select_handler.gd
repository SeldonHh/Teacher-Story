extends Node

var groupdesks := []
var students := []

signal groupdesk_pressed(desk)

signal student_pressed(student)

##Make the player select a table, then Returns an array of students at the selected groupdesk
func select_groupdesk()-> Array:
	students = ManagerList.student_manager.students
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
	students = ManagerList.student_manager.students
	var selectable = len(students)
	for student in students:
		if student.untouchable == false:
			student.pressed.connect(student_pressed.emit.bind(student))
			student.modulate = Color(1.0, 1.0, 0.0, 1.0)
		else:
			selectable -= 1
	if selectable <= 0:
		return []
	var selected_student = await student_pressed
	for student in students:
		if student.untouchable == false:
			student.pressed.disconnect(student_pressed.emit)
			student.modulate = Color.WHITE
	var array_selected_student = [selected_student]
	return array_selected_student


func select_column() -> Array:
	students = ManagerList.student_manager.students
	var selectable = len(students)
	for student in students:
		if student.untouchable == false:
			student.pressed.connect(student_pressed.emit.bind(student))
			student.modulate = Color(1.0, 1.0, 0.0, 1.0)
		else:
			selectable -= 1
	if selectable <= 0:
		return []
	var selected_student = await student_pressed
	for student in students:
		if student.untouchable == false:
			student.pressed.disconnect(student_pressed.emit)
			student.modulate = Color.WHITE
	
	var selected_desk : Desk
	var selected_students = []
	for groupdesk in groupdesks:
		for desk in groupdesk.get_children():
			if desk is Desk:
				if desk.student == selected_student:
					selected_desk = desk
	var column = selected_desk.column
	for groupdesk in groupdesks:
		for desk in groupdesk.get_children():
			if desk is Desk:
				if desk.column == column:
					selected_students.append(desk.student)
	return selected_students
