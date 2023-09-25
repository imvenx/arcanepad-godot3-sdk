extends Node

# This is enum to prevent user edit on inspector :/
#@export_enum("0.0.1") var LIBRARY_VERSION: String = "0.0.1" 

#@export_enum("view", "pad")
var deviceType: String = "view"

var msg
var devices = [AModels.ArcaneDevice]
var pads = []
var internalViewsIds = []
var internalPadsIds = []
var iframeViewsIds = []
var iframePadsIds = []
var pad

func _ready():
	var url = "wss://localhost:3005/"
	
	if Engine.has_singleton("DebugMode") or ["Windows", "X11", "OSX"].has(OS.get_name()):
		url = "ws://localhost:3009/"

	msg = AWebsocketService.new(url, deviceType)
	self.add_child(msg)

	msg.on("Initialize", funcref(self, 'initialize'))
	msg.on("RefreshGlobalState", funcref(self, '_refreshGlobalState'))

func initialize(initializeEvent, _from):
	refreshGlobalState(initializeEvent.globalState)
	for p in pads:
		if p.deviceId == msg.deviceId:
			pad = p
			break

	var initialState = AModels.InitialState.new(pads)
	msg.trigger('ArcaneClientInitialized', funcref(self, 'initialState'))
#	eventEmitter.emit('ArcaneClientInitialized', initialState)
#	emit_signal("arcaneClientInitialized", initialState)

	msg.off('Initialize', funcref(self, 'initialize'))

func _refreshGlobalState(e):
	refreshGlobalState(e.refreshedGlobalState)

func refreshGlobalState(refreshedGlobalState):
	devices = refreshedGlobalState.devices
	refreshClientsIds(devices)
	pads = getPads(devices)
#	pads[0].startGetQuaternion()
#	pads[0].onGetQuaternion(asd)

#func asd(e):
#	print(e)

func refreshClientsIds(_devices: Array) -> void:
	var _internalPadsIds: Array = []
	var _internalViewsIds: Array = []
	var _iframePadsIds: Array = []
	var _iframeViewsIds: Array = []

	for device in _devices:
		if device.deviceType == AModels.ArcaneDeviceType.pad:
			for client in device.clients:
				if client.clientType == AModels.ArcaneClientType.internal:
					_internalPadsIds.append(client.id)
				else:
					_iframePadsIds.append(client.id)

		elif device.deviceType == AModels.ArcaneDeviceType.view:
			for client in device.clients:
				if client.clientType == AModels.ArcaneClientType.internal:
					_internalViewsIds.append(client.id)
				else:
					_iframeViewsIds.append(client.id)

	internalPadsIds = _internalPadsIds
	internalViewsIds = _internalViewsIds
	iframePadsIds = _iframePadsIds
	iframeViewsIds = _iframeViewsIds

func getPads(_devices: Array) -> Array:
	var _pads:Array = [ArcanePad]

	var padDevices = []
	for device in _devices:
		if device.deviceType == AModels.ArcaneDeviceType.pad:
			var iframeClients = []
			for client in device.clients:
				if client.clientType == AModels.ArcaneClientType.iframe:
					iframeClients.append(client)
			if iframeClients.size() > 0:
				padDevices.append(device)

	for padDevice in padDevices:
		var iframeClientId: String
		var internalClientId: String

		for client in padDevice.clients:
			if client.clientType == AModels.ArcaneClientType.iframe:
				iframeClientId = client.id
			elif client.clientType == AModels.ArcaneClientType.internal:
				internalClientId = client.id

		if iframeClientId == null or iframeClientId == "":
			printerr("Tried to set pad but iframeClientId was not found")

		if internalClientId == null or internalClientId == "":
			printerr("Tried to set pad but internalClientId was not found")

		if iframeClientId != null and internalClientId != null:
			var _pad = ArcanePad.new(padDevice.id, internalClientId, iframeClientId, true, padDevice.user)
			_pads.append(_pad)

	return _pads
