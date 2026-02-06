extends TextureButton

func _ready() -> void:
	SkillTargetSelectHandler.groupdesks.append(self)
