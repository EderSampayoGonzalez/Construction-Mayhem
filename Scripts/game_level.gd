extends Node

#https://www.reddit.com/r/godot/comments/gbrt9a/how_to_save_previous_scene_when_switching_scenes/
var TestScreen = load("res://Scenes/prueba_escena.tscn").instantiate()
# Called when the node enters the scene tree for the first time.


func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_key_chest_opened(player_id: int) -> void:
	print ("AAAAAAAAAAAAAAAAAAAAAAA")
	swap_level() # Replace with function body.
	
func swap_level():
	get_parent().add_child(TestScreen)
	get_parent().remove_child(self)
