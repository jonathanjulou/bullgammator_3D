extends Spatial

onready var anim = get_node("AnimationPlayer")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var racks_deployed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play_backwards()
	pass

func play_anim():
	if not racks_deployed:
		anim.play("default")
		racks_deployed = true
	else:
		anim.play_backwards()
		racks_deployed = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
