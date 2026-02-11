extends Button
class_name Student

enum CaractereType {Reveur,Jovial,Malin,Timide,Clown,Bruyant,Manipulateur,Hyperactif}

const SPRITE_ENNUI = preload("uid://1qgo66qnt5ib")
const SPRITE_HOVER_ENNUI = preload("res://assets/students/hover_ennui.png")
const SPRITE_STUPIDITE = preload("uid://c5arag4jnaelj")
const SPRITE_HOVER_STUPIDITE = preload("uid://b26vh50eoqmtb")
const LIFE_SPRITE_SCENE = preload("res://scenes/students/life_sprite.tscn")

@export var caractere: CaractereType = CaractereType.Reveur

@export var stupidite_de_base := 3
@onready var stupidite := stupidite_de_base
@export var ennui_de_base := 2
@onready var ennui := ennui_de_base
@export var student_name := "Michel"
@export var note: float = 10
var untouchable: bool = false
var current_rank: int = 2 ##valeur entre 0 et 2, 0 c'est le dernier rang, 2 celui de devant
var bonus_note_on_death: int = 0
@export var sprite: Texture2D = preload("res://assets/students/guy1.png")

func make_ui() -> void:
	for child in $HpContainer.get_children():
		child.queue_free()
	
	if not untouchable:
		for i in stupidite:
			var new_child = LIFE_SPRITE_SCENE.instantiate()
			new_child.texture = SPRITE_STUPIDITE 
			$HpContainer.add_child(new_child)
		
		for i in ennui:
			var new_child = LIFE_SPRITE_SCENE.instantiate()
			new_child.texture = SPRITE_ENNUI 
			new_child.ennui = true
			$HpContainer.add_child(new_child)

func _ready() -> void:
	make_ui()
	$Student_Tooltip.init(student_name,"Caractère: %s"%CaractereType.keys()[caractere],Color("#211f26"),Color("3098edff"),Color("959595ff"))
	$TextureRect.texture = sprite

func damage(amount: int, ennui_breaker: bool = false , ennui_only : bool = false):
	if !untouchable:
		if ennui > 0 and !ennui_breaker:
			var reste = amount - ennui
			ennui -= amount
			if reste > 0 and !ennui_only:
				stupidite -= reste
		elif !ennui_only:
			stupidite -= amount
		if stupidite <= 0:
			die()
			
		make_ui()


func die():
	untouchable = true
	note += 1 * current_rank + bonus_note_on_death
	modulate = Color("5f5f5f")
	for child in $HpContainer.get_children():
		if child is TextureRect:
			child.queue_free()

func reset():
	stupidite = stupidite_de_base
	ennui = ennui_de_base
	untouchable = false
	modulate = Color("ffffff")
	make_ui()

func _process(_delta: float) -> void:
	if Global.IS_DEBUG:
		if Input.is_action_just_pressed("debug"):
			damage(1)
		if Input.is_action_just_pressed("debug2"):
			reset()


func _on_mouse_entered() -> void:
	for child in $HpContainer.get_children():
		if child.ennui == false:
			child.texture = SPRITE_HOVER_STUPIDITE
		elif child.ennui == true:
			child.texture = SPRITE_HOVER_ENNUI
		else:
			print("The texture of the hp of a astudent was FUCKING WRONG SOMEHOW")
	$Student_Tooltip.show()


func _on_mouse_exited() -> void:
	for child in $HpContainer.get_children():
		if child.ennui == false:
			child.texture = SPRITE_STUPIDITE
		elif child.ennui == true:
			child.texture = SPRITE_ENNUI
		else:
			print("The texture of the hp of a student was FUCKING WRONG SOMEHOW")
	$Student_Tooltip.hide()
