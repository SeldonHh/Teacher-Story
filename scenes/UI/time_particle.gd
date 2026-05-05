extends CPUParticles2D


func _ready() -> void:
	var parent = get_parent()
	self.global_position = parent.global_position + Vector2(parent.size.x/2,0)
