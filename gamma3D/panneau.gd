extends Node2D

onready var simu = get_node("../..")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var pas  = 160
var eq_classes = [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]]
var current_color = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _draw():
	var center = Vector2(pas, pas)
	var radius = 36
	var color = Color(1.0, 0.0, 0.0)
	var code = [0,0,0,0]
	eq_classes = [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]]
	for i in range(16):
		eq_classes[i].append(Vector2(8.64*pas, i*pas)) 
	
	for ligne in range(16):
		
		code = simu.get_ligne(ligne+16*simu.get_current_page())
		
		for i in range(8):
			center = Vector2(i*pas, ligne*pas)
			color  = color_map(code[i/2])
			draw_circle(center, radius, color)
			if i/2 != i/2.0 and code[i/2] != 0:
				connecte(center, code[i/2])
			else:
				eq_classes[code[i/2]].append(center) 
			
		center = Vector2(8.64*pas, ligne*pas)
		color  = color_map(ligne)
		draw_circle(center, radius, color)

func color_map(i):
	if i == 0:
		return Color(1,1,1)
	var R = (1*i%16)/16.0
	var G = (1+2*i%16)/16.0
	var B = (12-4*i%16)/16.0
	return Color(R,G,B)

func connecte(point, classe):
	var lastpoint = point
	for t in range(20):
		#draw_line ( point, eq_classes[classe][-2], color_map(classe), 6.0, true )
		point = bezier_bump(point, eq_classes[classe][-2], t/20.0)
		draw_line(lastpoint, point, color_map(classe), 6.0, true )
		lastpoint = point
	draw_line(lastpoint, eq_classes[classe][-2], color_map(classe), 6.0, true )
	
func bezier_bump(p0,p1,t):
	var p2 = Vector2((p0[0]+p1[0])/2, (p0[1]+p1[1])/2 + 80)
	var q0 = p0.linear_interpolate(p2, t)
	var q1 = p2.linear_interpolate(p1, t)
	return q0.linear_interpolate(q1, t)
	
func _input(event):
   # Mouse in viewport coordinates
	var clicked_line = 0
	var clicked_element = 0
	
	if event is InputEventMouseButton:
		if event.position[0] > 1300 and event.position[0] < 1900:
			clicked_line = int((event.position[1]-70)/60)
			clicked_element = int((event.position[0]-1350)/55)

		#print(clicked_element)
		#print(clicked_line)
		
		if clicked_element == 9:
			current_color = clicked_line
		else:
			simu.modify_element(clicked_line, clicked_element/2, current_color)
			
		update()
