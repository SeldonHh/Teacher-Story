extends Control

@export var resource : SkillResource = preload("uid://c8u8a65r1rt1s")

@onready var main_button: TextureButton = $MainButton
var disabled := false
var no_cc_update := false
@export var no_button :=false
const ENDORMI = preload("res://resource/Etats/Endormi.tres")
const MAL_AU_CRÂNE = preload("res://resource/Etats/MalAuCrâne.tres")
const INOFFENSIF = preload("res://resource/Etats/Inoffensif.tres")
const ENERVÉ = preload("res://resource/Etats/Enervé.tres")
const MORT_DE_RIRE = preload("res://resource/Etats/MortDeRire.tres")
const CHOUCHOU = preload("res://resource/Etats/Chouchou.tres")
const TRÈS_ATTENTIF = preload("res://resource/Etats/TrèsAttentif.tres")
const RAMOLLO = preload("res://resource/Etats/Ramollo.tres")
const ATTENTIF = preload("res://resource/Etats/Attentif.tres")

func _ready() -> void:
	Global.skill_list.append(self)
	update()

func update():
	$MainButton.texture_normal = resource.sprite
	$Tooltip.init(resource.name,resource.description,Color.BLACK,Color.BLANCHED_ALMOND,Color.BISQUE)


func _on_main_button_pressed() -> void:

	for skill in Global.skill_list:
		skill.main_button.disabled = true
	var student_targets = []
	var secondary_targets = []
	match resource.target:
		"Self": student_targets = []
		"Column" : student_targets = await SkillTargetSelectHandler.select_column()
		"Single": student_targets = await SkillTargetSelectHandler.select_student(resource.chouchou_skill)
		"Table":
			student_targets = await SkillTargetSelectHandler.select_groupdesk()
		"All": student_targets = SkillTargetSelectHandler.students
		"Two Students": 
			student_targets = await SkillTargetSelectHandler.select_student(resource.chouchou_skill)
			student_targets.append( await SkillTargetSelectHandler.select_student(resource.chouchou_skill))
		"Student and Desk":
			student_targets = await  SkillTargetSelectHandler.select_student(resource.chouchou_skill)
			if student_targets != []:
				await get_tree().create_timer(.1).timeout
				secondary_targets = await SkillTargetSelectHandler.select_desk(student_targets[0])
		"Single Desk":
			student_targets = [await SkillTargetSelectHandler.select_desk()]
	var concentration_no_effect := false
	var concentration_only_affected_student : Student = null
	if resource.name == "Concentration":
		for student in student_targets:
			if student is Student:
				if student.ennui >0:
					if concentration_only_affected_student !=null:
						concentration_no_effect = true
					concentration_only_affected_student = student

	for student in student_targets:
		if student is Student:
			student.damage(resource.damage_modifier,resource.ennui_breaker,resource.ennui_only)
			student.add_shield(resource.shield_modifier)
	ManagerList.teacher_manager.damage_teacher(-resource.heal_modifier)
	match resource.name:
		"Concentration":
			if !concentration_no_effect and concentration_only_affected_student != null:
				concentration_only_affected_student.resource.etats.append(ATTENTIF)
		"Rappel à l'ordre": 
			var stop := false
			for etat in student_targets[0].resource.etats:
				if etat.negative and !etat.critical and !stop:
					stop = true
					student_targets[0].resource.etats.erase(etat)
					
		"Changement de place": 
			if student_targets != []:
				ManagerList.desk_manager.assign_student_to_another_desk(student_targets[0],secondary_targets)
		"Chouchou":
			if Global.IS_DEBUG and Global.DEBUG_CHOUCHOU_SKILL != null:
				self.resource = Global.DEBUG_CHOUCHOU_SKILL
			else:
				self.resource = student_targets[0].resource.chouchou_skill
			student_targets[0].resource.etats.append(CHOUCHOU)
			no_cc_update  = true
		"Alzheimer":
			Global.bottom_panel.randomize_skills()
		"Antiseche":
			student_targets[0].bonus_note_on_death += 1
		"Chatouilles": 
			student_targets[0].damage(999,false,true)
			student_targets[0].resource.etats.append(ENERVÉ)
		"Chut": 
			for student in student_targets:
				if student is Student:
					student.add_shield(1)
					var count = 0
					for etat in student.resource.etats:
						if etat.negative and count <2:
							student.resource.etats.erase(etat)
							count +=1
		"Demenageur": 
			var current_desk = student_targets[0]
			var active := true
			if current_desk.row > 2:
				active = false
			for desk in ManagerList.desk_manager.get_room_desk_list():
				if desk.column == current_desk.column and desk.row == current_desk.row +1:
					active = false
			if active:
				current_desk.move_front()
		"ElectroChoc": 
			for etat in student_targets[0].resource.etats:
				if etat.critical and etat.name != 'Endormi':
					student_targets[0].resource.etats.erase(etat)
		"Exclusion": 
			for desk in ManagerList.desk_manager.get_room_desk_list():
				if desk.student == student_targets[0]:
					desk.play_pouf()
			ManagerList.student_manager.exclude(student_targets[0])
		"Fusil Hypodermique": student_targets[0].resource.etats.append(RAMOLLO)
		"Gourdin":student_targets[0].resource.etats.append(MAL_AU_CRÂNE)
		"Gros Cerveau": student_targets[0].resource.etats.append(TRÈS_ATTENTIF)
		"Même pas drôle": 
			for student in student_targets:
				if student is Student:
					student.resource.etats.erase(MORT_DE_RIRE)
		"Meneur": 
			var room_desk = ManagerList.desk_manager.get_room_desk_list()
			if randf() < .90:
				room_desk.sort_custom(func(a,b): 
					if a.row > b.row:
						return true
					if a.row == b.row:
						if a.column > b.column:
							return false
						else:
							return true)
			for i in range(len(student_targets)):
				ManagerList.desk_manager.assign_student_to_another_desk(student_targets[i],room_desk[i])
		"Réconfort": ManagerList.timer_manager.healing_time.append(3)
		"Sonnerie": 
			for student in student_targets:
				if student is Student:
					if  ENDORMI in student.resource.etats:
						student.resource.etats.erase(ENDORMI)
		"Synergie":
			for student in student_targets:
				if student is Student:
					if student.beaten:
						print("+1 XP")
						#TODO: add +1 XP
		"Transfert": 
			for student in student_targets:
				if student is Student:
					var transfert_temp = student.ennui
					var transfert_desk : Desk
					student.damage(transfert_temp,false,true)
					for desk in ManagerList.desk_manager.desks:
						if desk.student == student:
							transfert_desk = desk
					for desk in ManagerList.desk_manager.get_room_desk_list():
						if desk.group == transfert_desk.group and desk != transfert_desk:
							desk.student.add_shield(ceil(transfert_temp/2))
		"Valium":student_targets[0].resource.etats.append(INOFFENSIF)

	if !no_cc_update:
		resource.current_cooldown = resource.cooldown
	else:
		no_cc_update  = false
	for skill in Global.skill_list:
		skill.main_button.disabled = false

	if !resource.fast_skill:
		ManagerList.timer_manager.update_time(-1)

func _process(_delta: float) -> void:
	update()
	disabled = resource.current_cooldown > 0
	if disabled or no_button:
		modulate = Color(0.53, 0.53, 0.53, 1.0)
		main_button.disabled = true
	else:
		modulate = Color.WHITE

func _on_mouse_entered() -> void:
	$Tooltip.show()


func _on_mouse_exited() -> void:
	$Tooltip.hide()
