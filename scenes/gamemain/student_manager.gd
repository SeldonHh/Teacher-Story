extends Node
@onready var student_tooltip: Control = %Student_Tooltip
var students_resources := []
var students := []
var name_info_labels : Array[RichTextLabel] = []
var note_info_labels : Array[RichTextLabel] = []
var caractere_info_labels : Array[RichTextLabel] = []
var student_scene = preload("res://scenes/students/student.tscn")
var gender = ["boy","girl"]
var boy_names = [
"Aylan","Alexandre","Alexis","Andress","Antoine","Arthur","Athanase","Aurélien",
"Barnabé","Benjamin","Caïn","Camille","Charles","Edouard","Clément","David","Diego",
"Eliott","Enzo","Esteban","Félix","François","Gaetan","Henri","Hugo","Jean",
"Jean-Baptiste","Joachim","Jonathan","Joseph","Joshua","Judas","Justin","Kevin",
"Imane","Lenny","Léon","Loïc","Louis","Lucas","Marius","Mathieu","Maxime","Mehdi",
"Mohamed","Nathan","Nicolas","Oscar","Paul","Pierre","Raoul","Raphaël","Rémi",
"Robin","Romeo","Paul","Samuel","Sébastien","Théo","Thomas","Tom","Valentin",
"Vincent","Yann","Yassine","Zlatan","Seldon","Demurgos","Patate","Nassimou"
]
var girl_names = [
"Adele","Agathe","Aïcha","Alice","Alizée","Amandine","Anaïs","Angélique","Anna",
"Apolline","Barbara","Béatrice","Céleste","Chaima","Charlotte","Chloe",
"Claire","Clara","Constance","Domitille","Eglantine","Eleonore","Enora","Elise",
"Elsa","Emilie","Emma","Fanchon","Fanny","Félicie","Georgette",
"Inaya","Inès","Jeanne","Julie","Kenza","Kimberley","Lili","Lou","Louise",
"Louna","Maélys","Margot","Meredith","Marie","Marie-Lou","Marine","Mathilde","Maya",
"Melinda","Mélissa","Mia","Myriam","Naomie","Pauline","Philippine","Rose",
"Sofia","Stella","Suzette","Tess","Valentine","Victoria","Violette",
"Yasmine","Zoé","Biosha","Tommy","Mawie"
]
const POSSIBLE_NOTES : Array[int] = [2,3,4,5,6,7,8,9,10,11,12,13]
var notes_weights : Array[int] = [5,5,12,12,20,30,20,8,2,2,1]
var rng = RandomNumberGenerator.new()
func generate_x_random_student(x):
	var resources =[]
	for i in range(x):
		if i >= len(%DeskManager.desks):
			print("trying to make more students than there are desks")
			return students_resources
		var new_student_resource = StudentResource.new()
		var CaractereType = Global.CaractereType.duplicate()
		var random_key = CaractereType.keys().pick_random()
		new_student_resource.bag_sprite = Global.BAG_SPRITES.pick_random()
		new_student_resource.caractere = CaractereType[random_key]
		new_student_resource.chouchou_skill = Global.chouchou_skills[CaractereType[random_key]].pick_random()
		match new_student_resource.caractere: #TODO: should change depending on difficulty
			CaractereType.GrosDormeur: 
				new_student_resource.ennui_de_base = randi_range(2,6)
				new_student_resource.stupidite_de_base = randi_range(3,4)
			CaractereType.Insolent: 
				new_student_resource.ennui_de_base = randi_range(2,3)
				new_student_resource.stupidite_de_base = randi_range(2,4)
			CaractereType.CassePied: 
				new_student_resource.ennui_de_base = randi_range(0,3)
				new_student_resource.stupidite_de_base = randi_range(2,4)
			CaractereType.Intello: 
				new_student_resource.ennui_de_base = randi_range(1,2)
				new_student_resource.stupidite_de_base = randi_range(1,2)
			CaractereType.Musqué:
				new_student_resource.ennui_de_base = randi_range(1,4)
				new_student_resource.stupidite_de_base = randi_range(2,4)
			CaractereType.Nul:
				new_student_resource.ennui_de_base = randi_range(1,4)
				new_student_resource.stupidite_de_base = randi_range(3,4)
			CaractereType.OeuilDeLynx:
				new_student_resource.ennui_de_base = randi_range(0,3)
				new_student_resource.stupidite_de_base = randi_range(2,4)
			CaractereType.SansGene:
				new_student_resource.ennui_de_base = randi_range(1,4)
				new_student_resource.stupidite_de_base = randi_range(3,4)
			CaractereType.Timide:
				new_student_resource.ennui_de_base = randi_range(1,4)
				new_student_resource.stupidite_de_base = randi_range(3,4)
			CaractereType.TresBavard:
				new_student_resource.ennui_de_base = randi_range(1,4)
				new_student_resource.stupidite_de_base = randi_range(3,4)

		var student_gender = gender.pick_random()
		if student_gender == "boy":
			new_student_resource.sprite = Global.boy_student_sprites.pick_random()[0]
			new_student_resource.standing_sprite = Global.boy_student_sprites.pick_random()[1]
			new_student_resource.student_name = boy_names.pick_random()
		elif student_gender == "girl":
			new_student_resource.sprite = Global.girl_student_sprites.pick_random()[0]
			new_student_resource.standing_sprite = Global.girl_student_sprites.pick_random()[1]
			new_student_resource.student_name = girl_names.pick_random()
		else:
			print("WTF IS GOING ON, A STUDENT IS NON BINARY APPARENTLY (SUPPORT TO THEM BUT THAT'S NOT SUPPOSED TO HAPPEN IN THIS GAME THO)")
		new_student_resource.note = POSSIBLE_NOTES[rng.rand_weighted(notes_weights)]
		if randf() < .3:
			new_student_resource.note += 0.5

		students_resources.append(new_student_resource)
		resources.append(new_student_resource)
	return resources

