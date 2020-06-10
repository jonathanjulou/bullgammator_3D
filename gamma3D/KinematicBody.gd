extends KinematicBody

onready var panneau = get_node("../CanvasLayer2/panneau")

var camera

var SPEED = 0.3

func _ready():

	# Called every time the node is added to the scene.

	# Initialization here

	# pass

	camera = get_node("../KinematicBody/CameraGimbal/InnerGimbal/Camera2")


#func _process(delta):

#	# Called every frame. Delta is time since last frame.

#	# Update game logic here.

#	pass


func _physics_process(delta):

	var dir = Vector3()
	var rot = camera.get_global_transform().basis
	

	if(Input.is_action_pressed("ui_up") or Input.is_action_pressed("move_fw")):

		dir += -rot[2]

	if(Input.is_action_pressed("ui_down") or Input.is_action_pressed("move_bw")):

		dir += rot[2]

	if(Input.is_action_pressed("ui_left") or Input.is_action_pressed("move_l")):

		dir += -rot[0]

	if(Input.is_action_pressed("ui_right") or Input.is_action_pressed("move_r")):

		dir += rot[0]

 

	dir.y = 0

	dir = dir.normalized()

 
	var new_pos = dir * SPEED
 
	var collision = move_and_collide(new_pos)
