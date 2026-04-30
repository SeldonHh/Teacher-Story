extends Node

var current_mission_resource : MissionBase
var rng = RandomNumberGenerator.new()
const POSSIBLE_DIFFICULTIES : Array[int] = [0,1,2,3]
const DIFFICULTIES_WEIGHTS : Array[int] = [7,13,10,5]
const POSSIBLE_GOALS : Array[int] = [8,9,10,11,12,13,14]
const POSSIBLE_GOALS_FOR_X_ELEVES : Array[int] = [10,12,14,16]
var goals_weights : Array[int] = [7,10,9,6,2,0]


func _ready() -> void:
	ManagerList.mission_manager = self
	await get_tree().process_frame
	generate_mission_selection()

func update_mainscreen_ui():
	%MissionInfoContainer.update_objective_label(Global.get_text_for_mission_objective(current_mission_resource))
	%MissionInfoContainer.update_reward_label("[color=f07c46][b]%s[/b][/color] [img]uid://dfcgw32nv5d56[/img][font_size=12] [i](reste %s cours) [/i] [/font_size]"%[current_mission_resource.reward,current_mission_resource.ideal_max_lesson])


func generate_mission_selection():
	%MainGameScreen.hide()
	%MissionSelectionScreen.show()
	for child in %MissionSelectionInstanceContainer.get_children():
		if child is MissionSelectionInstance:
			var new_mission = make_new_random_mission()
			child.update_ui(new_mission)


func mission_selected(resource,name_labels,note_labels,caractere_labels):
	current_mission_resource = resource
	var sm = ManagerList.student_manager
	sm.students_resources = resource.students
	sm.name_info_labels = name_labels
	sm.note_info_labels = note_labels
	sm.caractere_info_labels = caractere_labels
	reparent_labels(Global.interleave_arrays(name_labels,note_labels),%StudentInfoContainer)
	sm.assign_students_to_random_desk()
	%MainGameScreen.show()
	%MissionSelectionScreen.hide()
	update_mainscreen_ui()
	match resource.matiere:
		"Histoire-Géo": %GameSpace.set_camera_offset(Global.HISTORY_CLASS_CAMERA_OFFSET)
		"Maths": %GameSpace.set_camera_offset(Global.MATH_CLASS_CAMERA_OFFSET)
		"Sciences": %GameSpace.set_camera_offset(Global.SCIENCE_CLASS_CAMERA_OFFSET)


func reparent_labels(labels,new_parent):
	for label in labels:
		label.reparent(new_parent)

func make_new_random_mission():
	var new_resource = MissionBase.new()
	var difficulty = POSSIBLE_DIFFICULTIES[rng.rand_weighted(DIFFICULTIES_WEIGHTS)]
	var all_students = [0,1].pick_random()
	new_resource.classname = ["Sixième","Cinquième","Quatrième","Troisième","Seconde","Première","Terminale"].pick_random()+" " +["A","B","C","D","E","F","G","H","I","J","K"].pick_random()
	new_resource.matiere = ["Maths","Histoire-Géo","Science"].pick_random()
	match difficulty:
		0: 
			if all_students:
				goals_weights = [3,7,10,9,6,2,0]
			else:
				goals_weights = [2,10,5,0]
			new_resource.students = ManagerList.student_manager.generate_x_random_student(5)
		1:
			if all_students:

				goals_weights = [2,4,8,9,5,2,0]
			else:
				goals_weights = [1,7,7,1]
			new_resource.students = ManagerList.student_manager.generate_x_random_student(5)
		2:
			if all_students:
				goals_weights = [0,2,5,9,11,6,2]
			else:
				goals_weights = [0,4,12,4]
			new_resource.students = ManagerList.student_manager.generate_x_random_student(6)
		3:
			if all_students:
				goals_weights = [0,0,2,4,7,6,2]
			else:
				goals_weights = [0,0,8,3]
			new_resource.students = ManagerList.student_manager.generate_x_random_student(8)
	
	if all_students:
		new_resource.goal = POSSIBLE_GOALS[rng.rand_weighted(goals_weights)]
	else:
		new_resource.goal = POSSIBLE_GOALS_FOR_X_ELEVES[rng.rand_weighted(goals_weights)]
	if !all_students:
		match new_resource.goal:
			10:  new_resource.goal_is_for_x_student = randi_range(1,5)
			12: new_resource.goal_is_for_x_student = randi_range(1,5)
			14: new_resource.goal_is_for_x_student = randi_range(1,4)
			16:  new_resource.goal_is_for_x_student = randi_range(1,3)

	new_resource.difficulty = difficulty
	if all_students:
		new_resource.goal_is_for_x_student = -1
	var best_students
	var worst_student = StudentResource.new()
	worst_student.note = 20
	if all_students:
		for student in new_resource.students:
			if student.note < worst_student.note:
				worst_student = student
		new_resource.ideal_max_lesson = int(ceil((new_resource.goal - floor(worst_student.note))/2))+1
	else:
		best_students = [] 
		for i in range(new_resource.goal_is_for_x_student):
			var best_student = StudentResource.new()
			best_student.note = 0
			for student in new_resource.students:
				if student.note > best_student.note and new_resource.students not in best_students:
					best_student = student
			best_students.append(best_student)
		for student in best_students:
			if student.note < worst_student.note:
				worst_student = student
		new_resource.ideal_max_lesson = int(ceil((new_resource.goal - floor(worst_student.note))/2))+1
		
	var student_sum = 0
	if all_students:
		for student in new_resource.students:
			student_sum += (new_resource.goal-student.note) 
	else:
		for student in best_students:
			student_sum += (new_resource.goal-student.note)
	
	new_resource.reward = 10* int(new_resource.ideal_max_lesson +  floor( student_sum / new_resource.ideal_max_lesson))
	if new_resource.reward <30:
		new_resource.reward = 30
	if randi_range(0,1000000) == 8:
		new_resource.goal = 2 #Enjoy the free win, you earned it
	return new_resource
