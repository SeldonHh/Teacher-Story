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
var beaten := false
var cant_act := false

##etats modifiers:
var self_control_dot := 0
var self_control_thorn := 0
var dealt_damage_reduction := 0
var received_damage_reduction := 0
var gain_ennui_par_tour := 0
var self_damage_dot := 0

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

func add_shield(amount):
	if amount < 0:
		return
	if ennui < 0:
		ennui = 0
	ennui += amount
	make_ui()

func damage(amount: int, ennui_breaker: bool = false , ennui_only : bool = false):
	if !untouchable:
		if amount > 0:
			ManagerList.teacher_manager.damage_teacher(max(0,self_control_thorn-dealt_damage_reduction))
			amount = max(0,amount-received_damage_reduction)
			resource.etats.erase(preload("uid://dsokypwo646yt"))
			resource.etats.erase(preload("uid://uiof0vmwkw0"))
			resource.etats.erase(preload("uid://qmbprjkljdg4"))
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
	beaten = true
	resource.note += 1 * current_rank + bonus_note_on_death
	if resource.note >20:
		resource.note = 20
	elif resource.note <0:
		resource.note = 0
	ManagerList.student_manager.update_info_labels()
	modulate = Color("5f5f5f")
	for etat in resource.etats:
		if etat.duration_min != -1:
			resource.etats.erase(etat)
	for child in $HpContainer.get_children():
		if child is TextureRect:
			child.queue_free()

func reset():
	stupidite = resource.stupidite_de_base
	ennui = resource.ennui_de_base
	untouchable = false
	beaten = false
	modulate = Color("ffffff")
	make_ui()


var previous_etats := []
func _process(_delta: float) -> void:
	if Global.IS_DEBUG:
		if Input.is_action_just_pressed("debug"):
			damage(1)
			resource.etats.append(preload("uid://ckt4vj7fdvosn"))
		if Input.is_action_just_pressed("debug2"):
			resource.etats.pop_front()

	if showing_tooltip:
		ManagerList.student_manager.student_tooltip.show()
	
	if resource.etats == previous_etats:
		return
	else:
		if previous_etats.size() >= resource.etats.size():
			##DOES NOT ACCOUNT FOR DUPLICATE (if there's the same effect twice)
			var cleansed_etats = Global.array_difference(previous_etats,resource.etats)
			for etat in cleansed_etats:
				self_control_dot -= etat.self_control_dot
				self_control_thorn -= etat.self_control_thorn
				dealt_damage_reduction -= etat.dealt_damage_reduction
				received_damage_reduction -= etat.received_damage_reduction
				bonus_note_on_death -= etat.bonus_note_on_death
				gain_ennui_par_tour -= etat.gain_ennui_par_tour
				self_damage_dot -= etat.self_damage_dot
				match etat.name:
					"Chouchou": Global.bottom_panel.reset_chouchou()
				
	
		if previous_etats.size() <= resource.etats.size():
			##DOES NOT ACCOUNT FOR DUPLICATE (if there's the same effect twice)
			var applied_etats = Global.array_difference(resource.etats,previous_etats)
			for etat in applied_etats:
				self_control_dot += etat.self_control_dot
				self_control_thorn += etat.self_control_thorn
				dealt_damage_reduction += etat.dealt_damage_reduction
				received_damage_reduction += etat.received_damage_reduction
				bonus_note_on_death += etat.bonus_note_on_death
				gain_ennui_par_tour += etat.gain_ennui_par_tour
				self_damage_dot += etat.self_damage_dot
				
		previous_etats = resource.etats.duplicate()



func _on_mouse_detector_mouse_entered() -> void:
	for child in $HpContainer.get_children():
		if child.ennui == false:
			child.texture = SPRITE_HOVER_STUPIDITE
		elif child.ennui == true:
			child.texture = SPRITE_HOVER_ENNUI
		else:
			print("The texture of the hp of a astudent was FUCKING WRONG SOMEHOW")
	ManagerList.student_manager.student_tooltip.change(resource.student_name,resource.standing_sprite,stupidite,ennui,resource.note,resource.caractere)
	showing_tooltip = true


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

func time_passed():
	if cant_act or beaten:
		return
	ManagerList.teacher_manager.damage_teacher(max(0,self_control_dot-dealt_damage_reduction))
	damage(-gain_ennui_par_tour)
	damage(self_damage_dot)
	for etat in resource.etats:
		match etat.name:
			"Accélération":pass ##wait for student attacks
			"Bombe":pass
			"Clone":pass ##wait for student attacks
			"Copiage":pass ##wait for student attacks
			"Discute":pass
			"Démotivant":pass
			"Endormi":pass #CRITIQUE KO
			"Enervé":pass ##wait for student attacks
			"Enragé":pass ##wait for student attacks
			"Illumination":pass
			"Invisible":pass
			"KO":pass #CRITIQUE KO
			"Largué":pass
			"Mal au crâne":pass ##wait for student attacks
			"Transfert vital": pass
			"Tétanisé":pass #CRITIQUE KO
