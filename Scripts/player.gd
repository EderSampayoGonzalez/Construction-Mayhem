extends CharacterBody2D

const SPEED = 110.0
const JUMP_VELOCITY = -300.0
var can_jump = true

var added_forces = Vector2(0,0)

#https://youtu.be/ai331P2U1pE?si=JMlwshy2V6oSa96C
@export var player_id: int

## La fuerza con la que el jugador empuja los objetoscon fisicas
@export var push_force = 12.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_timer: Timer = $CoyoteTimer

func _ready() -> void:
	#Cambia el color del personaje segun su id de jugador https://www.youtube.com/watch?v=EKGhfneG2sw
	animated_sprite.self_modulate = Global.Player_colors[player_id-1]
	add_to_group("Players")

func _on_coyote_timer_timeout() -> void:
	can_jump = false

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if can_jump == false and is_on_floor():
		can_jump = true
	
	# Handle jump.
	if Input.is_action_just_pressed("jump_%s" % [player_id]) and can_jump:
		velocity.y = JUMP_VELOCITY
		can_jump = false
		
	if (is_on_floor() == false) and can_jump and coyote_timer.is_stopped():
		coyote_timer.start()
		
	
	# Obtiene la dirección del input: 0 si no hay ningun input
	# 1: derecha, -1: izquierda
	var direction := Input.get_axis("move_left_%s" % [player_id], "move_right_%s" % [player_id])
	#Aplica el movimiento
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	#Cambia la dirección del sprite dependiendo del movimiento
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	#activa las animaciones
	if not has_node("CollisionShape2D"):
		animated_sprite.play("Dead_%s" % [player_id])
		get_parent().get_node("PlayerCamera").remove_target(self)
	elif is_on_floor():
		if direction == 0:
			animated_sprite.play("Idle_%s" % [player_id])
		else:
			animated_sprite.play("Run_%s" % [player_id])
	else:
		animated_sprite.play("Falling_%s" % [player_id])
	
	velocity += added_forces
	
	move_and_slide()
	
	# This represents the player's inertia.

	#https://kidscancode.org/godot_recipes/4.x/physics/character_vs_rigid/index.html
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
