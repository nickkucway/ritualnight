extends Area

func _on_fallzone_body_entered(body):
	if body.name == 'Player':
		get_tree().change_scene("res://endingscreen.tscn")

