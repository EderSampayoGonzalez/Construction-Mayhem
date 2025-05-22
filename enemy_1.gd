extends CharacterBody2D

const SPEED = 50

var direction = 1

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_down: RayCast2D = $RayCastDown
@export var freeze:bool = false

var on_floor = false

func _ready() -> void:
	if ray_cast_down.is_colliding():
		on_floor = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (freeze):
		return
	
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite_2d.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite_2d.flip_h = false
	if not ray_cast_down.is_colliding():
		direction *= -1
		animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h
	
	velocity.x = direction * SPEED
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	#position.x += direction * SPEED * delta
	move_and_slide()
