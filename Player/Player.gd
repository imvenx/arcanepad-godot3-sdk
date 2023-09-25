extends Node


var pad:ArcanePad
var padQuaternion = Quat()

func initialize(_pad:ArcanePad) -> void:
	print("Pad user!!", _pad.user.name)
	pad = _pad
	
#	Arcane.signals.connect('Left', self, 'onLeft')
	
#	pad.on("Left", funcref(self, 'onLeft'))
	pad.startGetQuaternion()
	pad.connect('GetQuaternion', self, 'onGetQuaternion')
	
#	pad.onGetQuaternion(funcref(self, 'onGetQuaternion'))
	
func _process(delta):
	self.transform.basis = Basis(padQuaternion)
	
func onLeft(a,b):
	print("Left!")

func onGetQuaternion(e):
	padQuaternion.x = -e.x
	padQuaternion.y = -e.y
	padQuaternion.z = e.z
	padQuaternion.w = e.w

func _exit_tree():
#	pad.dispose()
	pad.queue_free()
