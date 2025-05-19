extends Node2D
@onready var key: Area2D = $Key
@onready var chest: Area2D = $Chest

var key_taken = false
var in_chest_area = false
var player_pos = 0
var player: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	key.set_script(null)
	chest.set_script(null)
	key.body_entered.connect(_on_key_body_entered)
	chest.body_entered.connect(_on_chest_body_entered)
	chest.body_exited.connect(_on_chest_body_exited)
	
	pass # Replace with function body.

func _process(delta: float) -> void:
	if (key_taken):
		if (in_chest_area):
			print ("Cofre abierto")
			chest_opened()
			key.queue_free()
		
		player_pos = player.get_global_position()
		if key != null:
			#print (player_pos)
			# print (key.global_position)
			player_pos += Vector2(14, 2)
			key.global_position = key.global_position.lerp(player_pos, 3*(delta))

func _on_key_body_entered(body: CharacterBody2D) -> void:
	if key_taken == false:
			key_taken = true
			player = body
			#print(player.get_path())
			print ("Llave agarrada")
			
func _on_chest_body_entered(body: Node2D) -> void:
	in_chest_area = true
	print ("Llave en zona del cofre")


func _on_chest_body_exited(body: Node2D) -> void:
	in_chest_area = false
	print ("Llave saliendo de zona del cofre")

func chest_opened() -> void:
	chest.get_node("Sprite2D").frame = 1
	chest.get_node("CollisionShape2D").queue_free()
	get_tree().change_scene_to_file("res://Scenes/prueba_escena.tscn")
