extends CanvasLayer

@onready var post_effect_rect = $ColorRect


func transition_in():
    (post_effect_rect.material as ShaderMaterial).set_shader_parameter("percent", 0.)
    var tween = create_tween()
    tween.tween_property(post_effect_rect.material, "shader_parameter/percent", 1., .3)\
    .set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
    tween.chain()
    await tween.finished


func transition_out():
    (post_effect_rect.material as ShaderMaterial).set_shader_parameter("screen_uv_scale", .97)
    (post_effect_rect.material as ShaderMaterial).set_shader_parameter("percent", 1.)
    var tween = create_tween()
    tween.set_parallel()
    tween.tween_property(post_effect_rect.material, "shader_parameter/percent", 0., .3)\
    .set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
    tween.tween_property(post_effect_rect.material, "shader_parameter/screen_uv_scale", 1., .3)\
    .set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
    tween.chain()


func transition_to_scene(scene_path: String):
    AudioManager.stop_playing()
    transition_in()
    get_tree().change_scene_to_file(scene_path)
    transition_out()