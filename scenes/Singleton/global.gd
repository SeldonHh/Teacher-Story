extends Node

@onready var IS_DEBUG = "debug" in OS.get_cmdline_args()
enum CaractereType {GrosDormeur,Insolent,CassePied,Intello,Musqué,Nul,OeuilDeLynx,SansGene,Timide,TresBavard}

const HISTORY_CLASS_CAMERA_OFFSET : Vector2i = Vector2i(-12,15)
const MATH_CLASS_CAMERA_OFFSET : Vector2i = Vector2i(-258,138)
const SCIENCE_CLASS_CAMERA_OFFSET : Vector2i = Vector2i(-400,235)

const BAG_SPRITES = [preload("uid://cxd8ggqp0omqk"),preload("uid://u78sx6xejio6"),preload("uid://cc75phnlu02nq"),preload("uid://88w24qm8hg25")]

var DEBUG_SKIP_MISSION_SELECTION = false

var skill_list :Array[Control]= []

var skill_resource_list: Array[SkillResource] = [
	preload('uid://ceubcahowtp87'),
	preload('uid://c8u8a65r1rt1s'),
	preload('uid://3mw2n4es48sm'),
	preload('uid://cu1vdts2y2rv7'),
	preload("uid://du8fw0pvf2ns2"),
	preload("uid://2bowsbefe021"),
]

var boy_student_sprites = [
	[preload("uid://bwi8bwxynmh7u"),preload("uid://bem8j4deoqc66")],
	]
var girl_student_sprites = [
	[preload("uid://cjc7we37vb0w0"),preload("uid://b45tk8ot7j4tc")],
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
