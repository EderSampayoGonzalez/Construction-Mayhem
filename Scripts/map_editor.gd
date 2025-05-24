extends Node2D

## El nodo que maneja el editor de nivel.
## Crea nuevos objetos para cada jugador y se encarga de moverlos y colocarlos.
##
## Se agrega cada objeto colocado a Global.in_game_objects
## Cada vez que se regresa al editor, carga los objetos colocados pero congelados y en gris para mostrar donde fueron colocados

## instancia de una escena del nivel. Preparada para ser cambiada 
## [url]https://www.reddit.com/r/godot/comments/gbrt9a/how_to_save_previous_scene_when_switching_scenes/[/url]
@onready var level = load("res://Scenes/Level_scenes/game_level.tscn").instantiate()
@onready var editor_level = self
@onready var swap_timer: Timer = $Swap_Timer #Temporizador que al terminar cambia el nivel
@onready var tap_sound: AudioStreamPlayer = $tap_sound
@onready var object_set_sound: AudioStreamPlayer2D = $object_set_sound

## Referencia a la lista de objetos global
var objects_list = Global.objects_list

#Variables para coloca un objeto debug
var debug_item_PS
var item_debug : Object
var object_debug_has_been_placed = true

var item_PS 
var item : Object
var object_has_been_placed : bool
## variable que almacena informacion relevante para manejar los objetos que se colocarán en el editor[br]
## almacena [param item_PS], [param item] y [param object_has_been_placed] para cada objeto
var object_players: Dictionary = {}

var tile_size = 16 ## El tamaño en pixeles de un objeto basico
var objects_placed = 0 ## Numero de objetos colocados

# Variables que limitan el lugar de colocación de los objetos
var limit_x : int = 456
var limit_min_x : int = -56
var limit_y : int = 160
var limit_min_y : int = -160

var rng = RandomNumberGenerator.new()
var last_just_pressed : bool

func _ready() -> void:
	# Añade los objetos que se colocaron anteriormente a la escena
	for items in Global.in_game_objects:
		var object = load(items[0]).instantiate()
		self.add_child(object)
		# Congela a los objetos para que no se muevan en el editor
		if "freeze" in object:
			object.freeze = true
			
		# Oscurece los objetos instanciados de esta manera
		if "modulate" in object:
			object.modulate = Color(0.49, 0.49, 0.49)
		object.global_position = items[1]
		#print ("añadido objeto en editor: ", object.name)
	
	# Accede a la cantidad de jugadores a través del array de puntos y crea un diccionario del objeto preparado para cada jugador
	for i in Global.player_scores.size():
		object_players.get_or_add(i+1)
		
		# instancia un objeto aleatoreamente de la lista de objetos
		item_PS = objects_list[rng.randi_range(0,objects_list.size()-1)]
		item = item_PS.instantiate()
		self.add_child(item)
		
		#Fuerza los objetos a la cuadricula
		item.global_position.x = ((round(item.global_position.x / 8)) * 8)
		item.global_position.y = ((round(item.global_position.y / 8)) * 8)
		
		print ("creando nuevo item: ", item.name)
		
		#Congela los objetos para que nmo se muevan
		if "freeze" in item:
			item.freeze = true
		var temp : Dictionary = {item = item, item_PS = item_PS, object_has_been_placed = false}
		
		# Colorea cada objeto colocable dependiendo del color del jugador
		#print ("modulate" in item)
		if "modulate" in item:
			item.modulate = Global.Player_colors[i]
		
		# añade todas las variables al diccionario inicializadas
		object_players[i+1] = temp


func _process(delta: float) -> void:
	#Cambia al nivel pulsando + en el teclado numerico
	if Input.is_action_just_pressed("debug_swap"):
		swap_level()
	
	# Cambia de nivel cuando ya se colocaron todos los objetos
	if objects_placed == object_players.keys().size() and swap_timer.is_stopped():
		print ("Todos los objetos colocados. Cambiando nivel...")
		swap_timer.start()
	
	# Creacion de un objeto aleatorio presionando - en el teclado numerico
	if Input.is_action_just_pressed("debug_create_object"):
		debug_item_PS = objects_list[rng.randi_range(0,objects_list.size()-1)]
		item_debug = debug_item_PS.instantiate()
		item.global_position.x = ((round(item.global_position.x / 8)) * 8)
		item.global_position.y = ((round(item.global_position.y / 8)) * 8)
		self.add_child(item_debug)
		print ("creando nuevo item 1: ", item_debug.name)
		if "freeze" in item_debug:
			item_debug.freeze = true
		object_debug_has_been_placed = false
	
	for player_id in object_players.keys():
		if !object_players[player_id]["object_has_been_placed"]:
			handle_player(int(player_id))
			
	
	## movimiento del objeto debug
	if !object_debug_has_been_placed:
		if Input.is_action_just_pressed("place_1"):
			print ("item 1 colocado")
			Global.add_object(debug_item_PS.resource_path, item_debug.global_position)
			object_debug_has_been_placed = true
		handle_debug()



## Llama a la funcion de cambiar de escena de forma diferida[br]
## 
## esto para que todo el código de la escena se termine de ejecutar
## antes de pasar a el nivel, evitando problemas [br]
## 
## [url]https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html[/url]
func swap_level():
	swap.call_deferred()


## cambia el nodo actual en Game_scenes al game_level y se remueve a si mismo del arbol
func swap():
	get_parent().add_child(level, true)
	get_parent().remove_child(self)
	self.queue_free()


## Maneja toda la lógica para mover el objeto del jugador 1
func handle_debug():
	item_debug.global_position.x = ((round(item_debug.global_position.x / tile_size)) * tile_size)
	item_debug.global_position.y = ((round(item_debug.global_position.y / tile_size)) * tile_size)
	if(Input.is_action_just_pressed("move_left_1")):
		item_debug.global_position.x -= tile_size
	if(Input.is_action_just_pressed("move_right_1")):
		item_debug.global_position.x += tile_size

## Maneja toda la lógica para mover el objeto del jugadordado por el id
func handle_player(id: int):
	var play_tap_sound: bool = false
	
	item = object_players[id]["item"]
	
	if(Input.is_action_just_pressed("move_left_%s" % [id])):
		play_tap_sound = true
		item.global_position.x -= tile_size
	if(Input.is_action_just_pressed("move_right_%s" % [id])):
		play_tap_sound = true
		item.global_position.x += tile_size
	if(Input.is_action_just_pressed("move_down_%s" % [id])):
		play_tap_sound = true
		item.global_position.y += tile_size
	if(Input.is_action_just_pressed("move_up_%s" % [id])):
		play_tap_sound = true
		item.global_position.y -= tile_size
	
	
	if Input.is_action_just_pressed("place_%s" % [id]):
		print ("item %s colocado" % [id])
		Global.add_object(object_players[id]["item_PS"].resource_path, item.global_position)
		object_players[id]["object_has_been_placed"] = true
		objects_placed += 1
		object_set_sound.play()
		
	
	if play_tap_sound:
		tap_sound.play()
	
	if item.global_position.x < limit_min_x:
		item.global_position.x = limit_min_x
	
	if item.global_position.x > limit_x:
		item.global_position.x = limit_x
	
	if item.global_position.y < limit_min_y:
		item.global_position.y = limit_min_y
	
	if item.global_position.y > limit_y:
		item.global_position.y = limit_y

## Cambia al nivel despues de que se acabe el temporizador
func _on_swap_timer_timeout() -> void:
	swap_level() # Replace with function body.
