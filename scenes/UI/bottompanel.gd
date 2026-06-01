extends Control

@onready var remaining_time_label: Label = %RemainingTimeLabel
@onready var remaining_health_label: Label = %RemainingHealthLabel
@onready var health_bar: TextureProgressBar = %HealthBar
@onready var time_bar_top: TextureProgressBar = %TimeBarTop
@onready var time_bar_bottom: TextureProgressBar = %TimeBarBottom
@onready var health_bar_highlight: TextureProgressBar = %HealthBar_Highlight
@onready var health_particle: CPUParticles2D = %HealthParticle
@onready var time_particle: CPUParticles2D = %TimeParticle
@onready var skill_container: HBoxContainer = $SkillContainer

var max_time = 10
var last_time := -1.0
var last_life := -1.0

func _ready() -> void:
	Global.bottom_panel = self
	ManagerList.timer_manager.updated_time.connect(randomize_skills)
	health_bar.max_value = ManagerList.teacher_manager.max_teacher_life
	health_bar_highlight.max_value = ManagerList.teacher_manager.max_teacher_life
	health_bar.value = health_bar.max_value
	health_bar_highlight.value = health_bar_highlight.max_value

	time_bar_top.max_value = max_time
	time_bar_top.value = max_time
	time_bar_bottom.max_value = max_time
	time_bar_bottom.value = 0
	
	last_life = ManagerList.teacher_manager.max_teacher_life
	last_time = max_time

func randomize_skills():
	var possible_skills = Global.skill_resource_list.duplicate()
	for skill in possible_skills:
		if skill.current_cooldown != 0:
			possible_skills.erase(skill)
	for child in skill_container.get_children():
		if possible_skills == []:
			print("ERROR THERE WERE NOT ENOUGH POSSIBLE SKILLS")
		var skill = possible_skills.pick_random()
		child.resource = skill
		possible_skills.erase(skill)

func _process(_delta: float) -> void:
	
	var time = ManagerList.timer_manager.remaining_time
	var life = ManagerList.teacher_manager.teacher_life
	
	remaining_time_label.text = str(max(0, time))
	remaining_health_label.text = str(max(0,life))
	
	if time != last_time:
		_update_time_bars(time)
		last_time = time
	if life != last_life:
		_update_health_bar(life)
		last_life = life


func _update_health_bar(life:float) -> void:
	var tween = create_tween()
	tween.tween_property(health_bar, "value", life, 0.3)
	tween.tween_callback(hacky_shit.bind(life))
	health_particle.emitting = true
	
func hacky_shit(life:float):
	await get_tree().create_timer(.1).timeout
	var tween = create_tween()
	tween.tween_property(health_bar_highlight, "value", life, 0.3)

func _update_time_bars(time: float) -> void:
	time_particle.emitting = true
	await  get_tree().create_timer(time_particle.lifetime-.1).timeout
	var tween = create_tween()
	tween.set_parallel(true)

	tween.tween_property(time_bar_top, "value", time, 0.3)
	tween.tween_property(time_bar_bottom, "value", max_time - time, 0.3)
