extends Sprite2D
class_name CircleNode

signal move_finished

@export var false_texture: Texture
@export var true_texture: Texture
@export var true_index: int
@export var current_index: int

@onready var sprite: TextureButton = $Button

var init_texture
var init_index


func _ready():
    init_texture = false_texture
    init_index = current_index
    sprite.texture_normal = false_texture

    sprite.pressed.connect(on_pressed)


func reset():
    current_index = init_index
    change_texture(init_texture)


func check_correct():
    return current_index == true_index


func change_texture(t: Texture):
    sprite.texture_normal = t
    if check_correct():
        sprite.texture_normal = true_texture

    false_texture = t


func move_to(to_node: CircleNode):
    sprite.texture_normal = null

    Globals.h2a_animating = true
    var temp_sprite = Sprite2D.new()
    temp_sprite.texture = false_texture
    temp_sprite.z_index = 5
    # add_child位置对实际位置有影响
    add_child(temp_sprite)
    temp_sprite.global_position = global_position

    var distance = to_node.global_position - global_position
    var t = distance.length() / Globals.h2a_move_speed
    
    var tween = create_tween() # 感觉有点卡
    tween.set_process_mode(Tween.TWEEN_PROCESS_IDLE)
    tween.tween_property(temp_sprite, "global_position", to_node.global_position, t)
    await tween.finished
    temp_sprite.queue_free()
    Globals.h2a_animating = false
    
    to_node.current_index = current_index
    current_index = 0
    to_node.change_texture(false_texture)
    false_texture = null
    move_finished.emit()


func on_pressed():
    if Globals.h2a_animating:
        return

    Globals.emit_node_clicked(self)
