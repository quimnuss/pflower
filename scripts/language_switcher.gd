extends Node2D

var languages_names: Array[String] = ["English", "Català"]
var languages: Array[String] = ["en", "ca"]

var language_id: int = 0
@onready var label = $Label


func _ready():
    label.text = languages_names[language_id]


func change_language():
    language_id = (language_id + 1) % len(languages)
    label.text = languages_names[language_id]
    TranslationServer.set_locale(languages[language_id])
    Globals.language_code = languages_names[language_id]


func _on_area_2d_body_entered(_body):
    change_language()
