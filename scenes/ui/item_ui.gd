extends MarginContainer

@onready var left_button = %LeftArrowButton
@onready var right_button = %RightArrowButton
@onready var item_button = %ItemButton
@onready var item_sprite = %Item
@onready var hand_sprite = %Hand
@onready var description_label = %Label
@onready var animation_player = $AnimationPlayer


func _ready():
    Globals.inventory.item_collected.connect(on_item_collected)
    Globals.inventory.item_removed.connect(on_item_removed)
    Globals.game_data_loaded.connect(on_game_data_loaded)
    hand_sprite.hide()
    item_sprite.hide()
    update_ui()


func update_ui():
    var current_item = Globals.inventory.current_item
    left_button.disabled = Globals.inventory.count() < 2
    right_button.disabled = Globals.inventory.count() < 2
    item_button.disabled = current_item == null

    if current_item != null:
        item_sprite.texture = current_item.texture
        if item_sprite.visible == false:
            item_sprite.show()
            item_sprite.scale = Vector2.ZERO
            var tween = create_tween()
            tween.tween_property(item_sprite, "scale", Vector2.ONE, .3)\
            .set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)



func toggle_hand_visibility(current_flag: bool):
    if current_flag:
        hand_sprite.hide()
        Globals.inventory.active_flag = false
    else:
        hand_sprite.show()
        Globals.inventory.active_flag = true


func on_item_collected():
    update_ui()


func on_item_removed(item: Item):
    item_sprite.hide()
    toggle_hand_visibility(true)
    update_ui()


func _on_right_arrow_button_pressed():
    Globals.inventory.select_next_item()
    item_sprite.texture = Globals.inventory.current_item.texture


func _on_left_arrow_button_pressed():
    Globals.inventory.select_prev_item()
    item_sprite.texture = Globals.inventory.current_item.texture


func _on_item_button_pressed():
    if Globals.inventory.current_item == null:
        return

    description_label.text = Globals.inventory.current_item.description
    animation_player.play("default")
    toggle_hand_visibility(Globals.inventory.active_flag)


func on_game_data_loaded():
    update_ui()
