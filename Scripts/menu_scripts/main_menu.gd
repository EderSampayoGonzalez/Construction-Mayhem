extends Control
## Script que maneja el control de los botones del menú principal
##
## Cambia el boton de salir cierra el programa, mientras que los botones de jugar y opcione
## Cambian a las escenas del nivel y del menu de opciones
## El audio del boton presionandose se convierte en sigleton para que siga reproduciendose al cambiar de escenas

func _on_play_pressed() -> void:
	ButtonSfx.play()
	get_tree().change_scene_to_file("res://Scenes/menu_scenes/tutorial.tscn")

func _on_options_pressed() -> void:
	ButtonSfx.play()
	get_tree().change_scene_to_file("res://Scenes/menu_scenes/options_menu.tscn")

func _on_quit_pressed() -> void:
	ButtonSfx.play()
	get_tree().quit()
