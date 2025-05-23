extends StaticBody2D

@onready var wind: Area2D = $wind
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_wind_body_entered(body: Node2D) -> void:
	animated_sprite_2d.animation = "Spring"
	wind.set_deferred("monitoring", false)
	timer.start()

func _on_timer_timeout() -> void:
	animated_sprite_2d.animation = "Idle"
	wind.set_deferred("monitoring", true)
