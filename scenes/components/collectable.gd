extends Area2D

@export var item: Item


func _input_event(viewport, event, shape_idx):
    if event.is_action_pressed("click"):
        Globals.inventory.add_item(item)

        if item.name == "key":
            Globals.game_states.add_state("key_collected")
            Globals.save()

        if item.name == "mail_piece":
            Globals.game_states.add_state("mail_piece_collected")
            Globals.save()

        queue_free()
