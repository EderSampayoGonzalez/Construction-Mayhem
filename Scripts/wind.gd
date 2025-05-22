extends Area2D


func _physics_process(delta: float) -> void:
	for body in get_overlapping_bodies():
		if body is CharacterBody2D:
			body.velocity.y -= 25
		if body is RigidBody2D:
			body.apply_central_impulse(Vector2(0,-10))
