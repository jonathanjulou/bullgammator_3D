extends CanvasLayer

onready var consoletext = get_node("console/NinePatchRect/RichTextLabel2")
onready var editortext = get_node("editeur/NinePatchRect/TextEdit")
onready var panneau = get_node("panneau/AnimatedSprite")
onready var http = get_node("../HTTPRequest")
onready var dessin = get_node("panneau/Node2D")
onready var tuto = get_node("tuto")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var sortie
var nb_pages = 2 #4 a la fin
var current_page = 0
var program = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	var continuer = get_node("bouton_continuer")
	var titiller  = get_node("bouton_titiller")
	var reboot    = get_node("bouton_reboot")
	var charger   = get_node("fleche_droite")
	var decharger   = get_node("fleche_gauche")
	var prev_page = get_node("fleche_haut")
	var next_page = get_node("fleche_bas")
	
	continuer.connect("button_clicked", self, "handle_continuer")
	titiller.connect ("button_clicked", self, "handle_titiller")
	reboot.connect   ("button_clicked", self, "handle_reboot")
	charger.connect  ("button_clicked", self, "handle_charger")
	decharger.connect("button_clicked", self, "handle_decharger")
	prev_page.connect("button_clicked", self, "handle_prev_page")
	next_page.connect("button_clicked", self, "handle_next_page")
	
	#program = "1a00 0000 632b 0000 9051 8500 03d1 0000 6302 a402 c035 0000 7001 8502 90b5 0000 6320 0444 0354 7003 8102 8610 0369 0000 A092 0075 A085 0000 A100 7000 8700 0000 6600 3200 700A 0000 F700 6200 A009 0000 A700 C010 C0A5 0000 8700 6110 9520 0000 8520 0281 6500 0000 3200 1C07 8D00 0000 1800"
	#program = "1A00 1C07 3200 3300 3100 A001 8400 6300 A400 8500 6400 8300 6500 8400 8F00 6200 A001 8200 8E00 4000 900F 011D"
	program = """-- * * * Calcul de la suite de Fibonacci * * *
-- A chaque itération M2 vaut n et M4 fn

1A00 -- CD
1C07 -- CO 7

3200 -- ZB -- n = 0  -- M2
3300 -- ZB -- u0 = 0  -- M3
3100 -- ZB
A001 -- AN
8400 -- OB -- u1 = 1  -- M4

-- while:

6300 -- m1 = u0
A400 -- m1 = u0 + u1
8500 -- sum in M5

6400
8300 -- m4 -> m3

6500
8400 -- m5 -> m4
8F00 -- print

6200
A001
8200 -- n++
8E00 -- print

4000 -- 48V
900F -- compare n to 15
011D -- V, jump l7
"""
	editortext.text = program
	program = ""

func handle_continuer(bouton):
	var return_code = http.API_edit_connexion_array(program)
	while return_code is GDScriptFunctionState:
		yield(get_tree().create_timer(0.5), "timeout")
		return_code = return_code.resume() 
	
	return_code = http.API_continuer()
	while return_code is GDScriptFunctionState:
		yield(get_tree().create_timer(0.5), "timeout")
		return_code = return_code.resume() 
	
	var txt = http.API_console()
	while txt is GDScriptFunctionState:
		yield(get_tree().create_timer(0.5), "timeout")
		txt = txt.resume() 
	txt = str(txt).replace(",", "\n").replace("[", "").replace("]", "")
	consoletext.clear()
	consoletext.add_text(" "+txt)
	tuto_check(txt)
	dessin.update()
	
func handle_titiller(bouton):
	var return_code = http.API_edit_connexion_array(program)
	while return_code is GDScriptFunctionState:
		yield(get_tree().create_timer(0.5), "timeout")
		return_code = return_code.resume() 
		
	return_code = http.API_titiller()
	while return_code is GDScriptFunctionState:
		yield(get_tree().create_timer(0.5), "timeout")
		return_code = return_code.resume() 
	
	var txt = http.API_console()
	while txt is GDScriptFunctionState:
		yield(get_tree().create_timer(0.5), "timeout")
		txt = txt.resume() 
	txt = str(txt).replace(",", "\n").replace("[", "").replace("]", "")
	consoletext.clear()
	consoletext.add_text(" "+txt)
	dessin.update()
	
