extends Node

var groupdesks := []
var students := []

signal student_pressed(student)

##Make the player select a table, then Returns an array of students at the selected groupdesk
func select_groupdesk()-> Array:
	students = ManagerList.student_manager.students
	var selectable = len(students)
	for student in students:
		if student.untouchable == false:
			student.mouse_detector.custom_pressed.connect(student_pressed.emit.bind(student))
			student.modulate = Color(1.0, 1.0, 0.0, 1.0)
		else:
			selectable -= 1
	if selectable <= 0:
		return []
	var selected_student = await student_pressed
	for student in students:
		if student.untouchable == false:
			student.mouse_detector.custom_pressed.disconnect(student_pressed.emit)
			student.modulate = Color.WHITE
	
	var selected_desk : Desk
	var selected_students = []
	for desk in ManagerList.desk_manager.desks:
		if desk.student == selected_student:
			selected_desk = desk
	var group = selected_desk.group
	for desk in ManagerList.desk_manager.desks:
		if desk.group == group:
			selected_students.append(desk.student)
	return selected_students

func select_student() -> Array :
	students = ManagerList.student_manager.students
	var selectable = len(students)
	for student in students:
		if student.untouchable == false:
			student.mouse_detector.custom_pressed.connect(student_pressed.emit.bind(student))
			student.modulate = Color(1.0, 1.0, 0.0, 1.0)
		else:
			selectable -= 1
	if selectable <= 0:
		return []
	var selected_student = await student_pressed
	for student in students:
		if student.untouchable == false:
			student.mouse_detector.custom_pressed.disconnect(student_pressed.emit)
			student.modulate = Color.WHITE
	var array_selected_student = [selected_student]
	return array_selected_student


func select_column() -> Array:
	students = ManagerList.student_manager.students
	var selectable = len(students)
	for student in students:
		if student.untouchable == false:
			student.mouse_detector.custom_pressed.connect(student_pressed.emit.bind(student))
			student.modulate = Color(1.0, 1.0, 0.0, 1.0)
		else:
			selectable -= 1
	if selectable <= 0:
		return []
	var selected_student = await student_pressed
	for student in students:
		if student.untouchable == false:
			student.mouse_detector.custom_pressed.disconnect(student_pressed.emit)
			student.modulate = Color.WHITE
	
	var selected_desk : Desk
	var selected_students = []
	for desk in ManagerList.desk_manager.desks:
		if desk.student == selected_student:
			selected_desk = desk
	var column = selected_desk.column
	for desk in ManagerList.desk_manager.desks:
		if desk.column == column:
			selected_students.append(desk.student)
	return selected_students
