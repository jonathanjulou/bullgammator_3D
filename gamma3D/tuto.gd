extends VSplitContainer

onready var texture = get_node("AnimatedSprite")
onready var reussite = get_node("AnimatedSprite2")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_tuto = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	texture.set_frame(0)

func get_current_tuto():
	return current_tuto

func next_tuto():
	current_tuto += 1
	texture.set_frame(current_tuto)
	texture.hide()
	show()
	
	reussite.show()
	reussite.set_frame(0)
	reussite.play()
	yield(get_tree().create_timer(1.6), "timeout")
	reussite.stop()
	reussite.hide()
	
	texture.show()
	
func goto_tuto(i):
	current_tuto = i
	texture.set_frame(i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
