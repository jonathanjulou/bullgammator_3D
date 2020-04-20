extends KinematicBody2D
signal clicked(node)

func _input_event(obj, event, i):
	if event is InputEventMouseButton:
		emit_signal("clicked", self)
