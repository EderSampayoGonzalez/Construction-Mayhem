extends Camera2D

## Script que controla la cámara del nivel de plataformas
## 
## Se posicionará en medio de los dos jugadores e irá haciendo zoom 
## si uno de los jugadores se aleja demasiado del otro
##
## https://www.youtube.com/watch?v=W7WsL3qaPqg

@export var move_speed = 30 # velocidad de movimiento
@export var zoom_speed = 2.0 # velocidad del zoom
@export var min_zoom = 2  # maximo de zoom de la camara
@export var max_zoom = 0.5  # minimo de zoom de la camara
@export var margin = Vector2(80, 10)  # margenes de buffer para los jugadores

var targets = [] ## Arreglo que mantiene cada jugador añadido en el para realizar los calculos

@onready var screen_size = get_viewport_rect().size

## Añade a los jugadores de la escena a los targets
func _ready() -> void:
	add_target($"../Player 1") 
	add_target($"../Player 2")

func _process(delta):
	# Evita cualquier proceso si ya no hay jugadores
	if !targets:
		return

	# mantiene la cama centrada entre los jugadores
	var p = Vector2.ZERO
	for target in targets:
		p += target.position
	p /= targets.size()
	position = lerp(position, p, move_speed * delta)

	# encuentra el zoom adecuado que mantenga a los dos jugadores en vista
	var r = Rect2(position, Vector2.ONE)
	for target in targets:
		r = r.expand(target.position)
	r = r.grow_individual(margin.x, margin.y, margin.x, margin.y)
	var z
	if r.size.x > r.size.y * screen_size.aspect():
		z = 1 / clampf(r.size.x / screen_size.x, max_zoom, min_zoom)
	else:
		z = 1 / clampf(r.size.y / screen_size.y, max_zoom, min_zoom)
	zoom = lerp(zoom, Vector2.ONE * z, zoom_speed * delta)

## Añade a un jugador como objetivo de la camara
func add_target(t):
	if not t in targets:
		targets.append(t)

## Elimina a un jugador como objetivo de la camara
func remove_target(t):
	if t in targets:
		targets.erase(t)
