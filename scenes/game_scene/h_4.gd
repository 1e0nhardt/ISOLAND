extends Sprite2D

var mail_open = preload("res://assets/H4/mailBox_open.png")


func _ready():
    if Globals.game_states.has_state("mail_opened"):
        $MailBox.texture = mail_open
        $MailPieceArea.show()
        
    if Globals.game_states.has_state("mail_piece_collected"):
        $MailPieceArea.hide()

    Globals.inventory.item_removed.connect(on_item_removed)


func on_item_removed(item: Item):
    if item.name == "key":
        $MailBox.texture = mail_open
        $MailPieceArea.show()
        Globals.game_states.add_state("mail_opened")
