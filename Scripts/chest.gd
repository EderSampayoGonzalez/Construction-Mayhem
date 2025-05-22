extends Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var timer: Timer = $Timer
signal chest_swap()

func _on_key_chest_opened(player_id: int) -> void:
	sprite_2d.frame = 1
	collision_shape_2d.queue_free()
	print("cofre Abierto por jugador ", player_id)
	Global.increase_score(player_id)
	timer.start()


func _on_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	print ("Cambiando a la escena del editor...")
	emit_signal("chest_swap")
	pass # Replace with function body.
