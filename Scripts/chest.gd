extends Area2D
## Objeto de cofre que se empareja con el objeto de llave [br]
##
## Cuando un jugador con la llave se acerca al cofre, recibe una señal de la llave para abrirse e incrementar la puntuación del jugador[br]
## posee un [Timer] que se inicia al abrirse, y al terminar manda una señal para cambiar al editor

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var timer: Timer = $Timer
@onready var open_chest_sound: AudioStreamPlayer2D = $open_chest_sound

@export var init_pos: Array[Vector2] = [] ## Psobles posiciones que puede tomar el cofre iniciando la partida

signal chest_swap() ## Señal que se manda despues de abrir el cofre

func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	if init_pos.size() != 0:
		self.global_position = init_pos[rng.randi_range(0,init_pos.size()-1)]


func _on_timer_timeout() -> void:
	print ("Cambiando a la escena del editor...")
	emit_signal("chest_swap")

## Recibe el jugador con la llave que tocó el cofre, para aumentar su puntaje y cambiar al editor
func _on_key_1_chest_opened(player_id: int) -> void:
	open_chest_sound.play()
	
	sprite_2d.frame = 1
	sprite_2d.self_modulate = Global.Player_colors[player_id-1]
	collision_shape_2d.queue_free()
	
	print("cofre Abierto por jugador ", player_id)
	# Incrementa la puntuación del jugador que abrió el cofre
	Global.increase_score(player_id)
	timer.start()
