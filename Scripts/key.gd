extends Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
var player: CharacterBody2D

var key_taken = false
var in_chest_area = false
var player_pos = 0

signal chest_opened

func _process(delta: float) -> void:
	if (key_taken):
		if (in_chest_area):
			print ("Cofre abierto")
			emit_signal("chest_opened")
			queue_free()
		
		player_pos = player.get_global_position()
		player_pos += Vector2(14, 2)
		position = global_position.lerp(player_pos, 3*(delta))

	
#https://www.youtube.com/watch?v=tN76BJ2XyDQ
func _on_body_entered(body: CharacterBody2D) -> void:
	print (body.get_groups())
	if key_taken == false && body.is_in_group("Players"):
		key_taken = true
		player = get_node(body.get_path())
		print ("Llave agarrada")


func _on_chest_body_entered(body: Node2D) -> void:
	in_chest_area = true
	print ("Llave en zona del cofre")


func _on_chest_body_exited(body: Node2D) -> void:
	in_chest_area = false
	print ("Llave saliendo de zona del cofre")
