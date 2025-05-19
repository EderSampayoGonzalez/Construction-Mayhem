extends Node2D

@onready var timer: Timer = $Timer
@onready var text_edit: TextEdit = $TextEdit

@onready var game_level = load("res://Scenes/game_level.tscn").instantiate()

var pressed = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text_edit.text = str(timer.time_left)
	if (Input.is_action_pressed("lol") && !pressed):
		pressed = false
		print ("BBBBBBBBBBBBBBBBBBBBBBBBBBB")
		swap_scene()
	

func swap_scene():
	get_parent().add_child(game_level)
	get_parent().remove_child(self)
