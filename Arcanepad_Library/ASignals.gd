extends Node

class_name ASignals

# warning-ignore:unused_signal
signal _ArcaneClientInitialized(e, from)
# warning-ignore:unused_signal
signal _Initialize(e, from)
# warning-ignore:unused_signal
signal _UpdateUser(e, from)

# warning-ignore:unused_signal
signal _OpenArcaneMenu(e, from)
# warning-ignore:unused_signal
signal _CloseArcaneMenu(e, from)

# warning-ignore:unused_signal
signal _ClientConnect(e, from)
# warning-ignore:unused_signal
signal _ClientDisconnect(e, from)

# warning-ignore:unused_signal
signal _IframePadConnect(e, from)

# warning-ignore:unused_signal
signal _IframePadDisconnect(e, from)

# warning-ignore:unused_signal
signal _StartGetQuaternion(e, from)
# warning-ignore:unused_signal
signal _StopGetQuaternion(e, from)
# warning-ignore:unused_signal
signal _GetQuaternion(e, from)
# warning-ignore:unused_signal
signal _CalibrateQuaternion(e, from)

# warning-ignore:unused_signal
signal _StartGetRotationEuler(e, from)
# warning-ignore:unused_signal
signal _StopGetRotationEuler(e, from)
# warning-ignore:unused_signal
signal _GetRotationEuler(e, from)

# warning-ignore:unused_signal
signal _StartGetPointer(e, from)
# warning-ignore:unused_signal
signal _StopGetPointer(e, from)
# warning-ignore:unused_signal
signal _GetPointer(e, from)

# warning-ignore:unused_signal
signal _CalibratePointer(e, from)
# warning-ignore:unused_signal
signal _Vibrate(e, from)
# warning-ignore:unused_signal
signal _RefreshGlobalState(e, from)

func addSignal(signalName:String): 
	for s in get_signal_list():
		if(s.name == signalName): return
		
	add_user_signal(signalName)

