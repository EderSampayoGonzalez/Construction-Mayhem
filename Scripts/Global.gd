extends Node

var player_scores: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func add_player(id: int):
	player_scores.append(0)
	#print("añadido jugador: ", id)

func increase_score(id: int):
	player_scores[id-1] += 1
	print(player_scores)
