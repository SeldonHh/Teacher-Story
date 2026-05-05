extends Node

@onready var IS_DEBUG = "debug" in OS.get_cmdline_args()

const HISTORY_CLASS_CAMERA_OFFSET : Vector2i = Vector2i(-12,15)
const MATH_CLASS_CAMERA_OFFSET : Vector2i = Vector2i(-258,138)
const SCIENCE_CLASS_CAMERA_OFFSET : Vector2i = Vector2i(-400,235)

const BAG_SPRITES = [preload("uid://cxd8ggqp0omqk"),preload("uid://u78sx6xejio6"),preload("uid://cc75phnlu02nq"),preload("uid://88w24qm8hg25")]

var DEBUG_SKIP_MISSION_SELECTION = false

var skill_list :Array[Control]= []

var boy_student_sprites = [
	preload("res://assets/students/guy1.png"),
	]
var girl_student_sprites = [
	preload("res://assets/students/girl1.png"),
]


var demon_heads : Array[Texture] = [
	preload("uid://dme4ic7obj7pq"),
	preload("uid://bmah484yl4akl"),
	preload("uid://5ifmk8x86m3s"),
	preload("uid://bp5bwct6wy6tb"),
	preload("uid://cf86hk0ybvc0e"),
	]

func _ready() -> void:
	if IS_DEBUG:
		print("DEBUG MODE ON")

func get_color_for_note(note):
	if note >= 10:
		return '#76ae7d'
	elif note <10:
		return "red"

func interleave_arrays(a: Array, b: Array) -> Array:
	var result: Array = []
	var size = min(a.size(), b.size())
	
	for i in size:
		result.append(a[i])
		result.append(b[i])
	
	return result

func get_text_for_mission_objective(resource:MissionBase):
	"Note minimum [color=%s] [b]  %s [/b] [/color]"
	var note = resource.goal
	var text = ""
	if resource.goal_is_for_x_student != -1:
		if note == 10:  
			if resource.goal_is_for_x_student == 1:
				text = "%s redoublant maximum"%int(len(resource.students) - resource.goal_is_for_x_student)
			else:
				text = "%s redoublants maximum"%int(len(resource.students) - resource.goal_is_for_x_student)
		elif note == 12: text = "Mentions \"Assez bien\" x %s"%resource.goal_is_for_x_student
		elif note ==  14: text = "Mentions \"Bien\" x %s"%resource.goal_is_for_x_student
		elif note == 16: text = "Mention \"Très Bien\" x %s"%resource.goal_is_for_x_student
		else: text = "Note minimum:[color=%s][b] %s/20[/b][/color]"%[get_color_for_note(note),note]
	else: text = "Note minimum:[color=%s][b] %s/20[/b][/color]"%[get_color_for_note(note),note]
	return text
