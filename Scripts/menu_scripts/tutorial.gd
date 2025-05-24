extends Control

## Pantalla de Tutorial que muestralos controles de cada jugador

@onready var player_1: AnimatedSprite2D = $HBoxContainer/Sprite_Container/player_1
@onready var player_2: AnimatedSprite2D = $HBoxContainer/Sprite_Container/player_2
@onready var play: Button = $VBoxContainer/Play



func _ready() -> void:
	player_1.modulate = Global.Player_colors[0]
	player_2.modulate = Global.Player_colors[1]


func _on_play_pressed() -> void:
	ButtonSfx.play()
	get_tree().change_scene_to_file("res://Scenes/game_scenes.tscn")
