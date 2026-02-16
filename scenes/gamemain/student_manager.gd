extends Node

var students_resources := []
var students := []
var info_labels : Array[RichTextLabel] = []
var student_scene = preload("res://scenes/students/student.tscn")
var gender = ["boy","girl"]
var boy_names = [
	"Kévin", "Maxime", "Mathéo", "Hugo", "Victor", "Julien",
	"Théo", "Sébastien", "Thomas", "Nicolas", "Hervé", "Alexis",
	"Rémi", "David", "Stephen", "Benjamin", "Frédéric",
	"Jérôme", "Johnnatan", "Antoine", "Anthony", "Jean-Marc",
	"Chen", "Cédric", "Dylan", "Abdel-Hakim", "Abdallah",
	"Abel", "Christophe", "Yoann", "Steve"]
var girl_names = [
	"Lola", "Léa", "Margaret", "Ebène", "Julie", "Marie", "Claire",
	"Mélanie", "Céline", "Annabelle", "Fanny", "Morganne",
	"Adeline", "Rachida", "Roxanne", "Richarde", "Audrey",
	"Nadège", "Caroline", "Colette"]


func generate_x_random_student(x) -> void:
	clear_students()
	clear_students_resources()
	info_labels.clear()
	
	for i in range(x):
		if i >= len(%DeskManager.desks):
			return
		var new_student_resource = StudentResource.new()
		var CaractereType = new_student_resource.CaractereType.duplicate()
		var random_key = CaractereType.keys().pick_random()
		new_student_resource.caractere = CaractereType[random_key]
		match new_student_resource.caractere: #TODO: should change depending on difficulty
			CaractereType.Reveur: 
				new_student_resource.ennui_de_base = 3
				new_student_resource.stupidite_de_base = 2
			CaractereType.Jovial: 
				new_student_resource.ennui_de_base = 1
				new_student_resource.stupidite_de_base = 3
			CaractereType.Malin: 
				new_student_resource.ennui_de_base = 3
				new_student_resource.stupidite_de_base = 1
			CaractereType.Timide: 
				new_student_resource.ennui_de_base = 2
				new_student_resource.stupidite_de_base = 3
			CaractereType.Clown:
				new_student_resource.ennui_de_base = 0
				new_student_resource.stupidite_de_base = 4
			CaractereType.Bruyant:
				new_student_resource.ennui_de_base = 2
				new_student_resource.stupidite_de_base = 3
			CaractereType.Manipulateur:
				new_student_resource.ennui_de_base = 4
				new_student_resource.stupidite_de_base = 1
			CaractereType.Hyperactif:
				new_student_resource.ennui_de_base = 3
				new_student_resource.stupidite_de_base = 3

		var student_gender = gender.pick_random()
		if student_gender == "boy":
			new_student_resource.sprite = Global.boy_student_sprites.pick_random()
			new_student_resource.student_name = boy_names.pick_random()
		elif student_gender == "girl":
			new_student_resource.sprite = Global.girl_student_sprites.pick_random()
			new_student_resource.student_name = girl_names.pick_random()
		else:
			print("WTF IS GOING ON, A STUDENT IS NON BINARY APPARENTLY")
		students_resources.append(new_student_resource)
		new_student_resource.note = randi_range(8,14) #TODO: should change depending on difficulty
		
		var label = RichTextLabel.new()
		label.bbcode_enabled = true
		label.text = "[color=000000][b]%s[/b]: %s"%[new_student_resource.student_name,new_student_resource.note]
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label.size_flags_vertical = Control.SIZE_EXPAND_FILL
		label.scroll_active = false
		label.custom_minimum_size = Vector2(16,32)
		%InfoContainer.add_child(label)
		info_labels.append(label)

func update_info_labels():
	for i in range(len(info_labels)):
		info_labels[i].text = "[color=000000][b]%s[/b]: %s/20"%[students_resources[i].student_name,students_resources[i].note]

func assign_students_to_random_desk():
	var possible_spot := []
	for desk in %DeskManager.desks:
		if !desk.student:
			possible_spot.append(desk)
	for student_resource in students_resources:
		var new_spot = possible_spot.pick_random()
		possible_spot.erase(new_spot)
		var new_student = student_scene.instantiate()
		new_student.resource = student_resource
		new_spot.add_child(new_student)
		new_spot.student = new_student
		students.append(new_student)


func clear_students():
	for student in students:
		student.queue_free()

func clear_students_resources():
	students_resources.clear()

func immune_all_students():
	for student in students:
		student.untouchable = true

func reset_all_students():
	for student in students:
		student.reset()

func _ready() -> void:
	ManagerList.student_manager = self
	await get_tree().process_frame
	generate_x_random_student(5)
	assign_students_to_random_desk()

func _process(_delta: float) -> void:
	update_info_labels()
