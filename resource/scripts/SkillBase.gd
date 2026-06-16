extends Resource
class_name SkillResource

@export_category("id")
@export var name := "Placeholder"
@export var sprite := preload("res://assets/skills/EnseignerIcon.png")
@export var description := "If you see this, this is a bug, please report it"

@export_category("effect")
@export var damage_modifier := 2
@export var secondary_damage_modifier := 0
@export_enum("Single","Table","Column","All","Self","Two Students","Student and Desk","Single Desk") var target = "Single"
@export var cooldown := 2
@export var bonus_note := 0 
@export var ennui_only := false
@export var ennui_breaker := false
@export var fast_skill := false

#negatives
@export var heal_modifier := 0
@export var shield_modifier := 0

@export var current_cooldown := 0
