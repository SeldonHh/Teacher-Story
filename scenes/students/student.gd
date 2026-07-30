extends CharacterBody2D
class_name Student

const SPRITE_ENNUI = preload("uid://1qgo66qnt5ib")
const SPRITE_HOVER_ENNUI = preload("res://assets/students/hover_ennui.png")
const SPRITE_STUPIDITE = preload("uid://c5arag4jnaelj")
const SPRITE_HOVER_STUPIDITE = preload("uid://b26vh50eoqmtb")
const LIFE_SPRITE_SCENE = preload("uid://dtlcn2mtrw7ax")
const NEGATIVE = preload("uid://bv8pp1gjig57k")
const POSITIVE = preload("uid://c7fuksru6dc66")
const ETAT_UI = preload("uid://curxcgjelduip")

@export var resource : StudentResource 

@onready var stupidite := resource.stupidite_de_base
@onready var ennui := resource.ennui_de_base
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
var untargetable: bool = false
var insensible := false
var bomb_damage := 0
var double_recieved_damage := false
var opposite_damage := false

func make_ui() -> void:
	$TextureRect.texture = resource.sprite
	for child in $HpContainer.get_children():
		child.queue_free()
	
	var positive_etat := false
	var negative_etat := false
	for etat in resource.etats:
		if etat.negative:
			negative_etat = true
		else:
			positive_etat = true
	if positive_etat:
		var new_etat = ETAT_UI.instantiate()
		new_etat.texture = POSITIVE
		$HpContainer.add_child(new_etat)
		new_etat.play_anim("Enter")
	if negative_etat:
		var new_etat = ETAT_UI.instantiate()
		new_etat.texture = NEGATIVE
		$HpContainer.add_child(new_etat)
		new_etat.play_anim("Enter")
	if negative_etat or positive_etat:
		var separator = TextureRect.new()
		separator.custom_minimum_size = Vector2(2,3)
		$HpContainer.add_child(separator)
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
	for etat in resource.etats:
		if etat.duration_min != -1:
			resource.etats.erase(etat)
	make_ui()

func add_shield(amount):
	if amount < 0:
		return
	if ennui < 0:
		ennui = 0
	ennui += amount
	make_ui()

func damage(amount: int, ennui_breaker: bool = false , ennui_only : bool = false,self_dot := false):
	if !insensible:
		if amount > 0:
			if opposite_damage:
				if amount >99:
					return
				add_shield(amount)
				return
			if double_recieved_damage:
				amount *= 2
			ManagerList.teacher_manager.damage_teacher(max(0,self_control_thorn-dealt_damage_reduction))
			amount = max(0,amount-received_damage_reduction)
			##REMOVE ON HIT ETATS
			resource.etats.erase(preload("uid://dsokypwo646yt"))
			resource.etats.erase(preload("uid://uiof0vmwkw0"))
			resource.etats.erase(preload("uid://qmbprjkljdg4"))
			resource.etats.erase(preload("uid://d278gv8ybhpns"))
		if ennui > 0 and !ennui_breaker:
			var reste = amount - ennui
			ennui -= amount
			if reste > 0 and !ennui_only:
				stupidite -= reste
		elif !ennui_only:
			stupidite -= amount
		if stupidite <= 0:
			if self_dot and bomb_damage > 0:
				bomb(bomb_damage)
			die()
			
		make_ui()


func die():
	showing_tooltip = false
	untargetable = true
	insensible = true
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
		child.queue_free()
	$HpContainer.hide()


func bomb(amount):
	var target : Desk
	for desk in ManagerList.desk_manager.desks:
		if desk.student == self:
			target = desk
	var neighbor_desks = ManagerList.desk_manager.get_all_neighbor_desk(target)
	for desk in neighbor_desks:
		if desk.student:
			desk.student.damage(amount)

func reset():
	stupidite = resource.stupidite_de_base
	ennui = resource.ennui_de_base
	untargetable = false
	insensible = false
	beaten = false
	modulate = Color("ffffff")
	for etat in resource.etats:
		if etat.duration_min != -1:
			resource.etats.erase(etat)
	make_ui()


