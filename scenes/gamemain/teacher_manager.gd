extends Node

var max_teacher_life : int = 22
var teacher_life : int = max_teacher_life

func _ready() -> void:
	ManagerList.teacher_manager = self


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
