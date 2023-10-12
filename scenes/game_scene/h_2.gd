extends Sprite2D

const DIALOG_A: Array[String] = [
    "我年纪大了，很多事情想不起来了。",
    "你是谁？算了，我也不在乎你是谁。你能帮我找到信箱的钥匙吗？",
    "老头子说最近会给我寄船票过来，叫我和他一起出去看看。虽然我没有什么兴趣...",
    "他折腾了一辈子，不是躲在楼上捣鼓什么时间机器，就是出海找点什么东西。",
    "这些古怪的电视节目真没有什么意思。",
    "老头子说这个岛上有很多秘密，其实我知道，不过是岛上的日子太孤独，他找点事情做罢了。",
    "人嘛，谁没有年轻过。年轻的时候...算了，不说这些往事了。",
    "老了才明白，万物静默如迷。"
]

const DIALOG_B: Array[String] = ["没想到老头子的船票寄过来了，谢谢你。"]

@onready var dialog_box = $DialogBox
@onready var dialog_label = $DialogBox/Button

var dialog_index
var dialog_flag
var dialogs = []


func _ready():
    if Globals.game_states.has_state("key_collected"):
        $Key.queue_free()

    dialog_index = -1
    dialog_flag = false
    dialogs = DIALOG_A

    dialog_box.dialog_clicked.connect(on_dialog_clicked)

    if Globals.game_states.has_state("game_cleared") and !Globals.game_states.has_state("open_door_played"):
        $AnimationPlayer.play("open_the_door")
        await $AnimationPlayer.animation_finished
        Globals.game_states.add_state("open_door_played")

    if Globals.game_states.has_state("open_door_played"):
        show_way()


func show_way():
    $ToH2A.hide()
    $ToH3.show()


func show_dialog():
    AudioManager.stop_playing()
    dialog_index += 1

    if !dialog_flag:
        dialog_flag = true
        dialog_box.show()

    if dialog_index == dialogs.size():
        dialog_box.hide()
        dialog_flag = false
        dialog_index = -1
        return

    dialog_label.text = dialogs[dialog_index]
    dialog_box.animate_dialog()
    AudioManager.play_gibberish(dialogs[dialog_index])


func _on_granny_input_event(viewport:Node, event:InputEvent, shape_idx:int):
    if !event.is_action_pressed("click"):
        return

    if Globals.inventory.active_flag == true and "mail_piece" == Globals.inventory.current_item.name:
        Globals.inventory.active_flag = false
        Globals.inventory.remove_item()
        dialogs = DIALOG_B
        dialog_index = -1
        show_dialog()
        return

    show_dialog()


func on_dialog_clicked():
    show_dialog()
