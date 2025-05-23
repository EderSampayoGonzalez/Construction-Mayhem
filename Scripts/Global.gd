extends Node
## Singleton que maneja variables importantes para el manejo del juego entre escenas [br]
## variables mas relevantes:[br]
## [param player_scores] almacena la puntuación de cada jugador [br]
## [param objects_list] Guarda una lista con todos los objetos guardados en res:/Scenes/map_objects para ser colocados en el editor [br]
## [param in_game_objects] Guarda los objetos en formato [archivo_objeto, posición] para ser colocados en el nivel [br]

## Manejo de patrón de diseño Singleton para el acceso a distintos tipos de variables globales

var player_scores: Array = [0,0] ## Almacena la puntuación de cada jugador
var current_scene = null
var objects_list: Array = [] ## Guarda una lista con todos los objetos guardados en res:/Scenes/map_objects para ser colocados en el editor
var in_game_objects: Array = [] ## Guarda los objetos en formato [archivo_objeto, posición] para ser colocados en el nivel
var Player_colors : Array[Color] = ["Dodger Blue", "Orange"] ## Arreglo que guarda un color que asignarle a cada jugador en el editor y en el nivel

var players_left = [] ## Guarda a cada jugador, se modiica si uno muere

func _ready() -> void:
	# https://docs.godotengine.org/en/stable/classes/class_diraccess.html
	
	# la dirección de la carpeta de objetos del editor
	var path = "res://Scenes/map_objects"
	# Abre un DirAccess para ir accediendo al directorio de cada objeto
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
					#Añade la escena inicializada a la lista de objetos
					objects_list.append(scene)
			file_name = dir.get_next()
		# Cierra el acceson a los archivos
		dir.list_dir_end()

## Añade al objeto designado con su posición actual a [param in_game_objects] para ser instanciado en el nivel
func add_object(obj:String, position: Vector2):
	in_game_objects.append([obj,Vector2(position)])
	print (in_game_objects)

## Aumenta en uno la puntuacion en [param player_scores] en la posición asignada por el id
func increase_score(id: int):
	player_scores[id-1] += 1
	#print("puntuaciones actuales: ",player_scores)
