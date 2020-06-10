extends Spatial

onready var blanc = get_node("CanvasLayer2/blanc")
onready var aide = get_node("CanvasLayer2/VSplitContainer6")
onready var HUD = get_node("CanvasLayer2/tutorial")
onready var tuto = get_node("CanvasLayer2/tuto")
onready var panneau = get_node("CanvasLayer2/panneau")
onready var console = get_node("CanvasLayer2/console")
onready var editeur = get_node("CanvasLayer2/editeur")
onready var arrow_up = get_node("CanvasLayer2/fleche_haut")
onready var arrow_down = get_node("CanvasLayer2/fleche_bas")
onready var button_cont = get_node("CanvasLayer2/bouton_continuer")
onready var button_titi = get_node("CanvasLayer2/bouton_titiller")
onready var button_rebo = get_node("CanvasLayer2/bouton_reboot")
onready var button_rtrn = get_node("CanvasLayer2/bouton_retour")
onready var aidehint = get_node("CanvasLayer2/aide")
onready var fond = get_node("CanvasLayer2/fond")
onready var text = get_node("CanvasLayer2/tutorial/NinePatchRect/RichTextLabel")
onready var consoletext = get_node("CanvasLayer2/console/NinePatchRect/RichTextLabel2")
onready var camera = get_node("KinematicBody/CameraGimbal/InnerGimbal/Camera2")
onready var raycast = get_node("KinematicBody/CameraGimbal/InnerGimbal/Camera2/RayCast")
onready var bull = get_node("bull")

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
	fond.visible = false
	HUD.visible = false
	aidehint.visible = true
	tuto.visible = true
	text.get_next_line()
	yield(get_tree().create_timer(1.0), "timeout")
	
	# decommenter pour avoir le tuto
	#next_dialogue()
	in_dialogue = false
	
	var ret = get_node("CanvasLayer2/bouton_retour")
	ret.connect("button_clicked", self, "handle_retour")


func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ENTER:
			next_dialogue_2()
			return
	
	if Input.is_action_pressed("rightclick"):
		if raycast.is_panel_looked():
			if tuto.get_current_tuto() == 1:
				tuto.next_tuto()
			blanc.visible = true
			panneau.visible = true
			editeur.visible = true
			console.visible = true
			fond.visible = true
			aidehint.visible = false
			button_rtrn.visible = true
			#HUD.visible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
		if raycast.is_racks_looked():
			if tuto.get_current_tuto() == 0:
				tuto.next_tuto()
			bull.play_anim()
			
	if Input.is_action_pressed("echap"):
		blanc.visible = false
		panneau.visible = false
		editeur.visible = false
		console.visible = false
		fond.visible = false
		aidehint.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	if Input.is_action_pressed("help"):
		aide.visible = not aide.visible
		HUD.visible = not HUD.visible

func handle_retour(bouton):
		blanc.visible = false
		panneau.visible = false
		editeur.visible = false
		console.visible = false
		fond.visible = false
		aidehint.visible = true
		button_rtrn.visible = false
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
	
func next_dialogue_2():
	if tuto.visible:
		tuto.visible = false
		in_dialogue = false
	else:
		tuto.visible = true
		in_dialogue = true
