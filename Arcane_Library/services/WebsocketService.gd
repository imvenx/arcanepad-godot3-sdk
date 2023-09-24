extends Node

class_name WebsocketService

signal event_received(event_data, from)

var ws: WebSocketPeer = WebSocketPeer.new()
var event_handlers: Dictionary = {}
var client_id: String
var device_id: String
var reconnection_delay_miliseconds: int = 1000
var client_init_data: AModels.ArcaneClientInitData
var url: String
var device_type:String

func _init(url: String, device_type: String) -> void:
	self.url = url
	self.device_type = device_type
	initWebsocket()
#	self.connect("event_received", self, "on_initialize")
#	connect_to_server()

func initWebsocket():
	client_init_data = AModels.ArcaneClientInitData.new("external", "godot-dev", device_type)
	var clientInitDataStr = JSON.stringify(client_init_data)
	url = url + "?clientInitData=" + clientInitDataStr
	
	ws.connect("connection_established", on_open)
	connectToServer()

func connectToServer() -> void:
	var err = ws.connect_to_url(url)
	if err != OK:
		printerr("Failed to connect:", err)
		return

func _process(delta: float) -> void:
	ws.poll()
	var state = ws.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		print("WebSocket connection opened.")
	elif state == WebSocketPeer.STATE_CLOSED:
		print("Connection closed")
		set_process(false)
		await get_tree().create_timer(float(reconnection_delay_miliseconds) / 1000.0).timeout
		reconnect()
#
func on_open() -> void:
	print("WebSocket connection opened.")
#
#func on_error(error: String) -> void:
#	printerr("WebSocket Error: %s" % error)
#
#func on_close(was_clean: bool, code: int, reason: String) -> void:
#	if was_clean:
#		print("WebSocket connection closed cleanly, code=%s, reason=%s" % [str(code), reason])
#	else:
#		printerr("WebSocket connection died")
#		# Replacing yield with await in Godot 4
#		await get_tree().create_timer(float(reconnection_delay_miliseconds) / 1000.0).timeout
#		reconnect()

#func on_message(data: String) -> void:
#	var event: Dictionary = {}
#	try:
#		event = parse_json(data)
#		if event_handlers.has(event["e"]["name"]):
#			for callback in event_handlers[event["e"]["name"]]:
#				callback(event["e"], event["from"])
#	except e:
#		printerr("Error on onMessage: %s" % e)

#func emit(event: Dictionary, to: Array) -> void:
#	var msg: Dictionary = {"event": event, "to": to}
#	print("Sending message: %s" % str(msg))
#	ws.send(to_json(msg))

#func on(event_name: String, callback: Signal) -> void:
#	if not event_handlers.has(event_name):
#		event_handlers[event_name] = []
#	event_handlers[event_name].append(callback)

#func off(event_name: String, callback: Signal) -> void:
#	if not event_handlers.has(event_name):
#		return
#	if callback:
#		event_handlers[event_name].erase(callback)
#		if event_handlers[event_name].size() == 0:
#			event_handlers.erase(event_name)
#	else:
#		event_handlers.erase(event_name)

#func close() -> void:
#	ws.close()

func reconnect() -> void:
	print("Attempting to reconnect...")
	connectToServer()

#func initialize_ws(url: String, client_init_data: Dictionary) -> void:
#	ws.uri = "%s?clientInitData=%s" % [url, to_json(client_init_data)]
#	ws.connect("connection_established", self, "on_open")
#	ws.connect("connection_error", self, "on_error")
#	ws.connect("connection_closed", self, "on_close")
#	ws.connect("data_received", self, "on_message")
#	ws.connect_to_url(ws.uri)

#const InitializeEvent = preload("res://models/arcaneevents.gd").InitializeEvent

#func on_initialize(e: ArcaneEvents.InitializeEvent) -> void:
#	if not e.has("assignedClientId"):
#		return printerr("Missing client id on initialize")
#	if not e.has("assignedDeviceId"):
#		return printerr("Missing device id on initialize")
#	client_id = e["assignedClientId"]
#	device_id = e["assignedDeviceId"]
#	print("Client initialized with clientId: %s and deviceId: %s" % [client_id, device_id])
