extends StaticBody2D

## Objeto que agrega una corriente de viento

@onready var wind: Area2D = $wind
@onready var turbine_collision: CollisionShape2D = $turbine_collision
@onready var timer: Timer = $Timer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var noise_area: Area2D = $noise_area
@onready var turbine_noise: AudioStreamPlayer2D = $turbine_noise

@export var wind_force: float = 20

func _on_timer_timeout() -> void:
	if sprite_2d.frame == 0:
		sprite_2d.frame = 1
	else:
		sprite_2d.frame = 0

func _on_noise_area_body_entered(body: Node2D) -> void:
	if !turbine_noise.is_playing():
		turbine_noise.play()
