class_name ArcanePad extends Node

var user
var deviceId: String
var internalId: String
var internalIdList: Array
var iframeId: String
var iframeIdList: Array
var isConnected: bool

signal GetQuaternion(quaternion)
signal GetRotationEuler(rotationEuler)
signal GetPointer(point)
signal OpenArcaneMenu()
signal CloseArcaneMenu()


func addSignal(signalName:String):
	for s in get_signal_list():
		if(s.name == signalName): return
		
	add_user_signal(signalName)
	Arcane.signals.addSignal(signalName)
	Arcane.signals.connect(signalName, self, '_proxyEvent')


func _proxyEvent(e, from:String):
	if from != iframeId: return
	emit_signal(e.name, e)
	
	
func _init(_deviceId: String, _internalId: String, _iframeId: String, _isConnected: bool, _user = null):
	user = _user
	deviceId = _deviceId
	internalId = _internalId
	internalIdList = [_internalId]
	iframeId = _iframeId
	iframeIdList = [_iframeId]
	isConnected = _isConnected
	
	setupEvents()
	
	
func setupEvents():
	
#	Arcane.signals.connect("IframePadConnect", self, "_proxyEventConnect")
#	Arcane.signals.connect("IframePadDisconnect", self, "_proxyEventDisconnect")
#
	Arcane.signals.connect("GetQuaternion", self, "onGetQuaternion")
	Arcane.signals.connect("GetRotationEuler", self, "onGetRotationEuler")
	Arcane.signals.connect("GetPointer", self, "onGetPointer")
#
	Arcane.signals.connect("OpenArcaneMenu", self, "onOpenArcaneMenu")
	Arcane.signals.connect("CloseArcaneMenu", self, "onCloseArcaneMenu")

#func dispose():
#	pass
#	eventEmitter.dispose()
#	Arcane.msg.offAll("GetQuaternion")
#	Arcane.msg.off("IframePadConnect", self, "_proxyEventConnect")
#	Arcane.msg.off("IframePadDisconnect", self, "_proxyEventDisconnect")
	
#	Arcane.msg.off("GetQuaternion", self, "_proxyEvent")
	
#	Arcane.msg.off("GetRotationEuler", self, "_proxyEvent")
#
#	Arcane.msg.off("GetPointer", self, "_proxyEvent")
#
#	Arcane.msg.off("OpenArcaneMenu", self, "_proxyEvent")
#	Arcane.msg.off("CloseArcaneMenu", self, "_proxyEvent")
	
#func _proxyEventConnect(e, _from):
#	_proxyEvent(e, e.iframeId)
#
#func _proxyEventDisconnect(e, _from):
#	_proxyEvent(e, e.iframeId)
#
#func _proxyEvent(event, from):
#	var fullEventName = event.name + '_' + from
#	emit_signal(fullEventName, event)
##	eventEmitter.emit(fullEventName, event)
##	_triggerEvent(fullEventName, event)
#
##func _triggerEvent(eventNameWithId: String, event:Dictionary):
##	if events.has(eventNameWithId):
##		for callback in events[eventNameWithId]:
##			if callback is Callable:
##				callback.callv([event])	
##				callback.callv([])	

#func onConnect(callback: FuncRef):
#	eventEmitter.on("IframePadConnect" + '_' + iframeId, callback)
#
#func onDisconnect(callback: FuncRef):
#	eventEmitter.on("IframePadDisconnect" + '_' + iframeId, callback)
#

func startGetQuaternion():
	Arcane.msg.emit(AEvents.StartGetQuaternionEvent.new(), internalIdList)
	
func stopGetQuaternion():
	Arcane.msg.emit(AEvents.StopGetQuaternionEvent.new(), internalIdList)

func onGetQuaternion(e, from):
	if(from != internalId): return
	emit_signal("GetQuaternion", e)

func calibrateQuaternion():
	Arcane.msg.emit(AEvents.CalibrateQuaternionEvent.new(), internalIdList)


func startGetRotationEuler():
	Arcane.msg.emit(AEvents.StartGetRotationEulerEvent.new(), internalIdList)
#
func stopGetRotationEuler():
	Arcane.msg.emit(AEvents.StopGetRotationEulerEvent.new(), internalIdList)

func onGetRotationEuler(e, from):
	if(from != internalId): return
	emit_signal("GetRotationEuler", e)


func startGetPointer():
	Arcane.msg.emit(AEvents.StartGetPointerEvent.new(), internalIdList)

func stopGetPointer():
	Arcane.msg.emit(AEvents.StopGetPointerEvent.new(), internalIdList)

func onGetPointer(e, from):
	if(from != internalId): return
	emit_signal("GetPointer", e)

func calibratePointer():
	Arcane.msg.emit(AEvents.CalibratePointerEvent.new(), internalIdList)


func vibrate(milliseconds: int):
	Arcane.msg.emit(AEvents.VibrateEvent.new(milliseconds), internalIdList)


func onOpenArcaneMenu(e, from):
	if(from != internalId): return
	emit_signal("OpenArcaneMenu", e)

func onCloseArcaneMenu(e, from):
	if(from != internalId): return
	emit_signal("CloseArcaneMenu", e)


#func send(event: AEvents.ArcaneBaseEvent):
#	Arcane.msg.emit(event, iframeIdList)
#
#func on(eventName: String, callback: FuncRef):
#	var fullEventName = eventName + '_' + iframeId
#	eventEmitter.on(fullEventName, callback)
#	Arcane.signals.connect(eventName, self, "proxyOnCustomEvent")
#
#func proxyOnCustomEvent(event, clientId):
#	if(clientId == iframeId):
#		_proxyEvent(event, iframeId)
		
#func proxyCallback(e, from):
#	if(from == iframeId):
#		send()

#func off(padId:String, eventName:String, callback:Callable):
#	events.clear()
	
#func dispose():
#	events.clear()
