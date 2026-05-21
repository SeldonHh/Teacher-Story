extends CharacterBody2D
class_name Student

const SPRITE_ENNUI = preload("uid://1qgo66qnt5ib")
const SPRITE_HOVER_ENNUI = preload("res://assets/students/hover_ennui.png")
const SPRITE_STUPIDITE = preload("uid://c5arag4jnaelj")
const SPRITE_HOVER_STUPIDITE = preload("uid://b26vh50eoqmtb")
const LIFE_SPRITE_SCENE = preload("uid://dtlcn2mtrw7ax")

@export var resource : StudentResource 

@onready var stupidite := resource.stupidite_de_base
@onready var ennui := resource.ennui_de_base
var untouchable: bool = false
var current_rank: int = 2 ##valeur entre 0 et 2, 0 c'est le dernier rang, 2 celui de devant
var bonus_note_on_death: int = 0
@onready var mouse_detector: Area2D = %"Mouse detector"
var showing_tooltip := false

func make_ui() -> void:
	$TextureRect.texture = resource.sprite
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
	%"Mouse detector".connect("custom_mouse_enter",_on_mouse_detector_mouse_entered)
	%"Mouse detector".connect("custome_mouse_exit",_on_mouse_detector_mouse_exited)
	make_ui()

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
	resource.note += 1 * current_rank + bonus_note_on_death
	if resource.note >20:
		resource.note = 20
	elif resource.note <0:
		resource.note = 0
	ManagerList.student_manager.update_info_labels()
	modulate = Color("5f5f5f")
	for child in $HpContainer.get_children():
		if child is TextureRect:
			child.queue_free()

func reset():
	stupidite = resource.stupidite_de_base
	ennui = resource.ennui_de_base
	untouchable = false
	modulate = Color("ffffff")
	make_ui()

func _process(_delta: float) -> void:
	if Global.IS_DEBUG:
		if Input.is_action_just_pressed("debug"):
			damage(1)
		if Input.is_action_just_pressed("debug2"):
			reset()
	if showing_tooltip:
		ManagerList.student_manager.student_tooltip.show()


func _on_mouse_detector_mouse_entered() -> void:
	for child in $HpContainer.get_children():
		if child.ennui == false:
			child.texture = SPRITE_HOVER_STUPIDITE
		elif child.ennui == true:
			child.texture = SPRITE_HOVER_ENNUI
		else:
			print("The texture of the hp of a astudent was FUCKING WRONG SOMEHOW")
	ManagerList.student_manager.student_tooltip.change(resource.student_name,resource.standing_sprite,stupidite,ennui,resource.note,get_caractere_text())
	showing_tooltip = true

func get_caractere_text():
	var text = Global.CaractereType.keys()[resource.caractere]
	var new_text = ""
	for carac in text:
		if carac == carac.to_upper():
			new_text += " "
		new_text += carac
	return new_text

func _on_mouse_detector_mouse_exited() -> void:
	for child in $HpContainer.get_children():
		if child.ennui == false:
			child.texture = SPRITE_STUPIDITE
		elif child.ennui == true:
			child.texture = SPRITE_ENNUI
		else:
			print("The texture of the hp of a student was FUCKING WRONG SOMEHOW")
	showing_tooltip = false
	ManagerList.student_manager.student_tooltip.hide()
