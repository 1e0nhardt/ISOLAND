extends Node

signal node_clicked(n: CircleNode)
signal game_data_loaded

const SAVE_FILE_PATH = "user://game.save"

var save_data: Dictionary
var h2a_animating = false
var h2a_move_speed = 500


class GameState:
    var state: Array = []

    func add_state(name):
        state.append(name)

    func has_state(name):
        if state.has(name):
            return true

        return false


func emit_node_clicked(n: CircleNode):
    node_clicked.emit(n)


func load_save_file():
    if FileAccess.file_exists(SAVE_FILE_PATH):
        var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
        save_data = file.get_var()

    inventory.deserialization(save_data["inventory"])
    game_states.state = save_data["states"]
    game_data_loaded.emit()

    print(save_data)
    print(inventory.current_item)


func save():
    save_data["inventory"] = inventory.serialization()
    save_data["states"] = game_states.state
    var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
    file.store_var(save_data)


class Inventory:
    signal item_collected
    signal item_removed(item: Item)

    var current_item: Item
    var active_flag = false
    var _items: Array[Item] = []
    var _current_index: int:
        set(value):
            if value == -1:
                current_item = null
            else:
                current_item = _items[value]

            _current_index = value


    func is_empty():
        return _items.is_empty()

    func count():
        return _items.size()

    func add_item(item: Item):
        _items.append(item)
        _current_index = count() - 1
        item_collected.emit()

    func remove_item():
        var removed_item = current_item
        var index = _items.find(removed_item)
        _items.remove_at(index)
        if !is_empty():
            select_prev_item()
        else:
            _current_index = -1
        item_removed.emit(removed_item)

    func select_next_item():
        _current_index = (_current_index + 1) % count()

    func select_prev_item():
        _current_index = (_current_index - 1 + count()) % count()

    func get_item_paths():
        var paths = []
        for item in _items:
            paths.append(item.resource_path)
        return paths

    func get_item_resources(paths):
        var items: Array[Item] = []
        for path in paths:
            items.append(load(path) as Item)
        return items

    func serialization():
        return {
            "active_flag": active_flag,
            "current_index": _current_index,
            "items": get_item_paths()
        }

    func deserialization(dict):
        active_flag = dict["active_flag"]
        _items = get_item_resources(dict["items"])
        _current_index = dict["current_index"]


var inventory = Inventory.new()
var game_states = GameState.new()

