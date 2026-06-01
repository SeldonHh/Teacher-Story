extends Node

@onready var IS_DEBUG = "debug" in OS.get_cmdline_args()
enum CaractereType {GrosDormeur,Insolent,CassePied,Intello,Musqué,Nul,OeuilDeLynx,SansGene,Timide,TresBavard}

const HISTORY_CLASS_CAMERA_OFFSET : Vector2i = Vector2i(-12,15)
const MATH_CLASS_CAMERA_OFFSET : Vector2i = Vector2i(-258,138)
const SCIENCE_CLASS_CAMERA_OFFSET : Vector2i = Vector2i(-400,235)
const DEBUG_CHOUCHOU_SKILL: SkillResource = preload("res://resource/Skills/chouchou_skills/CoupDeCoude.tres")
const BAG_SPRITES = [preload("uid://cxd8ggqp0omqk"),preload("uid://u78sx6xejio6"),preload("uid://cc75phnlu02nq"),preload("uid://88w24qm8hg25")]

var DEBUG_SKIP_MISSION_SELECTION = false

var bottom_panel : Control

var skill_list :Array[Control]= []

var special_skill_list : Array[SkillResource] = [
	preload("uid://c0ap80fbge1w2"),
	preload("uid://cyxmb24neumti")
]

var skill_resource_list: Array[SkillResource] = [
	preload('uid://ceubcahowtp87'),
	preload('uid://c8u8a65r1rt1s'),
	preload('uid://3mw2n4es48sm'),
	preload('uid://cu1vdts2y2rv7'),
	preload("uid://du8fw0pvf2ns2"),
	preload("uid://2bowsbefe021"),
]
var chouchou_resource_list : Array[SkillResource] = [
	preload("uid://pa2p2muslkui"),
	preload("uid://db0v660vlwixt"),
	preload("uid://dmw45mwkuto08"),
	preload("uid://xgcfr2shtvk3"),
	preload("uid://2tgfrebk2var"),
	preload("uid://bdum1fxo3q3bk"),
	preload("uid://g5xl02df7pyq"),
	preload("uid://dhddmgbolb51h"),
	preload("uid://1sxv8dg0brj0"),
	preload("uid://ddcxsr1x4xldm"),
	preload("uid://btnb6x8nfuw7c"),
	preload("uid://bv4m11lil1tpo"),
	preload("uid://4m8ll6cf5ovk"),
	preload("uid://dfrelqlpwkj1o"),
]

var chouchou_skills : Dictionary = {
	CaractereType.GrosDormeur : [chouchou_resource_list[0]],
	CaractereType.Insolent : [chouchou_resource_list[1]],
	CaractereType.CassePied : [chouchou_resource_list[2]],
	CaractereType.Intello : [chouchou_resource_list[3]],
	CaractereType.Musqué : [chouchou_resource_list[4],chouchou_resource_list[5]],
	CaractereType.Nul : [chouchou_resource_list[6],chouchou_resource_list[7],chouchou_resource_list[8]],
	CaractereType.OeuilDeLynx : [chouchou_resource_list[9],chouchou_resource_list[10],chouchou_resource_list[11]],
	CaractereType.SansGene : [chouchou_resource_list[7]],
	CaractereType.Timide : [chouchou_resource_list[12]],
	CaractereType.TresBavard : [chouchou_resource_list[13]],
}
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
