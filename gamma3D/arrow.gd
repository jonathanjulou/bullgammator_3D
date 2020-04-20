extends VSplitContainer
signal button_clicked(node)

var retour = false

func _ready():
	var collision = get_node("KinematicBody2D")
	collision.connect("clicked", self, "handle_click")

func handle_click(collision):
	var arrow = get_node("NinePatchRect")
	arrow.hide()
	if retour:
		retour = false #evite le double clic
	else:
		emit_signal("button_clicked", self)
		retour = true
	yield(get_tree().create_timer(0.3), "timeout")
	arrow.show()
