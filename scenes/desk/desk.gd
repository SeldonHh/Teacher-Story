extends TextureButton
class_name Desk



@export var student : Student
@export var group : int = 0 ## to target multiple desk at once
@export var row : int = 0 ##0 for back row, 1 for middle row, 2 for first row
@export var column : int = 0 ## 0 for leftmost column

func _ready() -> void:
	if student != null:
		student.current_rank = row

func is_empty():
	return student == null
