extends CharacterBody2D

@onready var body: AnimatedSprite2D = $body
var speed := 1800.0
var back := false
@export var classroom_instance := false
@export var teacher_room_instance := false
@export var home_instance := false

func _ready() -> void:
	if classroom_instance:
		z_index +=1
		ManagerList.teacher_manager.james_classroom_instance = self
	elif teacher_room_instance:
		body.play("cravate")
		body.stop()
		body.flip_h = true
		ManagerList.teacher_manager.james_teacher_room_instance = self
	elif home_instance:
		ManagerList.teacher_manager.james_home_instance = self
		body.play("cravate")
		body.stop()
	else:
		print("JAMES HAS GONE ROGUE WTF")

func _process(delta: float) -> void:
	if Global.IS_DEBUG:
		var direction = Input.get_vector("debug_james_left","debug_james_right","debug_james_up","debug_james_down")
		if direction:
			velocity = velocity.lerp(direction * speed * delta,.3)
			if direction.x < 0:
				body.flip_h = true
			else:
				body.flip_h = false
			if direction.y < 0:
				back = true
			else:
				back = false
			update_anim()
		else:
			velocity = velocity.lerp(Vector2.ZERO,.2)
	
	move_and_slide()



func update_anim():
	if Input.is_action_pressed("debug_james_up"):
		body.animation = "walk_back"
	elif Input.is_action_pressed("debug_james_down"):
		body.animation = "walk_front"

	body.flip_h = false if velocity.x > 0 else true
	if !body.is_playing():
		body.play()
		
