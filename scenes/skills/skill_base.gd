extends Control

@export var resource : SkillResource = preload("uid://c8u8a65r1rt1s")

@onready var main_button: TextureButton = $MainButton
var disabled := false

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
	match resource.name:
		"Rappel à l'ordre": pass #TODO: Remove negative effect
		"Concentration": pass #TODO: Add positive effect 
		"Changement de place": 
			if student_targets != []:
				ManagerList.desk_manager.assign_student_to_another_desk(student_targets[0],secondary_targets)
	
	resource.current_cooldown = resource.cooldown
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
