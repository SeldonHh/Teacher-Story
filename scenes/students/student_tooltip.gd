extends Control
@onready var up_sprite: TextureRect = $Panel/up_sprite
@onready var name_label: RichTextLabel = %Name
@onready var hp_container: HBoxContainer = $Panel/HpContainer
@onready var note_label: RichTextLabel = %Note
@onready var caractere_label: RichTextLabel = %Caractere
@onready var etat_container: HBoxContainer = $Panel/EtatContainer
const SPRITE_ENNUI = preload("uid://1qgo66qnt5ib")

var life_sprite = preload("uid://dtlcn2mtrw7ax")

func change(student_name,standing_sprite,life_amount,shield_amount,note,chouchou_skill,etats):
	for node in hp_container.get_children():
		hp_container.remove_child(node)
		node.queue_free()
	for node in etat_container.get_children():
		etat_container.remove_child(node)
		node.queue_free()
	name_label.text = student_name
	up_sprite.texture = standing_sprite
	for i in life_amount:
		var life = life_sprite.instantiate()
		life.expand_mode = TextureRect.EXPAND_KEEP_SIZE
		hp_container.add_child(life)
	for i in shield_amount:
		var shield = life_sprite.instantiate()
		shield.ennui = true
		shield.texture = SPRITE_ENNUI
		shield.expand_mode = TextureRect.EXPAND_KEEP_SIZE
		hp_container.add_child(shield)
	for etat in etats:
		var label = Label.new()
		label.text = etat.name + "  "
		label.add_theme_constant_override("shadow_outline_size",18)
		label.add_theme_constant_override("outline_size",4)
		label.add_theme_font_size_override("font_size",10)
		if etat.negative:
			label.add_theme_color_override("font_color",Color(0.91, 0.758, 0.0, 1.0))
		else:
			label.add_theme_color_override("font_color",Color(0.231, 0.961, 0.0, 1.0))
		etat_container.add_child(label)
	note_label.text = "%s/20"%int(note)
	caractere_label.text = get_caractere_text(chouchou_skill.name)

func get_caractere_text(text):
	var new_text = ""
	for carac in text:
		if carac == carac.to_upper():
			new_text += " "
		new_text += carac
	return new_text
