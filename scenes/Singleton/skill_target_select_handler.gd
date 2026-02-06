extends Node

var groupdesks := []
var students := []

signal groupdesk_pressed(desk)

##Make the player select a table, then Returns an array of students at the selected groupdesk
func select_groupdesk()-> Array[Student]:
	for student in students:
		student.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	
	for groupdesk in groupdesks:
		groupdesk.disabled = false
		groupdesk.mouse_filter = Control.MOUSE_FILTER_STOP
		groupdesk.pressed.connect(groupdesk_pressed.emit.bind(groupdesk))
		for desk in groupdesk.get_children():
			if desk is Desk:
				desk.self_modulate = Color(1.0, 1.0, 0.0, 1.0)
		
		
	var selected_groupdesk = await groupdesk_pressed
	
	for groupdesk in groupdesks:
		groupdesk.pressed.disconnect(groupdesk_pressed.emit)
		groupdesk.disabled = true
		groupdesk.mouse_filter = Control.MOUSE_FILTER_IGNORE
		for desk in groupdesk.get_children():
			if desk is Desk:
				desk.self_modulate = Color.WHITE
	
	for student in students:
		student.mouse_filter = Control.MOUSE_FILTER_STOP
		
	return []
