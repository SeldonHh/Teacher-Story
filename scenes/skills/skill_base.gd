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
		"Self": pass
		"Single": pass
		"Table":
			student_targets = await SkillTargetSelectHandler.select_groupdesk()
	match resource.name:
		"Enseigner":
			for student in student_targets:
				if student is Student:
					student.damage(2)
	for skill in Global.skill_list:
		skill.main_button.disabled = false


func _on_mouse_entered() -> void:
	print("OHHH")
	$Tooltip.show()


func _on_mouse_exited() -> void:
	$Tooltip.hide()
