extends Node2D

@onready var history_door: Sprite2D = %History_Door
@onready var maths_door: Sprite2D = %Maths_Door
@onready var science_door: Sprite2D = %Science_Door

func set_camera_offset(offset : Vector2):
	$Camera2D.offset= offset

func _process(delta: float) -> void:
	if Global.IS_DEBUG:
		var direction = Input.get_vector("debug_camera_left","debug_camera_right","debug_camera_up","debug_camera_down")
		$Camera2D.offset += direction * delta * 80

func set_camera_to_teacher_room():
	set_camera_offset(Vector2(-3638,-1261))
