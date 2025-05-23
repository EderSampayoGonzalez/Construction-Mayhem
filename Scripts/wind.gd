extends Area2D

## Corriente de viento que empja a los jugadores y objetos con fisicas

func _physics_process(delta: float) -> void:
	for body in get_overlapping_bodies():
		# Si es jugador, añade fuerzas hacia arriba
		if body is CharacterBody2D:
			body.velocity.y += Vector2(0,-25)
		# Si es objeto con fisicas, aplica un impulso desde su función
		if body is RigidBody2D:
			body.apply_central_impulse(Vector2(0,-10))
