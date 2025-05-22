extends Node

#https://www.reddit.com/r/godot/comments/gbrt9a/how_to_save_previous_scene_when_switching_scenes/
@onready var editor = load("res://Scenes/Level_Scenes/map_editor.tscn").instantiate()
# Called when the node enters the scene tree for the first time.


func _ready() -> void:
	Global.players_left = [$"Players/Player 1",$"Players/Player 2"]
	for items in Global.in_game_objects:
		var object = load(items[0]).instantiate()
		self.add_child(object)
		object.global_position = items[1]
		'''if object is stacked_blocks:
			for block in object.get_childen():
				block.freeze = false'''
		print ("añadido objeto en nivel: ", object)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_key_chest_opened(player_id: int) -> void:
	pass
	#print ("AAAAAAAAAAAAAAAAAAAAAAA")
	#swap_level() # Replace with function body.


## Llama a la funcion de forma diferida, esto para que todo el código de la escene se termine de ejecutar
## Para pasar a el editor evitando problemas
## 
## https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html

func swap_level():
	Engine.time_scale = 1
	get_parent().add_child(editor, true)
	get_parent().remove_child(self)
	self.queue_free()


func _on_chest_1_chest_swap() -> void:
	swap_level.call_deferred()
	pass # Replace with function body.

func _on_killzone_dead_player(player: CharacterBody2D) -> void:
	get_tree().reload_current_scene()
	pass # Replace with function body.
