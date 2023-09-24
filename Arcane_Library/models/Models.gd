class_name AModels

class ArcaneClient:
	var id: String
	var clientType: String

	func _init(id: String, clientType: String) -> void:
		self.id = id
		self.clientType = clientType

class ArcaneClientType:
	const internal = "internal"
	const iframe = "iframe"
	const external = "external"

class ArcaneDevice:
	var id: String
	var clients = []
	var deviceType: String
	var user = null

class ArcaneDeviceType:
	const pad = "pad"
	const view = "view"
	const none = "none"

enum ArcaneDeviceTypeEnum { view, pad }

class ArcaneClientInitData:
	var clientType: String
	var deviceType: String
	var deviceId: String
	
	func _init(clientType:String, deviceType:String, deviceId:String):
		self.clientType = clientType
		self.deviceType = deviceType
		self.deviceId = deviceId

class AssignedDataInitEvent:
	var eventTag: String = "init"
	var assignedClientId: String
	var assignedDeviceId: String

class InitIframeQueryParams:
	var deviceId: String

class GlobalState:
	var devices = []

	func _init(devices) -> void:
		self.devices = devices

class InitialState:
	var pads = []

	func _init(pads) -> void:
		self.pads = pads

class ArcaneUser:
	var id: String
	var name: String
	var color: String

	func _init(id: String, name: String, color: String) -> void:
		self.id = id
		self.name = name
		self.color = color
