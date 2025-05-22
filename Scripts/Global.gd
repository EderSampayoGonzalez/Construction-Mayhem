extends Node

var player_scores: Array = [0,0]
var current_scene = null
var objects_list: Array = [] ## Guarda una lista con todos los objetos guardados en res:/Scenes/map_objects para ser colocados en el editor
var in_game_objects: Array = [] ## Guarda los objetos en formato [archivo_objeto, posición] para ser colocados en el nivel
var Player_colors : Array[Color] = ["Dodger Blue", "Orange"]

var players_left = []

func _ready() -> void:
	#https://docs.godotengine.org/en/stable/classes/class_diraccess.html
	
	#la dirección de la carpeta de objetos del editor
	var path = "res://Scenes/map_objects"
	#Abre un DirAccess para ir accediendo al directorio de cada objeto
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			#Revisa todas las escenas del directorio map_objects
			if file_name.ends_with(".tscn"):
				#Inicializa cada escena en el global 
				var full_path = path + "/" + file_name
				var scene = load(full_path)
				#print(scene.resource_path)
				if scene:
					objects_list.append(scene)
			file_name = dir.get_next()
		dir.list_dir_end()
	print (objects_list)
	'''var root = get_tree().root
	# Using a negative index counts from the end, so this gets the last child node of `root`.
	current_scene = root.get_child(-1).get_child(0).get_child(0)
	print (current_scene)'''
	
	pass

func _process(delta: float) -> void:
	'''if Input.is_action_just_pressed("jump_2"):
		print (get_tree().root.get_children(true))'''
	
func add_player(id: int):
	player_scores.append(0)
	#print("añadido jugador: ", id)
	
func add_object(obj:String, position: Vector2):
	in_game_objects.append([obj,Vector2(position)])
	print (in_game_objects)
	
func increase_score(id: int):
	player_scores[id-1] += 1
	print("puntuaciones actuales: ",player_scores)
	
