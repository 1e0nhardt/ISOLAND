extends Area2D

const h2a_path = "res://scenes/game_scene/h_2a.tscn"

# @export var to_scene: PackedScene #? 切到H2后，H1的引用变为null了。
@export_file("*.tscn") var scene_path


func _input_event(viewport, event, shape_idx):
    if event.is_action_pressed("click"):
        # get_tree().change_scene_to_packed(to_scene)
        # get_tree().change_scene_to_file(scene_path)
        SceneTransition.transition_to_scene(scene_path)
