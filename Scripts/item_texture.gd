extends TextureRect

@export var this_scene: PackedScene
var object_cursor
var cursor_sprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	object_cursor = get_node("/root/Main/Game_scenes/Map_editor")
	cursor_sprite = object_cursor.get_node("Sprite2D")
	connect("gui_input", self.item_clicked)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func item_clicked(event):
	if event is InputEvent:
		if event.is_action_pressed("right_click"):
			object_cursor.current_item = self.this_scene
			cursor_sprite.texture = texture
			print(cursor_sprite.get_position())
	pass
