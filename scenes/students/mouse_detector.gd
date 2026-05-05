extends Area2D

var is_hovered := false
signal custom_mouse_enter
signal custome_mouse_exit
signal custom_pressed

func _process(_delta):
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	
	# This is in the SubViewport's world space, which is what the physics server uses
	query.position = get_global_mouse_position()
	query.collide_with_areas = true
	query.collision_mask = collision_layer  # or 1
	
	var results = space_state.intersect_point(query)
	var hovered_now := false
	
	for result in results:
		if result.collider == self:
			hovered_now = true
			break
	
	if hovered_now and not is_hovered:
		is_hovered = true
		emit_signal("custom_mouse_enter")
	elif not hovered_now and is_hovered:
		is_hovered = false
		emit_signal("custome_mouse_exit")
	
	if is_hovered and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		emit_signal("custom_pressed")