var previous_etats := []
func _process(_delta: float) -> void:
	if Global.IS_DEBUG:
		if Input.is_action_just_pressed("debug"): # and resource.etats.has(preload("uid://bxeunpqmyn8ng")):
			ManagerList.teacher_manager.damage_teacher(0)
			resource.etats.append(preload("res://resource/Etats/Chantonne.tres"))
		if Input.is_action_just_pressed("debug2"):
			resource.etats.pop_front()
	
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
				if etat.insensible:
					insensible = false
				match etat.name:
					"Chouchou": Global.bottom_panel.reset_chouchou()
					"Bombe": bomb_damage -= 2
					"Illumination":double_recieved_damage = false
					"Largué":opposite_damage = false
				if etat.untargetable and beaten == false:
					for etat2 in resource.etats:
						if etat2.untargetable and etat != etat2:
							return
					untargetable = false
	
		if previous_etats.size() <= resource.etats.size():
			##DOES NOT ACCOUNT FOR DUPLICATE (if there's the same effect twice)
			var applied_etats = Global.array_difference(resource.etats,previous_etats)
			for etat in applied_etats:
				if insensible and etat.insensible:
					resource.etats.erase(etat)
					previous_etats = resource.etats.duplicate()
					return
				self_control_dot += etat.self_control_dot
				self_control_thorn += etat.self_control_thorn
				dealt_damage_reduction += etat.dealt_damage_reduction
				received_damage_reduction += etat.received_damage_reduction
				bonus_note_on_death += etat.bonus_note_on_death
				gain_ennui_par_tour += etat.gain_ennui_par_tour
				self_damage_dot += etat.self_damage_dot
				if etat.untargetable:
					untargetable = true
				if etat.insensible:
					insensible = true
				match etat.name:
					"Bombe": bomb_damage += 2
					"Illumination": double_recieved_damage = true
					"Largué": opposite_damage = true
		previous_etats = resource.etats.duplicate()
		make_ui()
		ManagerList.student_manager.student_tooltip.change(resource.student_name,resource.standing_sprite,stupidite,ennui,resource.note,resource.chouchou_skill,resource.etats)



func _on_mouse_detector_mouse_entered() -> void:
	for child in $HpContainer.get_children():
		if child is LifeSprite:
			if child.ennui == false:
				child.texture = SPRITE_HOVER_STUPIDITE
			elif child.ennui == true:
				child.texture = SPRITE_HOVER_ENNUI
			else:
				print("The texture of the hp of a astudent was FUCKING WRONG SOMEHOW")
		ManagerList.student_manager.student_tooltip.change(resource.student_name,resource.standing_sprite,stupidite,ennui,resource.note,resource.chouchou_skill,resource.etats)
		showing_tooltip = true


func _on_mouse_detector_mouse_exited() -> void:
	for child in $HpContainer.get_children():
		if child is LifeSprite:
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
	add_shield(gain_ennui_par_tour)
	damage(self_damage_dot,false,false,true)
	for etat in resource.etats:
		match etat.name:
			"Accélération":pass ##wait for student attacks
			"Clone":pass ##wait for student attacks
			"Copiage":pass ##wait for student attacks
			"Discute":pass ##i just don't wanna do it rn
			"Enervé":pass ##wait for student attacks
			"Enragé":pass ##wait for student attacks
			"Invisible":pass ##wait for students moving places
			"Mal au crâne":pass ##wait for student attacks
			"Démotivant": 
				var students = ManagerList.student_manager.students
				var filtered_students = []
				for student in students:
					if student.beaten == false and student != self and student.insensible == false:
						filtered_students.append(student)
				if filtered_students == []:
					return
				filtered_students.pick_random().add_shield(1)

			"Transfert vital": 
					var target : Desk
					var active_students = 0
					for desk in ManagerList.desk_manager.desks:
						if desk.student == self:
							target = desk
					var neighbor_desks = ManagerList.desk_manager.get_all_neighbor_desk(target)
					for desk in neighbor_desks:
						if desk.student:
							if desk.student.beaten == false and desk.student.insensible == false:
								active_students += 1
					ManagerList.teacher_manager.damage_teacher(-active_students)
