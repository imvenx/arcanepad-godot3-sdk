extends Camera

signal asd(qqqwe, erwer)

var callbacks = {}

func qqq():
	print("qeqwe")
	
func _ready():
	
	self.connect("asd", self, 'qqq')
	
	emit_signal("asd")
	
#	callbacks['onGetRotationVector'] = { '1151': [ funcref(self, 'asd') ], '1152': 'qwe' }
	on('asd', self, 'qwe')
	on('asd', self, 'qqq')
	off('asd', self, 'qwe')
	print(callbacks)

func on(eventName:String, object:Object, functionName:String):
	var objectId = String(object.get_instance_id())
	
	if not callbacks.has(eventName): callbacks[eventName] = {}
	if not callbacks[eventName].has(objectId): callbacks[eventName][objectId] = []

	callbacks[eventName][objectId].append(funcref(object, functionName))
	
func off(eventName:String, object:Object, functionName:String):
	var objectId = String(object.get_instance_id())
	
	if not callbacks.has(eventName): return
	if not callbacks[eventName].has(objectId): return
	
	callbacks[eventName].erase(objectId)
	
func offEvent(eventName:String, object:Object):
	var objectId = String(object.get_instance_id())
	
	if not callbacks.has(eventName): return
	callbacks.erase(eventName)
