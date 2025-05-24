extends Area2D

## Zona que se añade a otros objetos.
## 
## Si un jugador entra en contacto con esta zona, lo mata

@onready var timer: Timer = $Timer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _on_body_entered(body: Node2D) -> void:
	print ("jugador muerto: ", body.name) 
	#print (Global.players_left)
	# Elimina la colisión del jugador haciendo que se caiga
	body.get_node("CollisionShape2D").queue_free()
	
	# Elimina al jugador de la lista de jugadores vivos
	Global.players_left.erase(body)
	
	# Hace al juego entero mas lento por un tiempo
	Engine.time_scale = 0.5
	audio_stream_player.play()
	timer.start()

## Regresa la velocidad normal al juego, si todo los jugadores murieron, se reiniciará el nivel
func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	if (Global.players_left.size() == 0):
		get_tree().reload_current_scene()