func update_info_labels():
	for i in range(len(name_info_labels)):
		name_info_labels[i].text = "[color=326e7d]%s"%[students_resources[i].student_name]
	for i in range(len(note_info_labels)):
		note_info_labels[i].text = '[right][color=%s]%s/20'%[Global.get_color_for_note(students_resources[i].note),int(students_resources[i].note)]

func make_labels(resource,container,include_caractere_labels = false):
	var name_label = RichTextLabel.new()
	set_label_settings(name_label)
	name_label.text = "[color=326e7d]%s"%[resource.student_name]
	container.add_child(name_label)
	name_info_labels.append(name_label)

	if include_caractere_labels:
		var caractere_label = RichTextLabel.new()
		set_label_settings(caractere_label)
		caractere_label.text = '[center][color=326e7d]%s'%[Global.CaractereType.keys()[resource.caractere]]
		container.add_child(caractere_label)
		caractere_info_labels.append(caractere_label)
		
	var note_label = RichTextLabel.new()
	set_label_settings(note_label)
	note_label.text = '[right][color=%s]%s/20'%[Global.get_color_for_note(resource.note),int(resource.note)]
	container.add_child(note_label)
	note_info_labels.append(note_label)


		
func set_label_settings(label_to_change):
	label_to_change.bbcode_enabled = true
	label_to_change.add_theme_font_size_override("normal_font_size",15)
	label_to_change.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label_to_change.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	label_to_change.scroll_active = false
	label_to_change.custom_minimum_size = Vector2(18,20)

func assign_students_to_random_desk():
	var mission = ManagerList.mission_manager.current_mission_resource
	if mission == null:
		print("ERROR: NO MISSION SELECTED WHILE PUTTING STUDENTS IN DESK")
	var possible_spot := []
	for desk in %DeskManager.desks:
		if !desk.student and desk.matiere == mission.matiere:
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
