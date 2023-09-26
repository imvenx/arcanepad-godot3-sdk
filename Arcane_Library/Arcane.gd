extends Node

# This is enum to prevent user edit on inspector :/
#@export_enum("0.0.1") var LIBRARY_VERSION: String = "0.0.1" 

var LIBRARY_VERSION = '0.0.1'

#@export_enum("view", "pad")
var deviceType: String = "view"

var msg: AWebsocketService
var devices = []
var pads = []
var internalViewsIds = []
var internalPadsIds = []
var iframeViewsIds = []
var iframePadsIds = []
var pad:ArcanePad

var isIframe
var isWebEnv

var signals = ASignals.new()

func init(_deviceType:String = 'view'):
	
	isWebEnv = OS.get_name() == "HTML5"
	if isWebEnv: isIframe = JavaScript.eval('window.self !== window.top')
	
	var url = "wss://192.168.0.30:3005/"
	
	var protocol = 'wss'
	var port = '3005'
	var reverseProxyPort = '3009'
	
	if Engine.has_singleton("DebugMode") or ["Windows", "X11", "OSX"].has(OS.get_name()):
#		url = "ws://192.168.0.30:3009/"
		protocol = 'ws'
		port = reverseProxyPort
		url = "wss://192.168.0.30:3009/"
		
	
#	var currentUrl = JavaScript.eval("window.location.href")
#	print('urrrrrrrrrrrrrrrrrrrrrrrrrrl!!!', currentUrl)
	
	deviceType = _deviceType
	msg = AWebsocketService.new(url, deviceType)
	self.add_child(msg)
	

func _ready():
	print('Using ArcaneLibrary version ', LIBRARY_VERSION)
	Arcane.signals.connect("Initialize", self, 'initialize')
	Arcane.signals.connect("RefreshGlobalState", self, '_refreshGlobalState')

func initialize(initializeEvent, _from):
	refreshGlobalState(initializeEvent.globalState)

	var initialState = AModels.InitialState.new(pads)
	signals.emit_signal('ArcaneClientInitialized', initialState)
	Arcane.signals.disconnect('Initialize', self, 'initialize')


func _refreshGlobalState(e, _from):
	refreshGlobalState(e.refreshedGlobalState)

func refreshGlobalState(refreshedGlobalState):
	devices = refreshedGlobalState.devices
	refreshClientsIds(devices)
	pads = getPads(devices)
	for p in pads: 
		if p.deviceId == msg.deviceId:
			 pad = p

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
	var _pads:Array = []

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
