extends Node2D

func _ready():
	initPad()
	
	
func initPad():
	
	Arcane.init({'padOrientation': 'Portrait', 'deviceType': 'pad'})
	
	# LISTEN WHEN THIS CLIENT (GAMEPAD) IS INITIALIZED
	Arcane.signals.connect(AEventName.ArcaneClientInitialized, self, "onArcaneClientInitialized")
	
	
func onArcaneClientInitialized(initialState):
	
	# LISTEN CUSTOM EVENT FROM THE VIEW
	Arcane.signals.addSignal(EventName.TakeDamage)
	Arcane.signals.connect(EventName.TakeDamage, self, "onTakeDamage")
	
	
func _on_CalibrateQuaternion_pressed():
	Arcane.pad.calibrateQuaternion()


func _on_CalibratePointerTopLeft_pressed():
	Arcane.pad.calibratePointer(true)


func _on_CalibratePointerBottomRight_pressed():
	Arcane.pad.calibratePointer(false)


func _on_Attack_pressed():
	
	# EMIT CUSTOM EVENT TO THE VIEWS
	Arcane.msg.emitToViews(Events.AttackEvent.new())


func onTakeDamage(e, from):
	Arcane.pad.vibrate(200)
	Arcane.utils.writeToScreen("Taken " + str(e.damage) + " damage! Ouch!")
	
