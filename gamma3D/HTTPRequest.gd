extends HTTPRequest

var MACHINE_NUMBER = 0

var ip = "86.193.182.117" #127.0.0.1
var result = ""
var response_code = ""
var headers = ""
var body = ""

var lock = false
var go_on = false

func _ready():
	get_tree().set_auto_accept_quit(false)
	connect("request_completed", self, "_on_request_completed")
	#print(request("http://www.mocky.io/v2/5185415ba171ea3a00704eed"))
	#print(request("http://127.0.0.1:8001/console"))
	var return_code = API_cree_machine()
	while return_code is GDScriptFunctionState:
		yield(get_tree().create_timer(0.5), "timeout")
		return_code = return_code.resume() 
		
#	return_code = API_charge_programme()
#	while return_code is GDScriptFunctionState:
#		yield(get_tree().create_timer(0.5), "timeout")
#		return_code = return_code.resume() 

func _on_request_completed(res, code, head, corpse):
	result = 		res
	response_code = code
	headers = 		head
	body = 			JSON.parse(corpse.get_string_from_utf8()).result["message"]
	go_on = true
	
# supprime la machine sur le serveur distant quand on quitte
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		print(str(MACHINE_NUMBER))
		request("http://"+ip+":8001/supprime_machine?id=" + str(MACHINE_NUMBER))
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().quit() # default behavior

func API_cree_machine():
	while lock:
		yield()
	
	lock = true
	go_on = false
	request("http://"+ip+":8001/cree_machine")
	while not go_on:
		yield()

	var retour = body
	print(retour)
	lock = false
	MACHINE_NUMBER = retour
	return 0

func API_console():
	while lock:
		yield()
	
	lock = true
	go_on = false
	request("http://"+ip+":8001/console?id=" + str(MACHINE_NUMBER))
	while not go_on:
		yield()

	var retour = body
	print(retour)
	lock = false
	return str(retour)

func API_continuer():
	while lock:
		yield()
	
	lock = true
	go_on = false
	request("http://"+ip+":8001/continue?id=" + str(MACHINE_NUMBER))
	while not go_on:
		yield()

	var retour = body
	print(retour)
	lock = false
	return 0
	
func API_titiller():
	while lock:
		yield()
	
	lock = true
	go_on = false
	request("http://"+ip+":8001/titille?id=" + str(MACHINE_NUMBER))
	while not go_on:
		yield()

	var retour = body
	print(retour)
	lock = false
	return 0
	
func API_reboot():
	while lock:
		yield()
	
	lock = true
	go_on = false
	request("http://"+ip+":8001/reboot?id=" + str(MACHINE_NUMBER))
	while not go_on:
		yield()

	var retour = body
	print(retour)
	lock = false
	return 0

func API_charge_programme():
	while lock:
		yield()
	
	lock = true
	go_on = false
	request("http://"+ip+":8001/charge_programme?id=" + str(MACHINE_NUMBER))
	while not go_on:
		yield()

	var retour = body
	print(retour)
	lock = false
	return 0
	
func API_edit_connexion_array(program_data):
	while lock:
		yield()
	
	lock = true
	go_on = false
	request("http://"+ip+":8001/edit_connexion_array?id=" + str(MACHINE_NUMBER) + "&program=" + str(program_data).replace(" ", ""))
	while not go_on:
		yield()

	var retour = body
	print(retour)
	lock = false
	return 0
