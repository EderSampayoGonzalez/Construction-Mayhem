extends Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	pass



func _on_key_chest_opened(player_id: int) -> void:
	sprite_2d.frame = 1
	collision_shape_2d.queue_free()
	print(player_id)
	#get_tree().change_scene_to_file("res://Scenes/prueba_escena.tscn")