func handle_reboot(bouton):
	var return_code = http.API_reboot()
	while return_code is GDScriptFunctionState:
		yield(get_tree().create_timer(0.5), "timeout")
		return_code = return_code.resume() 
	
	var txt = http.API_console()
	while txt is GDScriptFunctionState:
		yield(get_tree().create_timer(0.5), "timeout")
		txt = txt.resume() 
	txt = str(txt).replace(",", "\n").replace("[", "").replace("]", "")
	consoletext.clear()
	consoletext.add_text(" "+txt)
	dessin.update()
	#program = "1A00 1C07 3200 3300 3100 A001 8400 6300 A400 8500 6400 8300 6500 8400 8F00 6200 A001 8200 8E00 4000 900F 011D"
	#editortext.text = program
	#program = ""
	
func handle_charger(bouton):
	if tuto.get_current_tuto() == 2:
		tuto.next_tuto()
		
	var refined_text = ""
	var comment = 0
	for c in editortext.text:
		if c == "-":
			comment += 1
		else:
			
			if c == "\n":
				comment = 0
			else:
				if comment < 2:
					refined_text += c
			
	refined_text = refined_text.replace("/n", "").replace(" ", "")
	program = refined_text
	dessin.update()
	
func handle_decharger(bouton):
	editortext.text = program
	
func handle_prev_page(bouton):
	if current_page > 0:
		current_page -= 1
		panneau.set_frame(current_page)
		dessin.update()

func handle_next_page(bouton):
	if current_page < nb_pages:
		current_page += 1
		panneau.set_frame(current_page)
		dessin.update()

func get_ligne(i):
	var res = [0,0,0,0]
	var to_parse = program.replace("/n", "").replace(" ", "")
	for k in range(i+1):
		if 4*k < len(to_parse):
			res[0] = hexa_to_int(to_parse[4*k])
			res[1] = hexa_to_int(to_parse[4*k+1])
			res[2] = hexa_to_int(to_parse[4*k+2])
			res[3] = hexa_to_int(to_parse[4*k+3])
		else:
			res = [0,0,0,0]
	return res
	
func modify_element(ligne, elem, val):
	var pre_nouveau_prgm = program.replace("/n", "").replace(" ", "")
	var nouveau_prgm = ""
	for k in range(32):
		if k != ligne + (16*current_page):
			if 4*k >= len(pre_nouveau_prgm):
				pre_nouveau_prgm += "0000"
			nouveau_prgm += pre_nouveau_prgm[4*k]
			nouveau_prgm += pre_nouveau_prgm[4*k+1]
			nouveau_prgm += pre_nouveau_prgm[4*k+2]
			nouveau_prgm += pre_nouveau_prgm[4*k+3]
		else:
			for j in range(4):
				if j != elem:
					if 5*k+j >= len(pre_nouveau_prgm):
						nouveau_prgm += "0"
						pre_nouveau_prgm += "0"
					else:
						nouveau_prgm += pre_nouveau_prgm[4*k+j]
						pre_nouveau_prgm += pre_nouveau_prgm[4*k+j]
				else:
					nouveau_prgm += int_to_hexa(val)
					pre_nouveau_prgm += "0"
		
	program = nouveau_prgm
	
func get_current_page():
	return current_page
	
	
func tuto_check(resultat):
	print(resultat)
	if tuto.get_current_tuto() == 3:
		tuto.next_tuto()
		
	if tuto.get_current_tuto() == 4 and resultat == """Sortie 0: 000000000000
 Sortie 1: 000000000000
 Sortie 2: 000000000000
 Sortie 3: 000000000000
	""":
		print("honk")
		tuto.next_tuto()

func hexa_to_int(c):
	match c:
		"0":
			return 0
		"1":
			return 1
		"2":
			return 2
		"3":
			return 3
		"4":
			return 4
		"5":
			return 5
		"6":
			return 6
		"7":
			return 7
		"8":
			return 8
		"9":
			return 9
		"A":
			return 10
		"B":
			return 11
		"C":
			return 12
		"D":
			return 13
		"E":
			return 14
		"F":
			return 15

func int_to_hexa(i):
	match i:
		0:
			return "0"
		1:
			return "1"
		2:
			return "2"
		3:
			return "3"
		4:
			return "4"
		5:
			return "5"
		6:
			return "6"
		7:
			return "7"
		8:
			return "8"
		9:
			return "9"
		10:
			return "A"
		11:
			return "B"
		12:
			return "C"
		13:
			return "D"
		14:
			return "E"
		15:
			return "F"
