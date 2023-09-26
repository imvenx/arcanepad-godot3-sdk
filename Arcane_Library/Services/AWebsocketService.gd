extends Node

class_name AWebsocketService
	
var ws = WebSocketClient.new()
var events: Dictionary = {}
var clientId: String
var deviceId: String
var reconnection_delay_miliseconds: int = 1000
var clientInitData
var url: String
var deviceType:String
var isConnected = false

func _init(_url: String, _deviceType: String) -> void:
	url = _url
	deviceType = _deviceType
	initWebsocket()


func initWebsocket():
	var clientInitData = getClientInitData()
	
	var stringifiedClientInitData = to_json(clientInitData)
	print(stringifiedClientInitData)
	var encodedClientInitData = urlEncode(stringifiedClientInitData)
	url = url + "?clientInitData=" + encodedClientInitData
	connectToServer(url)
	Arcane.signals.connect('Initialize', self, 'onInitialize')

func getQueryParamsDictionary():
	var queryParams = {}
	if Engine.has_singleton("JavaScript"):
		var query_string = JavaScript.eval("window.location.search.substring(1);")
		
		if query_string.empty():
			return queryParams  # Return empty dictionary if no query string

		var pairs = query_string.split("&")
		
		for pair in pairs:
			var key_value = pair.split("=")
			if key_value.size() == 2:
				queryParams[key_value[0]] = key_value[1]
	
	return queryParams

func getClientInitData():
	
	if !Arcane.isIframe: return { "clientType": "external", "deviceType": deviceType }
	
	var params = getQueryParamsDictionary()
	deviceId = params.deviceId
	
	if !deviceId: printerr('Missing device Id on query params')
	return { "clientType": "iframe", "deviceId": deviceId }

func onInitialize(e, _from):
	if e.assignedClientId == null or e.assignedClientId == "":
		printerr("Missing clientId on initialize")
		return
	if e.assignedDeviceId == null or e.assignedDeviceId == "":
		printerr("Missing deviceId on initialize")
		return
		
	clientId = e["assignedClientId"]
	deviceId = e["assignedDeviceId"]
	print("Client initialized with clientId: %s and deviceId: %s" % [clientId, deviceId])


func connectToServer(_url:String) -> void:
	print("connecting  to server: ", _url)
	
	ws.connect("connection_closed", self, "_closed")
	ws.connect("connection_error", self, "_closed")
	ws.connect("connection_established", self, "_connected")
	ws.connect("data_received", self, "onMessage")
	var err = ws.connect_to_url(_url, ["lws-mirror-protocol"])
	if err != OK:
		print("Unable to connect")
		set_process(false)


func _closed(was_clean = false):
	print("Closed, clean: ", was_clean)
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

	var msgDict = objectToDictionary(msg)
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




# UTILS:

func ascii_to_char(ascii_code):
	var char_map = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.~"
	for i in range(char_map.length()):
		if ascii_code == ord(char_map[i]):
			return char_map[i]
	return null

func urlEncode(s):
	var result = ""
	var utf8_bytes = s.to_utf8()
	for i in range(utf8_bytes.size()):
		var byte = utf8_bytes[i]
		var byte_as_char = ascii_to_char(byte)
		if byte_as_char:
			result += byte_as_char
		elif byte == 32:  # ASCII for space
			result += "+"
		else:
			result += "%" + "%02X" % byte
	return result

func objectToDictionary(obj):
	var result = {}
	if obj is Array or typeof(obj) in [TYPE_REAL, TYPE_STRING, TYPE_INT, TYPE_BOOL]:
		return obj

	for property in obj.get_property_list():
		var name = property.name
		if name in ["script"]:
			continue

		var value = null
		if obj.has_method("get"):
			value = obj.get(name)
		else:
			print("Method get() not found for ", name)

		if value == null:
#			print("Property is null: ", name)
			continue

		if value is Object:
			value = objectToDictionary(value)
		elif value is Array:
			var newArray = []
			for item in value:
				if item is Object:
					newArray.append(objectToDictionary(item))
				else:
					newArray.append(item)
			value = newArray

		result[name] = value
	return result
