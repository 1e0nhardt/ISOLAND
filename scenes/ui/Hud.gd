extends CanvasLayer


func _on_texture_button_pressed():
	Globals.save()
	SceneTransition.transition_to_scene("res://scenes/ui/title_screen.tscn")
