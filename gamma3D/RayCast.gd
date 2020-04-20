extends RayCast

onready var camera = get_node("..")

var ray_length = 15

var delta = 1

var look_panel = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

func is_panel_looked():
	return look_panel


func _physics_process(delta):
	var from = camera.get_global_transform().origin
	#var to   = from - ray_length*camera.get_global_transform().basis[2]

	self.cast_to     = from - ray_length*camera.get_global_transform().basis[2]

	var panel = get_tree().get_root().get_node("decors").find_node("panel")
	var panel2 = panel.get_node("StaticBody")

	var collision_point = get_collider() 
	
	#var cp = get_collision_point()
	
	#var debug = get_tree().get_root().get_node("decors").find_node("debug")
	
	#debug.translation.x = to[0]
	#debug.translation.y = to[1]
	#debug.translation.z = to[2]

	if collision_point == panel2:
		panel.show_highlight()
		look_panel = true
	else:
		panel.hide_highlight()
		look_panel = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
