extends Camera2D

## Script que controla la cámara del nivel de plataformas
## 
## Se posicionará en medio d elos dos jugadores e irá haciendo zoom 
## si uno de los jugadores se aleja demasiado del otro
##
## https://www.youtube.com/watch?v=W7WsL3qaPqg

@export var move_speed = 30 # camera position lerp speed
@export var zoom_speed = 2.0 # camera zoom lerp speed
@export var min_zoom = 2  # camera won't zoom closer than this
@export var max_zoom = 0.4  # camera won't zoom farther than this
@export var margin = Vector2(50, 10)  # include some buffer area around targets

var targets = []

@onready var screen_size = get_viewport_rect().size

func _ready() -> void:
	add_target($"../Player 1")
	add_target($"../Player 2")

func _process(delta):
	if !targets:
		return

	# Keep the camera centered among all targets
	var p = Vector2.ZERO
	for target in targets:
		p += target.position
	p /= targets.size()
	position = lerp(position, p, move_speed * delta)

	# Find the zoom that will contain all targets
	var r = Rect2(position, Vector2.ONE)
	for target in targets:
		r = r.expand(target.position)
	r = r.grow_individual(margin.x, margin.y, margin.x, margin.y)
	var z
	if r.size.x > r.size.y * screen_size.aspect():
		z = 1 / clamp(r.size.x / screen_size.x, max_zoom, min_zoom)
	else:
		z = 1 / clamp(r.size.y / screen_size.y, max_zoom, min_zoom)
	zoom = lerp(zoom, Vector2.ONE * z, zoom_speed * delta)

	# For debug
	#get_parent().draw_cam_rect(r)

func add_target(t):
	if not t in targets:
		targets.append(t)

func remove_target(t):
	if t in targets:
		targets.remove(t)
