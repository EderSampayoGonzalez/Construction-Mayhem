extends Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer
var player: CharacterBody2D = null


var key_taken = false
var in_chest_area = false
var player_pos = 0 

signal chest_opened (player_id: int)

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if self.player != null:
		player_pos = player.get_global_position()
		player_pos += Vector2(14, 2)
		position = global_position.lerp(player_pos, 5*(delta))
		
		if (in_chest_area):
			print ("Cofre abierto por jugador: ", player.player_id)
			emit_signal("chest_opened", player.player_id)
			queue_free()

	
#https://www.youtube.com/watch?v=tN76BJ2XyDQ
func _on_body_entered(body: CharacterBody2D) -> void:
	#print (body.get_groups())
	if key_taken == false && body.is_in_group("Players"):
		if body != self.player:
			timer.start()
			key_taken = true
			player = get_node(body.get_path())
			print ("Llave agarrada por jugador ", body.player_id)


func _on_chest_body_entered(body: Node2D) -> void:
	if (body == player):
		in_chest_area = true
	print ("Llave en zona del cofre")


func _on_chest_body_exited(body: Node2D) -> void:
	if (body == player):
		in_chest_area = false
	print ("Llave saliendo de zona del cofre")


func _on_timer_timeout() -> void:
	key_taken = false
	print ("llave sin tomar") # Replace with function body.
