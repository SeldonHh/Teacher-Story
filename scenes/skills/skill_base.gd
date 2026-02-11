extends Control

@export var resource : SkillResource = preload("res://resource/Skills/Enseigner.tres")

@onready var main_button: TextureButton = $MainButton

func _ready() -> void:
	Global.skill_list.append(self)
	$MainButton.texture_normal = resource.sprite
	$Tooltip.init(resource.name,resource.description,Color.BLACK,Color.BLANCHED_ALMOND,Color.BISQUE)


func _on_main_button_pressed() -> void:
	for skill in Global.skill_list:
		skill.main_button.disabled = true
	var student_targets = []
	match resource.target:
		"Self": student_targets = []
		"Column" : student_targets = await SkillTargetSelectHandler.select_column()
		"Single": student_targets = await SkillTargetSelectHandler.select_student()
		"Table":
			student_targets = await SkillTargetSelectHandler.select_groupdesk()
		"All": student_targets = SkillTargetSelectHandler.students
	for student in student_targets:
		if student is Student:
			student.damage(resource.damage_modifier,resource.ennui_breaker,resource.ennui_only)
	match resource.name:
		"Rappel à l'ordre": pass #TODO: Remove negative effect
		"Concentration": pass #TODO: Add positive effect 
	
	for skill in Global.skill_list:
		skill.main_button.disabled = false
	ManagerList.timer_manager.update_time(-1)

func _on_mouse_entered() -> void:
	$Tooltip.show()


func _on_mouse_exited() -> void:
	$Tooltip.hide()
