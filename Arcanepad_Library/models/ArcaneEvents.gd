class_name AEvents

class ArcaneBaseEvent:
	var name: String

	func _init(_name: String):
		name = _name


class ArcaneMessageTo:
	var e: ArcaneBaseEvent
	var to

	func _init(_e: ArcaneBaseEvent, _to):
		e = _e
		to = _to


class ArcaneMessageFrom:
	var e: Dictionary
	var from: String

	func _init(_e: Dictionary, _from: String):
		e = _e
		from = _from

#
class InitializeEvent extends ArcaneBaseEvent:
	var assignedClientId: String
	var assignedDeviceId: String
	var globalState

	func _init(_assignedClientId: String, _assignedDeviceId: String, _globalState
	).(AEventName.Initialize):
		assignedClientId = _assignedClientId
		assignedDeviceId = _assignedDeviceId
		globalState = _globalState


class UpdateUserEvent extends ArcaneBaseEvent:
	var user

	func _init(_user
	).(AEventName.UpdateUser):
		user = _user


class OpenArcaneMenuEvent extends ArcaneBaseEvent:
	func _init().(AEventName.OpenArcaneMenu): pass

class CloseArcaneMenuEvent extends ArcaneBaseEvent:
	func _init().(AEventName.CloseArcaneMenu): pass



class ClientConnectEvent extends ArcaneBaseEvent:
	var clientId: String
	var clientType: String

	func _init(_clientId: String, _clientType: String
	).(AEventName.ClientConnect):
		clientId = _clientId
		clientType = _clientType


class ClientDisconnectEvent extends ArcaneBaseEvent:
	var clientId: String
	var clientType

	func _init(_clientId: String, _clientType
	).(AEventName.ClientDisconnect):
		clientId = _clientId
		clientType = _clientType


class IframePadConnectEvent extends ArcaneBaseEvent:
	var deviceId: String
	var internalId: String
	var iframeId: String

	func _init(_clientId: String, _internalId: String, _deviceId: String
	).(AEventName.IframePadConnect):
		iframeId = _clientId
		internalId = _internalId
		deviceId = _deviceId


class IframePadDisconnectEvent extends ArcaneBaseEvent:
	var IframeId: String
	var DeviceId: String

	func _init(_iframeId: String, _deviceId: String
	).(AEventName.IframePadDisconnect):
		IframeId = _iframeId
		DeviceId = _deviceId


class StartGetQuaternionEvent extends ArcaneBaseEvent:
	func _init().(AEventName.StartGetQuaternion): pass


class StopGetQuaternionEvent extends ArcaneBaseEvent:
	func _init().(AEventName.StopGetQuaternion): pass

class GetQuaternionEvent extends ArcaneBaseEvent:
	var w: float
	var x: float
	var y: float
	var z: float

	func _init(_w: float, _x: float, _y: float, _z: float
	).(AEventName.GetQuaternion):
		w = _w
		x = _x
		y = _y
		z = _z


class CalibrateQuaternionEvent extends ArcaneBaseEvent:
	func _init().(AEventName.CalibrateQuaternion): pass

class StartGetRotationEulerEvent extends ArcaneBaseEvent:
	func _init().(AEventName.StartGetRotationEuler): pass

class StopGetRotationEulerEvent extends ArcaneBaseEvent:
	func _init().(AEventName.StopGetRotationEuler): pass

class GetRotationEulerEvent extends ArcaneBaseEvent:
	var x: float
	var y: float
	var z: float

	func _init(_x: float, _y: float, _z: float
	).(AEventName.GetRotationEuler):
		x = _x
		y = _y
		z = _z

class StartGetPointerEvent extends ArcaneBaseEvent:
	func _init().(AEventName.StartGetPointer): pass

class StopGetPointerEvent extends ArcaneBaseEvent:
	func _init().(AEventName.StopGetPointer): pass

class GetPointerEvent extends ArcaneBaseEvent:
	var x: float
	var y: float

	func _init(_x: float, _y: float
	).(AEventName.GetPointer):
		x = _x
		y = _y

class CalibratePointerEvent extends ArcaneBaseEvent:
	var isTopLeft: bool
	func _init(_isTopLeft:bool).(AEventName.CalibratePointer):
		isTopLeft = _isTopLeft
		

class SetScreenOrientationPortraitEvent extends ArcaneBaseEvent:
	func _init().(AEventName.SetScreenOrientationPortrait):pass

class SetScreenOrientationLandscapeEvent extends ArcaneBaseEvent:
	func _init().(AEventName.SetScreenOrientationLandscape):pass


class VibrateEvent extends ArcaneBaseEvent:
	var milliseconds: int

	func _init(_milliseconds: int
	).(AEventName.Vibrate):
		milliseconds = _milliseconds

class RefreshGlobalStateEvent extends ArcaneBaseEvent:
	var refreshedGlobalState

	func _init(_refreshedGlobalState).(AEventName.RefreshGlobalState):
		refreshedGlobalState = _refreshedGlobalState
