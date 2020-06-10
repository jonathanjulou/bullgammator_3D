extends Spatial

onready var highlight = get_node("MeshInstance")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	highlight.hide()


func show_highlight():
	highlight.show()
	
func hide_highlight():
	highlight.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
