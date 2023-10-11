extends Sprite2D

const LINE_WIDTH = 32
const CIRCLE_RADIUS = 80
const LINES = [
    [3, 4], [1, 2], [0, 6], [5, 6],
    [0, 1], [0, 2], [0, 3], [0, 4],
    [4, 6], [0, 5], [1, 3], [1, 6]
]

@onready var ss_nodes = [$SS00, $SS01, $SS02, $SS03, $SS04, $SS05, $SS06]

@export var line_texture: Texture

var empty_node: CircleNode


func _enter_tree():
    BgmManager.change_bgm(1)


func _exit_tree():
    BgmManager.change_bgm(0)


func _ready():
    empty_node = ss_nodes[0]

    for l in LINES:
        add_line(ss_nodes[l[0]], ss_nodes[l[1]])

    Globals.node_clicked.connect(on_node_clicked)


func add_line(start, end):
    var start_pos = start.global_position
    var end_pos = end.global_position

    # 父节点(背景)的Transform属性调整。 PS:将toplevel设为true也行。位置关系直接和父节点解绑。
    start_pos -= Vector2(960, 540)
    end_pos -= Vector2(960, 540)

    var direction = (end_pos - start_pos).normalized()
    var line = Line2D.new()
    line.add_point(start_pos + direction * CIRCLE_RADIUS)
    line.add_point(end_pos - direction * CIRCLE_RADIUS)
    line.width = LINE_WIDTH
    line.texture = line_texture
    line.texture_mode = Line2D.LINE_TEXTURE_STRETCH
    add_child(line)


func restart():
    for node in ss_nodes:
        node.reset()

    empty_node = ss_nodes[0]


func check_connection(start: CircleNode, end: CircleNode):
    var connection = [start.true_index, end.true_index]
    for line in LINES:
        if (line[0] == connection[0] and line[1] == connection[1])\
            or (line[0] == connection[1] and line[1] == connection[0]):
            print("Move", connection)
            return true

    return false


func check_victory():
    for node in ss_nodes:
        if !node.check_correct():
            return false

    return true


func try_move(n: CircleNode):
    if !check_connection(empty_node, n):
        return

    n.move_to(empty_node)
    await n.move_finished
    empty_node = n

    if check_victory():
        Globals.game_states.add_state("game_cleared")
        SceneTransition.transition_to_scene("res://scenes/game_scene/h_2.tscn")


func on_node_clicked(n: CircleNode):
    try_move(n)


func _on_gear_pressed():
    restart()
