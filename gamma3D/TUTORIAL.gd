extends RichTextLabel

#var tutorial = """
#@ Scene 1 $
#{
#Bonjour, arpenteur du temps.$
#On dirait que vous vous êtes perdu dans les méandres des ages.$
#Bienvenue dans mon domaine, la clair'hier, perdue au milieu de la futaie du passé oublié.$
#Vous vouliez vous rendre en 1957 ? Quand un ordinateur Bull Gamma 3 a été installé à Grenoble ?$
#Vous avez de la chance, je viens justement d'en acquérir un spécimen.$
#Vous voulez l'essayer ?$
#}
#"""
var tutorial = """
@ Scene 1 $
{
Bonjour, vous pouvez faire avancer le texte en appuyant sur 'entrée'. Si vous n'arrivez pas, essayez le bouton gauche de la souris$
Appuyez sur 'C', cela vous permettra de contrôler la caméra.$
Si vous appuyez sur 'F', vous récupèrerez votre pointeur de souris.$
Vous pouvez vous déplacer avec soit les flèches directionelles, soit les touches ZQSD.$
Avancez vers la machine.$
Si vous vous approchez du panneau et le regardez, il devrait briller en rose.$
Cela signifie que vous pouvez intéragir avec.$
Cliquez sur le bouton droit de la souris, vous arriverez dans l'interface de programmation.$
Vous pouvez quitter ce mode en cliquant sur 'C'.$
les flèches permettent de changer de panneau, pour écrire des programmes plus longs.$
(à terme ça ira jusqu'à la ligne 63, comme en vrai)$
La fenêtre de dialogue qui vient d'apparaitre au dessus est la console de sortie de bullgammator.$
La fenêtre de dialogue juste au dessus est un éditeur de programme en hexadécimal.$
Le bouton 'CHARGER SUR LE PANNEAU' permet de charger un programme entré dans l'éditeur sur le panneau.$
Par défaut, au démarrage c'est la suite de fibonacci, mais chaque modification du panneau modifiera l'éditeur.$
Si vous cliquez sur le bouton 'TITILLER', le programme avancera d'une instruction.$
Ce n'est pas vraiment visible sans débug à moins de cliquer beaucoup.$
Le bouton 'CONTINUER' permet de continuer à éxécuter le programme jusqu'à la fin.$
Le bouton 'REBOOT' permet de redémarrer la machine, réinitialisant tout.$
Pour jouer avec le panneau, il faut d'abord selectionner une constante, puis on peut cliquer sur un trou pour la lui affecter.$
}"""




var tutorial_blocks = tutorial.split("@")
var current_block   = []
var block_counter   = 1
var line_counter    = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func is_finished():
	return block_counter == len(tutorial_blocks) && len(current_block) == 0

func get_next_line():
	if len(current_block) == 0:
		current_block    = tutorial_blocks[block_counter].split("$")
		block_counter   += 1
		line_counter     = 0
		return get_next_line()
		
	
	var retour = current_block[line_counter]
	line_counter += 1
	if "}" in retour:
		current_block = []

	return retour.replace("/n", "")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
