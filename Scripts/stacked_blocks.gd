extends Node2D

## Objetio que almacena varios bloques apilados

## Congela a todos los bloques hijos para que no se muevan si el objeso se instancía en el editor
func _ready() -> void:
	if get_parent().name == "Map_editor":
		for block in get_children():
			block.freeze = true
	pass # Replace with function body.
