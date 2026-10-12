extends Node

var max_teacher_life : int = 22
var teacher_life : int = max_teacher_life
var james_science_spawn := Vector2(-326,332)
var james_maths_spawn := Vector2(-159,246)
var james_history_spawn := Vector2(86,127)
var james_classroom_instance: CharacterBody2D
var james_teacher_room_instance : CharacterBody2D
var james_home_instance : CharacterBody2D

func _ready() -> void:
	ManagerList.teacher_manager = self
	if Global.IS_DEBUG:
		teacher_life = max_teacher_life/2


func reset_life():
	teacher_life = max_teacher_life

func _process(_delta: float) -> void:
	if teacher_life <= 0:
		crashout()
	elif teacher_life > max_teacher_life:
		teacher_life= max_teacher_life
		

func damage_teacher(amount):
	teacher_life -= amount

func crashout():
	print("crashing out")

func spawn_james(classroom : String):
	match classroom:
		"Histoire-Géo": james_classroom_instance.position = james_history_spawn
		"Maths": james_classroom_instance.position = james_maths_spawn
		"Science": james_classroom_instance.position = james_science_spawn
