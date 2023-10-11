extends Area2D

signal item_interacted(item: Item)

@export var item: Item


func _input_event(viewport, event, shape_idx):
    if event.is_action_pressed("click"):
        if !Globals.inventory.active_flag:
            return

        if item.name == Globals.inventory.current_item.name:
            Globals.inventory.active_flag = false
            Globals.inventory.remove_item()
            queue_free()
