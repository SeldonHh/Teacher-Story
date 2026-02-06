extends Node

var student_scene = preload("res://scenes/students/student.tscn")
var gender = ["boy","girl"]
var boy_names = ["Michael","Edward","Clint","James","John"]
var girl_names = ["Kate","Marie","Alicia","Susie","Rachel"]

func set_student_to_x_random_student(x) -> void:
	clear_children()
	var possible_spot = []
	var max_desk = 0
	var groupdesks = %ClassRoom.get_children()
	for groupdesk in groupdesks:
		for child in groupdesk.get_children():
			if child is Desk:
				possible_spot.append(child)
				max_desk += 1
	for i in range(x):
		if i >= max_desk:
			return
		var new_student = student_scene.instantiate()
		var CaractereType = new_student.CaractereType.duplicate()
		var random_key = CaractereType.keys().pick_random()
		new_student.caractere = CaractereType[random_key]
		match new_student.caractere: #TODO: should change depending on difficulty
			CaractereType.Reveur: 
				new_student.ennui_de_base = 3
				new_student.stupidite_de_base = 2
			CaractereType.Jovial: 
				new_student.ennui_de_base = 1
				new_student.stupidite_de_base = 3
			CaractereType.Malin: 
				new_student.ennui_de_base = 3
				new_student.stupidite_de_base = 1
			CaractereType.Timide: 
				new_student.ennui_de_base = 2
				new_student.stupidite_de_base = 3
			CaractereType.Clown:
				new_student.ennui_de_base = 0
				new_student.stupidite_de_base = 4
			CaractereType.Bruyant:
				new_student.ennui_de_base = 2
				new_student.stupidite_de_base = 3
			CaractereType.Manipulateur:
				new_student.ennui_de_base = 4
				new_student.stupidite_de_base = 1
			CaractereType.Hyperactif:
				new_student.ennui_de_base = 3
				new_student.stupidite_de_base = 3

		var student_gender = gender.pick_random()
		if student_gender == "boy":
			new_student.sprite = Global.boy_student_sprites.pick_random()
			new_student.student_name = boy_names.pick_random()
		elif student_gender == "girl":
			new_student.sprite = Global.girl_student_sprites.pick_random()
			new_student.student_name = girl_names.pick_random()
		else:
			print("WTF IS GOING ON, A STUDENT IS NON BINARY APPARENTLY")
		new_student.note = randi_range(8,14) #TODO: should change depending on difficulty
		var new_spot = possible_spot.pick_random()
		possible_spot.erase(new_spot)
		new_spot.add_child(new_student)
		new_spot.student =  new_student

func clear_children():
	var groupdesks = %ClassRoom.get_children()
	for groupdesk in groupdesks:
		for child in groupdesk.get_children():
			if child is Desk:
				for old_student in child.get_children():
					old_student.queue_free()
				child.student = null


func _ready() -> void:
	set_student_to_x_random_student(5)
