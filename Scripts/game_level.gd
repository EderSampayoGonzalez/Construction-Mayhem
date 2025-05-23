extends Node
## Nodo que contiene nodos esenciales para el nivel principal
## Incluye el mapa, jugadores, la cámara, la llave y cofre, y objetos precargados

## instancia de una escena del editor. Preparada para ser cambiada 
## [url]https://www.reddit.com/r/godot/comments/gbrt9a/how_to_save_previous_scene_when_switching_scenes/[/url]
@onready var editor = load("res://Scenes/Level_Scenes/map_editor.tscn").instantiate()


func _ready() -> void:
	# Agrega a cada jugador a la lista de jugadores vivos
	Global.players_left = [$"Players/Player 1",$"Players/Player 2"]
	
	# Crea cada objeto creado desde el editor
	for items in Global.in_game_objects:
		var object = load(items[0]).instantiate()
		self.add_child(object)
		object.global_position = items[1]
		#print ("añadido objeto en nivel: ", object.name)

## Cambia al editor presionando la tecla debug + del teclado numerico
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_swap"):
		swap_level()


## Llama a la funcion de cambiar nivel de forma diferida.[br]
## Esto para que todo el código de la escene se termine de ejecutar
## para pasar a el editor evitando problemas
## 
## [url]https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html[/url]
func swap_level():
	Engine.time_scale = 1
	get_parent().add_child(editor, true)
	get_parent().remove_child(self)
	self.queue_free()

## Recibe la señal de cambiar nivel del cofre cuando se abre
func _on_chest_1_chest_swap() -> void:
	swap_level.call_deferred()
