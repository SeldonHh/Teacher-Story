extends Sprite2D
class_name Desk



@export var student : Student
@export var group : int = 0 ## to target multiple desk at once
@export var row : int = 0 ##0 for back row, 1 for middle row, 2 for first row
@export var column : int = 0 ## 0 for leftmost column
@export var matiere : String = "Histoire-Géo" ##Histoire-Géo, Maths or Science

func _ready() -> void:
	ManagerList.desk_manager.desks.append(self)
	if student != null:
		student.current_rank = row

func is_empty():
	return student == null

func _process(_delta: float) -> void:
	if student:
		student.current_rank = row
