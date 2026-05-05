extends Node

var max_time : int = 10
var remaining_time : int = max_time

func update_time(amount):
	remaining_time += amount
	if remaining_time <= 0:
		stop_class()

func stop_class():
	%StudentManager.reset_all_students()
	remaining_time = max_time

func _ready() -> void:
	ManagerList.timer_manager = self
