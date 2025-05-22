extends Node2D

@onready var level = load("res://Scenes/Level_scenes/game_level.tscn").instantiate()
@onready var editor_level = self
var objects_list = Global.objects_list

var can_place = true

var debug_item_PS
var item_debug : Object
var object_debug_has_been_placed = true

var item_PS 
var item : Object
var object_has_been_placed : bool
var object_players: Dictionary = {}

var tile_size = 8

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	# Accede a la cantidad de jugadores a través del array de puntos y crea un diccionario del objeto preparado para cada jugador
	for i in Global.player_scores.size():
		object_players.get_or_add(i+1)
		item_PS = objects_list[rng.randi_range(0,objects_list.size()-1)]
		item = item_PS.instantiate()
		self.add_child(item)
		print ("creando nuevo item 1: ", item.name)
		if "freeze" in item:
			item.freeze = true
		var temp : Dictionary = {item = item, item_PS = item_PS, object_has_been_placed = false}
		object_players[i+1] = temp
	
	print (object_players)
	
	# Añade los objetos que se col0ocaron anteriormente a la escena
	for items in Global.in_game_objects:
		var object = load(items[0]).instantiate()
		self.add_child(object)
		if "freeze" in object:
			object.freeze = true
		object.global_position = items[1]
		print ("añadido objeto en editor: ", object)
		
	


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_swap"):
		swap_level()
		
	if Input.is_action_just_pressed("debug_create_object"):
		debug_item_PS = objects_list[rng.randi_range(0,objects_list.size()-1)]
		item_debug = debug_item_PS.instantiate()
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
		
		
	'''if (item_debug != null and can_place and Input.is_action_just_pressed("right_click")):
		var new_item = item_debug.instantiate()
		level.add_child(new_item)
		print(get_global_mouse_position())
		new_item.global_position = get_global_mouse_position()'''

## Llama a la funcion de cambiar de forma diferida, esto para que todo el código de la escena se termine de ejecutar
## antes de pasar a el nivel, evitando problemas
## 
## https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
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
	item = object_players[id]["item"]
	item.global_position.x = ((round(item.global_position.x / tile_size)) * tile_size)
	item.global_position.y = ((round(item.global_position.y / tile_size)) * tile_size)
	
	if(Input.is_action_just_pressed("move_left_%s" % [id])):
		item.global_position.x -= tile_size
	if(Input.is_action_just_pressed("move_right_%s" % [id])):
		item.global_position.x += tile_size
	if(Input.is_action_just_pressed("move_down_%s" % [id])):
		item.global_position.y += tile_size
	if(Input.is_action_just_pressed("move_up_%s" % [id])):
		item.global_position.y -= tile_size
	
	
	if Input.is_action_just_pressed("place_%s" % [id]):
		print ("item %s colocado" % [id])
		Global.add_object(object_players[id]["item_PS"].resource_path, item.global_position)
		object_players[id]["object_has_been_placed"] = true
