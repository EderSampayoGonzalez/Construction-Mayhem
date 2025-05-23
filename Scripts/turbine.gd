extends StaticBody2D

## Objeto que agrega una corriente de viento

@onready var wind: Area2D = $wind
@onready var turbine_collision: CollisionShape2D = $turbine_collision
@onready var timer: Timer = $Timer
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var wind_force: float = 20

func _on_timer_timeout() -> void:
	if sprite_2d.frame == 0:
		sprite_2d.frame = 1
	else:
		sprite_2d.frame = 0
