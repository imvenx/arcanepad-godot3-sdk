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

signal OpenArcaneMenu(e)
signal CloseArcaneMenu(e)

signal IframePadConnect(e)
signal IframePadDisconnect(e)


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
	
	Arcane.signals.connect("IframePadConnect", self, "onIframePadConnect")
	Arcane.signals.connect("IframePadDisconnect", self, "onIframePadDisconnect")
#
	Arcane.signals.connect("GetQuaternion", self, "onGetQuaternion")
	Arcane.signals.connect("GetRotationEuler", self, "onGetRotationEuler")
	Arcane.signals.connect("GetPointer", self, "onGetPointer")
#
	Arcane.signals.connect("OpenArcaneMenu", self, "onOpenArcaneMenu")
	Arcane.signals.connect("CloseArcaneMenu", self, "onCloseArcaneMenu")


func onIframePadConnect(e, _from):
	if(e.iframeId != iframeId): return
	emit_signal("IframePadConnect", e)
	
func onIframePadDisconnect(e, _from):
	if(e.iframeId != iframeId): return
	emit_signal("IframePadDisconnect", e)
	

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

func calibratePointer(isTopLeft:bool):
	Arcane.msg.emit(AEvents.CalibratePointerEvent.new(isTopLeft), internalIdList)


func setScreenOrientationPortrait():
	Arcane.msg.emit(AEvents.SetScreenOrientationPortraitEvent.new(), internalIdList)

func setScreenOrientationLandscape():
	Arcane.msg.emit(AEvents.SetScreenOrientationLandscapeEvent.new(), internalIdList)


func vibrate(milliseconds: int):
	Arcane.msg.emit(AEvents.VibrateEvent.new(milliseconds), internalIdList)


func onOpenArcaneMenu(e, from):
	if(from != internalId): return
	emit_signal("OpenArcaneMenu", e)

func onCloseArcaneMenu(e, from):
	if(from != internalId): return
	emit_signal("CloseArcaneMenu", e)


func emit(event: AEvents.ArcaneBaseEvent):
	Arcane.msg.emit(event, iframeIdList)
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
