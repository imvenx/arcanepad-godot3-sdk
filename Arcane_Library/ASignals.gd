extends Node

class_name ASignals

# warning-ignore:unused_signal
signal ArcaneClientInitialized(e, from)
# warning-ignore:unused_signal
signal Initialize(e, from)
# warning-ignore:unused_signal
signal UpdateUser(e, from)

# warning-ignore:unused_signal
signal OpenArcaneMenu(e, from)
# warning-ignore:unused_signal
signal CloseArcaneMenu(e, from)

# warning-ignore:unused_signal
signal ClientConnect(e, from)
# warning-ignore:unused_signal
signal ClientDisconnect(e, from)

# warning-ignore:unused_signal
signal IframePadConnect(e, from)

# warning-ignore:unused_signal
signal IframePadDisconnect(e, from)

# warning-ignore:unused_signal
signal StartGetQuaternion(e, from)
# warning-ignore:unused_signal
signal StopGetQuaternion(e, from)
# warning-ignore:unused_signal
signal GetQuaternion(e, from)
# warning-ignore:unused_signal
signal CalibrateQuaternion(e, from)

# warning-ignore:unused_signal
signal StartGetRotationEuler(e, from)
# warning-ignore:unused_signal
signal StopGetRotationEuler(e, from)
# warning-ignore:unused_signal
signal GetRotationEuler(e, from)

# warning-ignore:unused_signal
signal StartGetPointer(e, from)
# warning-ignore:unused_signal
signal StopGetPointer(e, from)
# warning-ignore:unused_signal
signal GetPointer(e, from)

# warning-ignore:unused_signal
signal CalibratePointer(e, from)
# warning-ignore:unused_signal
signal Vibrate(e, from)
# warning-ignore:unused_signal
signal RefreshGlobalState(e, from)

func addSignal(signalName:String): 
	for s in get_signal_list():
		if(s.name == signalName): return
		
	add_user_signal(signalName)

