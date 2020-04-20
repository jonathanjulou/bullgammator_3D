extends Spatial

onready var blanc = get_node("CanvasLayer2/blanc")
onready var HUD = get_node("CanvasLayer2/tutorial")
onready var panneau = get_node("CanvasLayer2/panneau")
onready var console = get_node("CanvasLayer2/console")
onready var editeur = get_node("CanvasLayer2/editeur")
onready var arrow_up = get_node("CanvasLayer2/fleche_haut")
onready var arrow_down = get_node("CanvasLayer2/fleche_bas")
onready var button_cont = get_node("CanvasLayer2/bouton_continuer")
onready var button_titi = get_node("CanvasLayer2/bouton_titiller")
onready var button_rebo = get_node("CanvasLayer2/bouton_reboot")
onready var button_load = get_node("CanvasLayer2/bouton_charger")
onready var text = get_node("CanvasLayer2/tutorial/NinePatchRect/RichTextLabel")
onready var consoletext = get_node("CanvasLayer2/console/NinePatchRect/RichTextLabel2")
onready var camera = get_node("KinematicBody/CameraGimbal/InnerGimbal/Camera2")
onready var raycast = get_node("KinematicBody/CameraGimbal/InnerGimbal/Camera2/RayCast")

var in_dialogue = false
var reading = false
var delta = 1
var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().set_auto_accept_quit(false)
	#tutoriel.open("TUTORIAL.txt",1)
	#tutoriel.get_line()
	blanc.visible = false
	panneau.visible = false
	console.visible = false
	editeur.visible = false
	arrow_up.visible = false
	arrow_down.visible = false
	button_cont.visible = false
	button_titi.visible = false
	button_rebo.visible = false
	button_load.visible = false
	HUD.visible = false
	text.get_next_line()
	yield(get_tree().create_timer(1.0), "timeout")
	
	# decommenter pour avoir le tuto
	next_dialogue()


func _unhandled_input(event):
	if in_dialogue and not reading:
		if event is InputEventKey:
			if event.pressed and event.scancode == KEY_ENTER and in_dialogue:
				next_dialogue()
				return
		if Input.is_action_pressed("click") and panneau.visible == false:
			next_dialogue()
	
	if Input.is_action_pressed("rightclick"):
		if raycast.is_panel_looked():
			blanc.visible = true
			panneau.visible = true
			editeur.visible = true
			arrow_up.visible = true
			arrow_down.visible = true
			button_cont.visible = true
			button_titi.visible = true
			button_rebo.visible = true
			button_load.visible = true
			console.visible = true
			#HUD.visible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
	if Input.is_action_pressed("echap"):
		blanc.visible = false
		panneau.visible = false
		editeur.visible = false
		console.visible = false
		arrow_up.visible = false
		arrow_down.visible = false
		button_cont.visible = false
		button_titi.visible = false
		button_rebo.visible = false
		button_load.visible = false
		if in_dialogue:
			HUD.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func next_dialogue():
	reading = true
	var txt = ""
	if not (text.is_finished()):
		txt += text.get_next_line()
	else:
		in_dialogue = false
		HUD.visible = false
		return

	if "{" in txt:
		in_dialogue = true
		HUD.visible = true
		txt = txt.replace("{","")
	if "}" in txt:
		in_dialogue = false
		HUD.visible = false
		txt = txt.replace("}","")

	txt = txt.replace("\n", "")
	text.clear()
	text.add_text(txt)
	text.visible_characters = 0
	while text.visible_characters < len(txt):
		yield(get_tree().create_timer(0.03), "timeout")
		text.visible_characters += 1
	yield(get_tree().create_timer(0.5), "timeout")
	reading = false
