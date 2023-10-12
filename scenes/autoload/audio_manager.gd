extends Node

const AUDIO_LOOK_UP = {
    "a": 0, "ai": 1, "an": 2, "ang": 3, "ao": 4, "b": 5,
    "c": 6, "ch": 7, "d": 8, "e": 9, "ei": 10, "en": 11,
    "eng": 12, "er": 13, "f": 14, "g": 15, "h": 16, "i": 17,
    "ie": 18, "in": 19, "ing": 20, "iu": 21, "j": 22, "k": 23,
    "l": 24, "m": 25, "n": 26, "o": 27, "ong": 28, "ou": 29,
    "p": 30, "q": 31, "r": 32, "s": 33, "sh": 34, "t": 35,
    "u": 36, "ui": 37, "un": 38, "v": 39, "ve": 40, "vn": 41,
    "w": 42, "x": 43, "y": 44, "z": 45, "zh": 46, "zhi": 47,
    # spacial case
    #TODO 韵母分离需要重新写
    "@": -1, "ian": 2, "ua": 0, "iang": 3, "iao": 4, "uo": 27,
}

@export var bgms: Array[AudioStream]
#TODO 优化音频片段
@export var gibberish_clips: Array[AudioStream]

@onready var bgm_player = %BgmPlayer
@onready var gibberish_player = %GibberishPlayer

var converter_path = ProjectSettings.globalize_path("res://tools/convert_text_to_pinyin.exe")
var pinyin_content: Array = []
var stop_flag = false


func _ready():
    change_bgm(0)


func change_bgm(index: int):
    if index >= bgms.size():
        return

    bgm_player.stream = bgms[index]
    bgm_player.play()


func play_gibberish(content: String):
    stop_flag = false
    var inds := convert_content_to_inds(content)
    for i in inds:
        if i == -1:
            await get_tree().create_timer(0.8).timeout
            if stop_flag:
                return
            continue

        gibberish_player.stream = gibberish_clips[i]
        gibberish_player.pitch_scale = randf_range(1.8, 2.4) # 调节音高。音高越高，语速越快。
        gibberish_player.play(0.05) # 去头
        await gibberish_player.finished

        if stop_flag:
            return


func stop_playing():
    stop_flag = true
    gibberish_player.stop()


func convert_content_to_inds(content: String) -> Array[int]:
    OS.execute(converter_path, [content], pinyin_content)
    var indices: Array[int] = []
    print(pinyin_content)
    for s in pinyin_content[0].split(" "):
        if !AUDIO_LOOK_UP.has(s):
            print("Key not included:", s)
            continue
        indices.append(AUDIO_LOOK_UP[s])
    pinyin_content = []
    return indices
