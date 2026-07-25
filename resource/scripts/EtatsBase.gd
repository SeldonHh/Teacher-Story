extends Resource
class_name EtatsResource

@export var name : String
@export var cleanable : int = 0
@export var desc : String
@export var critical := false
## if false, etats is positive
@export var negative := true
## if -1 etats stays for future classes 
@export var duration_min := 999
@export var duration_max := 999
@export_category("effect")
@export var self_control_dot := 0
@export var self_control_thorn := 0
@export var received_damage_reduction := 0
@export var dealt_damage_reduction := 0
@export var bonus_note_on_death := 0
@export var gain_ennui_par_tour := 0
@export var self_damage_dot := 0
@export var untargetable := false
@export var insensible := false
