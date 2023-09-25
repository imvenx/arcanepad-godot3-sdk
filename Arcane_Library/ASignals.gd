extends Node

class_name ASignals

signal ArcaneClientInitialized(initialState)

signal Initialize(assignedClientId, assignedDeviceId, globalState)
signal UpdateUser(user)

signal OpenArcaneMenu
signal CloseArcaneMenu

signal ClientConnect(clientId, clientType)
signal ClientDisconnect(clientId, clientType)

signal IframePadConnect(clientId, internalId, deviceId)

signal IframePadDisconnect(IframeId, DeviceId)

signal StartGetQuaternion
signal StopGetQuaternion
#signal GetQuaternion(w, x, y, z)
signal GetQuaternion(e, from)
signal CalibrateQuaternion

signal StartGetRotationEuler
signal StopGetRotationEuler
signal GetRotationEuler(x, y, z)

signal StartGetPointer
signal StopGetPointer
signal GetPointer(x, y)

signal CalibratePointer
signal Vibrate(milliseconds)
signal RefreshGlobalState(refreshedGlobalState)
