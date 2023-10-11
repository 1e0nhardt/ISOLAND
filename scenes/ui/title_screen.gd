extends TextureRect


func _enter_tree():
	get_node("/root/Hud").hide()


func _exit_tree():
	get_node("/root/Hud").show()


func _on_new_game_button_pressed():
	SceneTransition.transition_to_scene("res://scenes/game_scene/h_1.tscn")


func _on_continue_button_pressed():
	Globals.load_save_file()
	SceneTransition.transition_to_scene("res://scenes/game_scene/h_1.tscn")


func _on_quit_button_pressed():
	get_tree().quit()


