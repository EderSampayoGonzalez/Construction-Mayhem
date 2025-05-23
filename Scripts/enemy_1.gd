extends CharacterBody2D

## Objeto que actua como un enemigo, mata al jugador si se encuentra en contacto con el
## 
## No se puede matar, si está en una plataforma caminará sobre ella hasta alcanzar el borde o chocar con un objeto[br]
## Posee una colisión que al tocar al jugador lo mata [br]
## [url]https://youtu.be/LOhfqjmasi0?si=zQy1HCig4fgLRU4h[/url]

const SPEED = 50 ## La velocidad base del enemigo
var direction = 1 ## La direccíon inicial del enemigo

@onready var ray_cast_right: RayCast2D = $RayCastRight ## Raycast que comprueba colisiones por la derecha
@onready var ray_cast_left: RayCast2D = $RayCastLeft ## Raycast que comprueba colisiones por la izquierda
@onready var ray_cast_down: RayCast2D = $RayCastDown ## Raycast que comprueba si está pisando suelo

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D 
@export var freeze:bool = false ## Variable que conjela al enemigo, usada para que no se mueva en el editor

func _process(delta: float) -> void:
	# Evita cualquier proceso de movimiento si se encuentra congelado
	if (freeze):
		return
	
	# Cambia de direccíon al encontrar una colisión en su derecha o izquierda
	# o al ver que no estaría tocando suelo
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite_2d.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite_2d.flip_h = false
	if not ray_cast_down.is_colliding():
		direction *= -1
		animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h
	
	#Se mueve a una velocidad constante sobre el eje x
	velocity.x = direction * SPEED
	
	#añade velocidad al eje y para que se caiga si no está pisando suelo
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()
