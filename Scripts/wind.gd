extends Area2D

## Corriente de viento que empja a los jugadores y objetos con fisicas

## Mide la fuerza sobre la que actuará la corriente de viento
@export  var push_force : int

func _physics_process(delta: float) -> void:
	if !self.monitoring:
		return
	
	for body in get_overlapping_bodies():
		# Si es jugador, añade fuerzas hacia arriba
		if body is CharacterBody2D:
			body.velocity.y += -push_force
		# Si es objeto con fisicas, aplica un impulso desde su función
		if body is RigidBody2D:
			body.apply_central_impulse(Vector2(0,-push_force/2))
