extends Node


var pad:ArcanePad
var padQuaternion = Quat()
onready var meshChild = get_child(0)
onready var pointer = get_child(2)

func initialize(_pad:ArcanePad) -> void:
	prints("Pad user", _pad.user.name, "initialized")
	pad = _pad
	
	pad.startGetQuaternion()
	pad.startGetPointer()
	
	# warning-ignore:RETURN_VALUE_DISCARDED
	pad.connect('GetQuaternion', self, 'onGetQuaternion')
	# warning-ignore:RETURN_VALUE_DISCARDED
	pad.connect('GetPointer', self, 'onGetPointer')
	
	pad.addSignal('Left')
	
	# warning-ignore:RETURN_VALUE_DISCARDED
	pad.connect('Left', self, 'onLeft')
	
	# warning-ignore:RETURN_VALUE_DISCARDED
	pad.connect('OpenArcaneMenu', self, 'onOpenArcaneMenu')
	# warning-ignore:RETURN_VALUE_DISCARDED
	pad.connect('CloseArcaneMenu', self, 'onCloseArcaneMenu')
	
	# warning-ignore:RETURN_VALUE_DISCARDED
	pad.connect('IframePadConnect', self, 'onIframePadConnect')
	# warning-ignore:RETURN_VALUE_DISCARDED
	pad.connect('IframePadDisconnect', self, 'onIframePadDisconnect')
	
	pad.addSignal("Attack")
	# warning-ignore:RETURN_VALUE_DISCARDED
	pad.connect("Attack", self, 'Attack')
	
	
func _process(_delta):
	meshChild.transform.basis = Basis(padQuaternion)


func _exit_tree():
#	pad.dispose()
	pad.queue_free()
	
	
func onLeft(_e):
	print("Left!", pad.iframeId)


func onGetQuaternion(q):
	padQuaternion.x = -q.x
	padQuaternion.y = -q.y
	padQuaternion.z = q.z
	padQuaternion.w = q.w
	
	
func onGetPointer(e):
	var viewport_size = get_viewport().get_size()

	var new_x = viewport_size.x * (e.x / 100.0)
	var new_y = viewport_size.y * (e.y / 100.0)

	pointer.position = Vector2(new_x, new_y)

	
func onOpenArcaneMenu(_e):
	print('Menu opened by ', pad.user.name)
	
func onCloseArcaneMenu(_e):
	print('Menu closed by ', pad.user.name)
	
	
func onIframePadConnect(e):
	print(e)
	pass
	
func onIframePadDisconnect(e):
	print(e)
	pass


func Attack(e):
	Arcane.utils.writeToScreen(pad.user.name + " Attacked")
	print(pad.user.name + " Attacked!")
	print(e)
	pad.emit(Events.TakeDamageEvent.new())
