extends Node


var pad:ArcanePad
var padQuaternion = Quat()
onready var meshChild = get_child(0)

func initialize(_pad:ArcanePad) -> void:
	print("Pad user!!", _pad.user.name)
	pad = _pad
	
#	Arcane.signals.connect('Left', self, 'onLeft')
	
	pad.startGetQuaternion()
	pad.connect('GetQuaternion', self, 'onGetQuaternion')
	
	pad.addSignal('Left')
	pad.connect('Left', self, 'onLeft')
	
	pad.connect('OpenArcaneMenu', self, 'onOpenArcaneMenu')
	
func _process(_delta):
	meshChild.transform.basis = Basis(padQuaternion)
	
func onLeft(_e):
	print("Left!", pad.iframeId)

func onGetQuaternion(q):
	padQuaternion.x = -q.x
	padQuaternion.y = -q.y
	padQuaternion.z = q.z
	padQuaternion.w = q.w
	
func onOpenArcaneMenu(_e):
	print('Menu opened')

func _exit_tree():
#	pad.dispose()
	pad.queue_free()
