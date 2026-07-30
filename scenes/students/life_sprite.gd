extends TextureRect
class_name LifeSprite
var ennui = false

func play_anim(anim):
	if anim == "leave":
		var tween = get_tree().create_tween()
		tween.tween_property(self,"position",position+Vector2(0,-16),.3)
		tween.tween_callback(queue_free)
