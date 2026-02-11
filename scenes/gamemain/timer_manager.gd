extends Node

@onready var remaining_time_label: Label = $"../RemainingTimeLabel"
var max_time : int = 20
var remaining_time : int = max_time

func update_time(amount):
	remaining_time += amount
	remaining_time_label.text = str(max(0,remaining_time))
	if remaining_time <= 0:
		stop_class()

func stop_class():
	%StudentManager.reset_all_students()
	remaining_time = max_time

func _ready() -> void:
	remaining_time_label.text = str(max(0,remaining_time))
	ManagerList.timer_manager = self
