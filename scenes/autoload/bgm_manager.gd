extends AudioStreamPlayer

@export var bgms: Array[AudioStream]


func _ready():
    stream = bgms[0]
    play()


func change_bgm(index: int):
    if index >= bgms.size():
        return
        
    stream = bgms[index]
    play()