extends StaticBody2D

## Objeto de Resorte que impulsa rápidamente a un jugador
##
## Usa un objeto de viento oculto para simular el impulso
## Entra en cooldown despues de usarse por un segundo
## Solo afecta a los jugadores

@onready var wind: Area2D = $wind
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _on_wind_body_entered(body: Node2D) -> void:
	# Desactiva el impulso de viento para evitar dar impulsos masivos
	wind.set_deferred("monitoring", false)
	audio_stream_player_2d.play()
	animated_sprite_2d.animation = "Spring"
	timer.start()

func _on_timer_timeout() -> void:
	animated_sprite_2d.animation = "Idle"
	# activa el impulso de viento para que vuelva a poder impulsar
	wind.set_deferred("monitoring", true)
