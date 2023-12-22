extends Node

class_name AWebsocketService
	
var ws = WebSocketClient.new()
var events: Dictionary = {}
var clientId: String
var deviceId: String
var reconnection_delay_miliseconds: int = 1000
var clientInitData
var deviceType:String
var isConnected = false

var host: String
var protocol:String
var port:String
var reverseProxyPort:String
var ipOctets:String
var url:String

var clientType

func _init(params) -> void:
	initWebsocket(params)


func initWebsocket(params):
	if Engine.has_singleton("DebugMode") or ["Windows", "X11", "OSX"].has(OS.get_name()):
		initAsExternalClient(params)
		
	else: initAsIframeClient(params)

	if clientInitData == null: 
		printerr("ArcaneError: clientInitData is null on initWebSocket")
		return
		
	if url == null or url == "":
		printerr("ArcaneError: url is null or empty on initWebSocket")
		return
		
	var stringifiedClientInitData = to_json(clientInitData)
	print(stringifiedClientInitData)
	var encodedClientInitData = Arcane.utils.urlEncode(stringifiedClientInitData)
	url = url + "?clientInitData=" + encodedClientInitData
	connectToServer(url)


func initAsExternalClient(params):
#	if not params.has('arcaneCode') or !params.arcaneCode:
#		printerr('Arcane Error: Need to specify arcaneCode on init i.e: Arcane.init({ arcaneCode: 0.64 }) to get the arcane code go to ArcanePad App, it should be displayed on top or on connect option.')
#		return
	
	protocol = 'ws'
	host = '127.0.0.1'
#	host = '192.168.' + params.arcaneCode
	if not params.has('reverseProxyPort'): params['reverseProxyPort'] = '3689'
	if not params.has('deviceType'): params['deviceType'] = 'view'
	deviceType = params.deviceType
	url = protocol + '://' + host + ':' + params.reverseProxyPort + '/'
	clientType = "external"
	clientInitData = { "clientType": clientType, "deviceType": deviceType }
	
	
func initAsIframeClient(params):
	
	var isWebEnv = OS.get_name() == "HTML5"
	if !isWebEnv:
		printerr('Trying to init as iframe client but env is not web')
		return
		
	var isIframe = JavaScript.eval('window.self !== window.top')
	if !isIframe: 
		printerr('Trying to init iframe client but is not iframe')
		return
		
	var queryParams = Arcane.utils.getQueryParamsDictionary()
	deviceId = queryParams.deviceId
	
	if !deviceId: 
		printerr('Missing deviceId on query params on initAsIframeClient')
		return
		
	clientType = "iframe"
	clientInitData = { "clientType": clientType, "deviceId": deviceId }
		
	if not params.has('port') or !params.port: params.port = '3685'
	
	host = JavaScript.eval('window.location.hostname')
	protocol = 'wss'
	url = protocol + '://' + host + ':' + params.port + '/'	
	
	
# This is being called from Arcane.onInitialize, since the order of signals wasn't
# being respected and that would break initialization
func onInitialize(e):
	if e.assignedClientId == null or e.assignedClientId == "":
		printerr("Missing clientId on initialize")
		return
	if e.assignedDeviceId == null or e.assignedDeviceId == "":
		printerr("Missing deviceId on initialize")
		return
		
	clientId = e["assignedClientId"]
	deviceId = e["assignedDeviceId"]
	
	for d in Arcane.devices:
		if(d.id == deviceId):
			deviceType = d.deviceType
			
	prints("Client initialized. clientId:",clientId, "and deviceId:", deviceId, "deviceType:", deviceType)


func connectToServer(_url:String) -> void:
	print("connecting  to server: ", _url)
	
	ws.connect("connection_closed", self, "_closed")
	ws.connect("connection_error", self, "_closed")
	ws.connect("connection_established", self, "_connected")
	ws.connect("data_received", self, "onMessage")
	var err = ws.connect_to_url(_url, ["lws-mirror-protocol"])
	if err != OK:
		printerr("Unable to connect")
		set_process(false)


func _closed(was_clean = false):
	if was_clean: print("Closed, clean: ", was_clean)
	else: printerr("Closed, clean: ", was_clean)
	set_process(false)


func _connected(proto = ""):
	print("Connected with protocol: ", proto)


func _process(_delta: float) -> void:
	ws.poll()


func onOpen() -> void:
	print("WebSocket connection opened.")


func onClose(was_clean: bool, code: int, reason: String) -> void:
	if was_clean:
		print("WebSocket connection closed cleanly, code=%s, reason=%s" % [str(code), reason])
	else:
		printerr("WebSocket connection died")
		yield(get_tree().create_timer(float(reconnection_delay_miliseconds) / 1000.0), "timeout")
		reconnect()


func onError():
	print("Error on ws connection")


func onMessage() -> void:
	var jsonData = ws.get_peer(1).get_packet().get_string_from_utf8()
	var arcaneMessageFrom = parse_json(jsonData)
	
#	print('received event: ', arcaneMessageFrom.e.name)

	Arcane.signals.emit_signal(arcaneMessageFrom.e.name, arcaneMessageFrom.e, arcaneMessageFrom.from)


func emit(event: AEvents.ArcaneBaseEvent, to: Array) -> void:
	var msg = AEvents.ArcaneMessageTo.new(event, to)
	print("Sending message: ", msg.e.name, " to: ", to)

	var msgDict = Arcane.utils.objectToDictionary(msg)
	var msgJson = to_json(msgDict)
	print(msgJson)
	ws.get_peer(1).put_packet(msgJson.to_utf8())


func emitToViews(e):
	emit(e, Arcane.iframeViewsIds)

func emitToPads(e):
	emit(e, Arcane.iframePadsIds)


func close() -> void:
	ws.close()


func reconnect() -> void:
	print("Attempting to reconnect...")
	connectToServer(url)
