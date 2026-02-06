extends Control

func init(title,text,color,title_color,text_color):
	%Title.modulate = title_color
	%Description.modulate = text_color
	%Title.text = title
	%Description.text = text
	$Panel.self_modulate = color


func _ready() -> void:
	self.hide()
