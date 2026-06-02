extends Control

@export var resource : SkillResource = preload("uid://c8u8a65r1rt1s")

@onready var main_button: TextureButton = $MainButton
var disabled := false
var no_cc_update := false

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
		"Single": student_targets = await SkillTargetSelectHandler.select_student()
		"Table":
			student_targets = await SkillTargetSelectHandler.select_groupdesk()
		"All": student_targets = SkillTargetSelectHandler.students
		"Two Students": 
			student_targets = await SkillTargetSelectHandler.select_student()
			student_targets.append( await SkillTargetSelectHandler.select_student())
		"Student and Table":
			student_targets = await  SkillTargetSelectHandler.select_student()
			if student_targets != []:
				await get_tree().create_timer(.1).timeout
				secondary_targets = await SkillTargetSelectHandler.select_desk()
	for student in student_targets:
		if student is Student:
			student.damage(resource.damage_modifier,resource.ennui_breaker,resource.ennui_only)
			student.add_shield(resource.shield_modifier)
	ManagerList.teacher_manager.teacher_life += resource.heal_modifier
	match resource.name:
		"Rappel à l'ordre": pass #TODO: Remove negative effect
		"Concentration": pass #TODO: Add positive effect 
		"Changement de place": 
			if student_targets != []:
				ManagerList.desk_manager.assign_student_to_another_desk(student_targets[0],secondary_targets)
		"Chouchou":
			if Global.IS_DEBUG and Global.DEBUG_CHOUCHOU_SKILL != null:
				self.resource = Global.DEBUG_CHOUCHOU_SKILL
			else:
				self.resource = student_targets[0].resource.chouchou_skill
			no_cc_update  = true
		"Alzheimer":
			Global.bottom_panel.randomize_skills()
		"Antiseche":
			student_targets[0].bonus_note_on_death += 1
		"Chatouilles": pass #TODO: Add negative effect "Enervé"
		"Demenageur": pass#TODO: Move desk
		"Exclusion": pass #TODO: remove student
		"Fusil Hypodermique":pass #TODO: add effect "Ramollo"
		"Gourdin":pass #TODO: add effect "Mal au crâne"
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
					
		"Sonnerie": pass #TODO: remove effect "endormi", add effect "attentifs" to those who were "endormi"
		"Valium":pass #TODO: add effect "Inoffensif"

	if !no_cc_update:
		resource.current_cooldown = resource.cooldown
	else:
		no_cc_update  = false
	for skill in Global.skill_list:
		skill.main_button.disabled = false

	if !resource.fast_skill:
		ManagerList.timer_manager.update_time(-1)
		ManagerList.teacher_manager.teacher_life -= randi_range(0,3)

func _process(_delta: float) -> void:
	update()
	disabled = resource.current_cooldown > 0
	if disabled:
		modulate = Color(0.53, 0.53, 0.53, 1.0)
		main_button.disabled = true
	else:
		modulate = Color.WHITE

func _on_mouse_entered() -> void:
	$Tooltip.show()


func _on_mouse_exited() -> void:
	$Tooltip.hide()
