extends Label

## Etiqueta que muestra las puntuaciones de cada jugador en pantalla

func _process(delta: float) -> void:
	self.text = "Jugador 1: %s\nJugador 2: %s" % [Global.player_scores[0], Global.player_scores[1]]
