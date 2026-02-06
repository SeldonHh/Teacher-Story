extends Control

var skill : SkillResource = preload("res://resource/Skills/Enseigner.tres")


func _ready() -> void:
	%MainButton.texture_normal = skill.sprite


func _on_main_button_pressed() -> void:
	%MainButton.disabled = true
	match skill.target:
		"Self": pass
		"Single": pass
		"Table":
			print("skill activated")
			var student_targets = await SkillTargetSelectHandler.select_groupdesk()
			
			for student in student_targets:
				student.damage(2)

	%MainButton.disabled = false
