## Clase que indica los jugadores del nivel
class_name Player
extends CharacterBody2D

## Nodo del jugador, maneja los movimientos e interacciones de los jugadores en el nivel
## https://youtu.be/ai331P2U1pE?si=JMlwshy2V6oSa96C
## https://kidscancode.org/godot_recipes/4.x/physics/character_vs_rigid/index.html
## https://www.youtube.com/watch?v=ai331P2U1pE&list=PLNHIWCe5oopeD9F5G2Al6vfthkQTTWtzf&index=3

const SPEED = 110.0 ## Velocidad base del jugador
const JUMP_VELOCITY = -305.0 ## Velocidad base del salto
var can_jump = true ## verdadero si puede saltar, se modifica en el coyote_time


# Variable export, hace que se pueda modificar desde el editor, no afecta a otros jugadores[br]
## Identificador del jugador actual, se debe modificar desde el editor[br]
## [url]https://youtu.be/ai331P2U1pE?si=JMlwshy2V6oSa96C[/url]
@export var player_id: int 

## La fuerza con la que el jugador empuja los objetos con fisicas
@export var push_force = 12.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_timer: Timer = $CoyoteTimer

func _ready() -> void:
	#Cambia el color del personaje segun su id de jugador https://www.youtube.com/watch?v=EKGhfneG2sw
	animated_sprite.self_modulate = Global.Player_colors[player_id-1]
	add_to_group("Players")

## elimina la posibilidad de saltar cuando se termina el tiempo del coyote_time
func _on_coyote_timer_timeout() -> void:
	can_jump = false

func _physics_process(delta: float) -> void:
	
	# añade la gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	#devuelve la habilidad de saltar al tocar el suelo
	if !can_jump and is_on_floor():
		can_jump = true
	
	# Maneja el salto
	if Input.is_action_just_pressed("jump_%s" % [player_id]) and can_jump:
		velocity.y = JUMP_VELOCITY
		can_jump = false
	
	# Funcón de manejo del coyote_time
	if !is_on_floor() and can_jump and coyote_timer.is_stopped():
		coyote_timer.start()
		
	
	# Obtiene la dirección del input: 0 si no hay ningun input
	# 1: derecha, -1: izquierda
	var direction := Input.get_axis("move_left_%s" % [player_id], "move_right_%s" % [player_id])
	#Aplica el movimiento basado en la dirección
	if direction:
		velocity.x = direction * SPEED
	else:
		#Decelera si no hay direccion
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	#Cambia la dirección del sprite dependiendo del movimiento
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	#activa las animaciones
	#Usa el formateo de strings para acceder a la animación de diferentes personajes dependiendo del id
	#https://www.youtube.com/watch?v=ai331P2U1pE&list=PLNHIWCe5oopeD9F5G2Al6vfthkQTTWtzf&index=3
	if not has_node("CollisionShape2D"):
		animated_sprite.play("Dead_%s" % [player_id])
		get_parent().get_node("PlayerCamera").remove_target(self)
	
	elif is_on_floor(): #Animacioones de movimiento
		if direction == 0:
			animated_sprite.play("Idle_%s" % [player_id])
		else:
			animated_sprite.play("Run_%s" % [player_id])
	
	else: #Animaciones de caer
		animated_sprite.play("Falling_%s" % [player_id])
	
	move_and_slide()
	
	#https://kidscancode.org/godot_recipes/4.x/physics/character_vs_rigid/index.html
	# Manejo de las colisiones, empuja los RigidBodies con los que colisiona
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
