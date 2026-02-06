extends Node

@onready var IS_DEBUG = "debug" in OS.get_cmdline_args()

var skill_list :Array[Control]= []

var boy_student_sprites = [
	preload("res://assets/students/guy1.png"),
	]
var girl_student_sprites = [
	preload("res://assets/students/girl1.png"),
]

func _ready() -> void:
	if IS_DEBUG:
		print("DEBUG MODE ON")
