extends Node

var groupdesks := []
var students := []

signal student_pressed(student)
signal desk_pressed(desk)

##Make the player select a table, returns it
func select_desk(excluded_student := Student.new()):
	var desks = ManagerList.desk_manager.desks
	if len(desks) <= 0:
		return []
	for desk in desks:
		if desk.student != excluded_student:
			desk.mouse_detector.custom_pressed.connect(desk_pressed.emit.bind(desk))
			desk.highlighted = true
	var selected_desk = await desk_pressed
	for desk in desks:
		if desk.student != excluded_student:
			desk.mouse_detector.custom_pressed.disconnect(desk_pressed.emit)
			desk.highlighted = false
	return selected_desk

func select_desk_with_students():
	var desks = ManagerList.desk_manager.desks
	var selectable = len(desks)
	for desk in desks:
		if desk.is_empty():
			selectable -= 1
		else:
			desk.mouse_detector.custom_pressed.connect(desk_pressed.emit.bind(desk))
			desk.highlighted = true
	if selectable <= 0:
		return []
	var selected_desk = await desk_pressed
	for desk in desks:
		if !desk.is_empty():
			desk.mouse_detector.custom_pressed.disconnect(desk_pressed.emit)
			desk.highlighted = false
	return selected_desk

##Make the player select a table, then Returns an array of students at the selected groupdesk
func select_groupdesk()-> Array:
	var desks = ManagerList.desk_manager.desks
	if len(desks) <= 0:
		return []
	for desk in desks:
		desk.mouse_detector.custom_pressed.connect(desk_pressed.emit.bind(desk))
		desk.highlighted = true
	var selected_desk = await desk_pressed
	for desk in desks:
		desk.mouse_detector.custom_pressed.disconnect(desk_pressed.emit)
		desk.highlighted = false
	
	var result = [selected_desk]
	for desk in desks:
		if desk.group == selected_desk.group:
			result.append(desk.student)
	return result

func select_student(chouchou_skill := false) -> Array :
	students = ManagerList.student_manager.students
	var selectable = len(students)
	for student in students:
		if not(chouchou_skill and student.resource.etats.has(preload("uid://bxeunpqmyn8ng"))):
			if student.untargetable == false and student.beaten == false:
				student.mouse_detector.custom_pressed.connect(student_pressed.emit.bind(student))
				student.modulate = Color(1.0, 1.0, 0.0, 1.0)
		else:
			selectable -= 1
	if selectable <= 0:
		return []
	var selected_student = await student_pressed
	for student in students:
		if not(chouchou_skill and student.resource.etats.has(preload("uid://bxeunpqmyn8ng"))):
			if student.untargetable == false and student.beaten == false:
				student.mouse_detector.custom_pressed.disconnect(student_pressed.emit)
				student.modulate = Color.WHITE
	var array_selected_student = [selected_student]
	return array_selected_student


func select_column() -> Array:
	students = ManagerList.student_manager.students
	var selectable = len(students)
	for student in students:
		if student.untargetable == false and student.beaten == false:
			student.mouse_detector.custom_pressed.connect(student_pressed.emit.bind(student))
			student.modulate = Color(1.0, 1.0, 0.0, 1.0)
		else:
			selectable -= 1
	if selectable <= 0:
		return []
	var selected_student = await student_pressed
	for student in students:
		if student.untargetable == false and student.beaten == false:
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
