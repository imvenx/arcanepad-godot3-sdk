class_name AModels

class ArcaneClient:
	var id: String
	var clientType: String

	func _init(_id: String, _clientType: String) -> void:
		self.id = _id
		self.clientType = _clientType

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
	
	func _init(_clientType:String, _deviceType:String, _deviceId:String):
		self.clientType = _clientType
		self.deviceType = _deviceType
		self.deviceId = _deviceId

class AssignedDataInitEvent:
	var eventTag: String = "init"
	var assignedClientId: String
	var assignedDeviceId: String

class InitIframeQueryParams:
	var deviceId: String

class GlobalState:
	var devices = []

	func _init(_devices) -> void:
		self.devices = _devices

class InitialState:
	var pads = []

	func _init(_pads) -> void:
		self.pads = _pads

class ArcaneUser:
	var id: String
	var name: String
	var color: String

	func _init(_id: String, _name: String, _color: String) -> void:
		self.id = _id
		self.name = _name
		self.color = _color
		
		
class ArcaneInitParams:
	var deviceType:String
	var ipOctets:String
	var port:String
	var reverseProxyPort:String
	
	func _init(
		_deviceType:String = 'view', 
		_ipOctets:String = '', 
		_port:String = '3685', 
		_reverseProxyPort:String = '3689'
	):
		deviceType = _deviceType
		ipOctets = _ipOctets
		port = _port
		reverseProxyPort = _reverseProxyPort
