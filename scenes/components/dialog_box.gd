extends Control

signal dialog_clicked

@onready var button = $Button


func _on_button_gui_input(event:InputEvent):
    if event.is_action_pressed("click"):
        dialog_clicked.emit()


func animate_dialog():
    var tween = create_tween()
    button.pivot_offset = Vector2(0., button.size.y)
    tween.tween_property(button, "scale", Vector2.ZERO, 0.)
    tween.tween_property(button, "scale", Vector2.ONE, .4)\
    .set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
