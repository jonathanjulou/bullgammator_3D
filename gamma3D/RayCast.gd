extends RayCast

onready var camera = get_node("..")

var ray_length = 15

var delta = 1

var look_panel = false
var look_racks = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

func is_panel_looked():
	return look_panel
	
func is_racks_looked():
	return look_racks


func _physics_process(delta):
	var from = camera.get_global_transform().origin
	#var to   = from - ray_length*camera.get_global_transform().basis[2]

	self.cast_to     = from - ray_length*camera.get_global_transform().basis[2]

	var panel = get_tree().get_root().get_node("decors").find_node("panel")
	var panel2 = panel.get_node("StaticBody")
	
	var racks = get_tree().get_root().get_node("decors").find_node("open_racks")
	var racks2 = racks.get_node("StaticBody")

	var collision_point = get_collider() 

	if collision_point == panel2:
		panel.show_highlight()
		look_panel = true
	elif collision_point == racks2:
		racks.show_highlight()
		look_racks = true
	else:
		panel.hide_highlight()
		racks.hide_highlight()
		look_panel = false
		look_racks = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
