extends Area2D
## Escena que se asocia al cofre y funcione como su activador
##
## Al ser tocado por un jugador, se asocia a éste y lo sigue por el nivel
## Se tiene que espera run intervalo de tiempo para que puede volver a ser tocado por otro jugador

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer
@onready var key_taken_sound: AudioStreamPlayer2D = $key_taken_sound

var player: Player = null ## El jugador al que se asocia la llave

@export var init_pos: Array[Vector2] = [] ## Psobles posiciones que puede tomar la llave iniciando la partida
@onready var initial_pos

var key_taken = false ## Revisa si la llave ya fue tomada
var in_chest_area = false ## Revisa si el jugador se encuentra tocando el cofre
var player_pos = 0 ## Posición del jugador

signal chest_opened (player_id: int) ## Señal que se manda si la llave alcanzó al cofre

## Se mueve aleatoreamente entre las posiciones designadas por init_pos
func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	if init_pos.size() != 0:
		self.global_position = init_pos[rng.randi_range(0,init_pos.size()-1)]
	initial_pos = global_position

func _process(delta: float) -> void:
	
	if self.player != null:
		#toma la posición del jugador hacia la derecha de éste
		player_pos = player.get_global_position()
		player_pos += Vector2(14, 2)
		
		#Interpola la posición de la llave y la posicion del jugador para moverse de forma suave a el jugador
		position = self.global_position.lerp(player_pos, 5*(delta))
		
		#emite la señal chest_opened y se elimina del nivel
		if (in_chest_area):
			print ("Cofre abierto por jugador: ", player.player_id)
			emit_signal("chest_opened", player.player_id)
			queue_free()
		
		# se desconecta del jugador si se murió y se mueve un poco del camino
		if player.get_node("AnimatedSprite2D").animation == StringName("Dead_%s" % [player.player_id]):
			print("jugador muerto")
			player = null
			position = global_position.lerp(Vector2(0,0), 2*delta)
	else:
		# Si está demasiado abajo del nivel sin tener un jugador asociado, regresa a su posición original
		position = global_position.lerp(initial_pos, 2*delta)

## Si un jugador toca la llave, la llava se asocia al jugador
## @tutorial https://www.youtube.com/watch?v=tN76BJ2XyDQ
func _on_body_entered(body: CharacterBody2D) -> void:
	#print (body.get_groups())
	if body != self.player and !key_taken:
		modulate = body.modulate
		key_taken_sound.play()
		timer.start()
		key_taken = true
		player = get_node(body.get_path())
		print ("Llave agarrada por jugador ", body.player_id)

## si el jugador entra en el cofre, activa in_chest_area para abrir el cofre
func _on_chest_body_entered(body: Node2D) -> void:
	if (body == player):
		in_chest_area = true
		#print ("jugador en zona del cofre")

## si el jugador sale del cofre, desactiva in_chest_area
func _on_chest_body_exited(body: Node2D) -> void:
	if (body == player):
		in_chest_area = false
		#print ("jugador saliendo de zona del cofre")

## funcion para devolver la posibilidad de tocar la llave
func _on_timer_timeout() -> void:
	key_taken = false
	print ("llave puede ser tomada de nuevo") # Replace with function body.
