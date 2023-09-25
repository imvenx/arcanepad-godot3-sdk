class_name ArcanePad extends Node

var user
var deviceId: String
var internalId: String
var internalIdList: Array
var iframeId: String
var iframeIdList: Array
var isConnected: bool

onready var Arcane = get_node('/root/Arcane')
var msg = Arcane.msg

var eventEmitter 

func _init(_deviceId: String, _internalId: String, _iframeId: String, _isConnected: bool, _user = null):
	user = _user
	deviceId = _deviceId
	internalId = _internalId
	internalIdList = [_internalId]
	iframeId = _iframeId
	iframeIdList = [_iframeId]
	isConnected = _isConnected
	
	eventEmitter = AEventEmitter.new()
	
	setupEvents()
	
func setupEvents():
	
#	msg.on("IframePadConnect", func(e): _proxyEvent(e, e.iframeId))
#	msg.on("IframePadDisconnect", func(e): _proxyEvent(e, e.iframeId))
#	proxyEventConnectRef = self.get_ref("_proxyEventConnect")
#	proxyEventDisconnectRef = self.get_ref("_proxyEventDisconnect")
	msg.on("IframePadConnect", funcref(self, "_proxyEventConnect"))
	msg.on("IframePadDisconnect", funcref(self, "_proxyEventDisconnect"))
	
	msg.on("GetQuaternion", funcref(self, "_proxyEvent"))
	
	msg.on("GetRotationEuler", funcref(self, "_proxyEvent"))
	
	msg.on("GetPointer", funcref(self, "_proxyEvent"))
	
	msg.on("OpenArcaneMenu", funcref(self, "_proxyEvent"))
	msg.on("CloseArcaneMenu", funcref(self, "_proxyEvent"))

func _proxyEventConnect(e):
	_proxyEvent(e, e.iframeId)

func _proxyEventDisconnect(e):
	_proxyEvent(e, e.iframeId)
	
func _proxyEvent(event, from):
	var fullEventName = event.name + '_' + from
	eventEmitter.emit(fullEventName, event)
#	_triggerEvent(fullEventName, event)

#func _triggerEvent(eventNameWithId: String, event:Dictionary):
#	if events.has(eventNameWithId):
#		for callback in events[eventNameWithId]:
#			if callback is Callable:
#				callback.callv([event])	
#				callback.callv([])	

func onConnect(callback: FuncRef):
	eventEmitter.on("IframePadConnect" + '_' + iframeId, callback)
	
func onDisconnect(callback: FuncRef):
	eventEmitter.on("IframePadDisconnect" + '_' + iframeId, callback)

func startGetQuaternion():
	msg.emit(AEvents.StartGetQuaternionEvent.new(), internalIdList)

func stopGetQuaternion(offAllListeners: bool = false):
	msg.emit(AEvents.StopGetQuaternionEvent.new(), internalIdList)
	if offAllListeners:
		eventEmitter.offAll("GetQuaternion" + '_' + internalId)

func onGetQuaternion(callback: FuncRef):
	eventEmitter.on("GetQuaternion" + '_' + internalId, callback)

func calibrateQuaternion():
	msg.emit(AEvents.CalibrateQuaternionEvent.new(), internalIdList)

func startGetRotationEuler():
	msg.emit(AEvents.StartGetRotationEulerEvent.new(), internalIdList)

func stopGetRotationEuler(offAllListeners: bool = false):
	msg.emit(AEvents.StopGetRotationEulerEvent.new(), internalIdList)
	if offAllListeners:
		eventEmitter.offAll("GetRotationEuler" + '_' + internalId)

func onGetRotationEuler(callback: FuncRef):
	eventEmitter.on("GetRotationEuler" + '_' + internalId, callback)

func startGetPointer():
	msg.emit(AEvents.StartGetPointerEvent.new(), internalIdList)

func stopGetPointer(offAllListeners: bool = false):
	msg.emit(AEvents.StopGetPointerEvent.new(), internalIdList)
	if offAllListeners:
		eventEmitter.offAll("GetPointer" + '_' + internalId)

func onGetPointer(callback: FuncRef):
	eventEmitter.on("GetPointer" + '_' + internalId, callback)

func calibratePointer():
	msg.emit(AEvents.CalibratePointerEvent.new(), internalIdList)

func vibrate(milliseconds: int):
	msg.emit(AEvents.VibrateEvent.new(milliseconds), internalIdList)

func onOpenArcaneMenu(callback: FuncRef):
	eventEmitter.on("OpenArcaneMenu" + '_' + iframeId, callback)

func onCloseArcaneMenu(callback: FuncRef):
	eventEmitter.on("CloseArcaneMenu" + '_' + iframeId, callback)


func send(event: AEvents.ArcaneBaseEvent):
	msg.emit(event, iframeIdList)

func on(eventName: String, callback: FuncRef):
	var fullEventName = eventName + '_' + iframeId
	eventEmitter.on(fullEventName, callback)
#	if not events.has(fullEventName):
#		events[fullEventName] = []
#	events[fullEventName].append(callback)

#	msg.on(eventName, func(event, clientId): 
#			if(clientId == iframeId):
#				_proxyEvent(event, iframeId)
#	)

	msg.on(eventName, funcref(self, "proxyOnCustomEvent"))

func proxyOnCustomEvent(event, clientId):
	if(clientId == iframeId):
		_proxyEvent(event, iframeId)
#func proxyCallback(e, from):
#	if(from == iframeId):
#		send()

#func off(padId:String, eventName:String, callback:Callable):
#	events.clear()
	
#func dispose():
#	events.clear()
