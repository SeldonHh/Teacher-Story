extends TextureRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func play_anim(anim):
	animation_player.play(anim)
