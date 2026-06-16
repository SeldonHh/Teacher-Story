extends Sprite2D
class_name Desk

@onready var bag: Sprite2D = $bag
@onready var mouse_detector: Area2D = %"Mouse detector"
@onready var pouf: CPUParticles2D = $pouf

@export var student : Student
@export var group : int = 0 ## to target multiple desk at once
@export var row : int = 0 ##0 for back row, 1 for middle row, 2 for first row
@export var column : int = 0 ## 0 for leftmost column
@export var matiere : String = "Histoire-Géo" ##Histoire-Géo, Maths or Science
@export var highlighted := false

func _ready() -> void:
	ManagerList.desk_manager.desks.append(self)
	if student != null:
		student.current_rank = row

func is_empty():
	return student == null

func _process(_delta: float) -> void:
	if student:
		student.current_rank = row
		if student.global_position != global_position + Vector2(4,-9):
			student.global_position = global_position + Vector2(4,-9)
		bag.texture = student.resource.bag_sprite
		bag.show()
	else:
		bag.hide()
	
	if highlighted:
		match matiere:
			"Histoire-Géo": texture = preload("uid://c4acitg7lxibt")
			"Maths": texture = preload("uid://1dfxqd4xdp6n")
			"Science": texture = preload("uid://cumqtbjdpjiur")
	else:
		match matiere:
			"Histoire-Géo": texture = preload("uid://hw8tx30hcybn")
			"Maths": texture = preload("uid://q1knuvqp6ke2")
			"Science": texture = preload("uid://4jn6egxsnlj4")

func play_pouf():
	pouf.emitting = true

func move_front():
	if self.row < 2:
		var tween = get_tree().create_tween()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		if matiere == "Maths":
			tween.tween_property(self,"global_position",global_position+Vector2(-28,14),.3)
		elif matiere == "Science":
			if row == 0:
				tween.tween_property(self,"global_position",global_position+Vector2(-21,9),.3)
			else:
				tween.tween_property(self,"global_position",global_position+Vector2(-28,18),.3)

		tween.tween_callback(func(): row += 1)
