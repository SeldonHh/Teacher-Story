extends Resource
class_name MissionBase

@export var ideal_max_lesson = 4
@export_enum("easy","medium","hard","impossible") var difficulty
@export var reward = 50
@export var goal = 12
##-1 is for all students
@export var goal_is_for_x_student : int
@export var classname : String = "Cinquième K"
@export var matiere : String = "Histoire-Géo"
@export var students : Array = []
