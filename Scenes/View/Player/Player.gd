extends Node


var pad:ArcanePad
var padQuaternion = Quat()
onready var meshChild = get_child(0)
onready var pointer = get_child(2)

func initialize(_pad:ArcanePad) -> void:
	
	pad = _pad
	prints("Pad user", pad.user.name, "initialized")
	
	
	# LISTEN WHEN THIS GAMEPAD CONNECTS
	pad.connect('IframePadConnect', self, 'onIframePadConnect')
	
	# LISTEN WHEN THIS GAMEPAD DISCONNECTS
	pad.connect('IframePadDisconnect', self, 'onIframePadDisconnect')
	
	
	# ASK FOR DEVICE ROTATION AND POINTER
	pad.startGetQuaternion()
	pad.startGetPointer()
	
	# LISTEN FOR DEVICE ROTATION AND POINTER
	pad.connect('GetQuaternion', self, 'onGetQuaternion')
	pad.connect('GetPointer', self, 'onGetPointer')
	
	
	# LISTEN CUSTOM EVENT FROM PAD
	pad.addSignal("Attack")
	pad.connect("Attack", self, 'Attack')
	
	
func _process(_delta):
	meshChild.transform.basis = Basis(padQuaternion)


func _exit_tree():
	pad.queue_free()
	
	
func onIframePadConnect(e):
	print(e)
	
func onIframePadDisconnect(e):
	print(e)
	
	
func onGetQuaternion(q):
	if(q.w == null || q.x == null || q.y == null || q.z == null): return
	
	padQuaternion.x = -q.x
	padQuaternion.y = -q.y
	padQuaternion.z = q.z
	padQuaternion.w = q.w
	
	
func onGetPointer(e):
	if(e.x == null || e.y == null): return
	
	var viewport_size = get_viewport().get_size()

	var new_x = viewport_size.x * (e.x / 100.0)
	var new_y = viewport_size.y * (e.y / 100.0)

	pointer.position = Vector2(new_x, new_y)


func Attack(e):
	Arcane.utils.writeToScreen(pad.user.name + " Attacked")
	print(pad.user.name + " Attacked!")
	print(e)
	
	# EMIT CUSTOM EVENT TO THE PAD
	pad.emit(Events.TakeDamageEvent.new(3))
