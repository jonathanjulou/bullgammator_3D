extends Spatial



# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
	
func show_highlight():
	get_node("Highlight").show()
	
func hide_highlight():
	get_node("Highlight").hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
