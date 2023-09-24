class_name Arcane

var msg = null
var devices = []
var pads = []
var internalViewsIds = []
var internalPadsIds = []
var iframeViewsIds = []
var iframePadsIds = []
var _pad = null

func _ready():
	var url = "wss://localhost:3005"
	
	if Engine.has_singleton("DebugMode") or ["Windows", "X11", "OSX"].has(OS.get_name()):
		url = "ws://localhost:3009"

	var deviceType = "view"
#	msg = WebsocketService.new(url, deviceType)
