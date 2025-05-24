extends Control

## Script que controla el manejo de la escena de opciones
##
## Se tienen dos ColorPickers, que cambian el color de los dos jugadores al darles click

@onready var player_color_1: ColorPickerButton = $VBoxContainer/PlayerColor1
@onready var player_color_2: ColorPickerButton = $VBoxContainer/PlayerColor2

func _ready() -> void:
	player_color_1.color = Global.Player_colors[0]
	player_color_2.color = Global.Player_colors[1]


func _on_player_color_1_color_changed(color: Color) -> void:
	Global.Player_colors[0] = color

func _on_player_color_2_color_changed(color: Color) -> void:
	Global.Player_colors[1] = color

func _on_return_button_pressed() -> void:
	ButtonSfx.play()
	get_tree().change_scene_to_file("res://Scenes/menu_scenes/Main_menu.tscn")
