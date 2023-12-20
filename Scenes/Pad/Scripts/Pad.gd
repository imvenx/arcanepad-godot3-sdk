extends Node2D

func _ready():
	initPad()
	
	
func initPad():
	
	Arcane.init({'padOrientation': 'Portrait', 'deviceType': 'pad'})
	
	Arcane.signals.connect("ArcaneClientInitialized", self, "onArcaneClientInitialized")
	
	
func onArcaneClientInitialized(initialState):
	
	Arcane.signals.addSignal("TakeDamage")
	Arcane.signals.connect("TakeDamage", self, "TakeDamage")
	
	
func _on_CalibrateQuaternion_pressed():
	Arcane.pad.calibrateQuaternion()


func _on_CalibratePointerTopLeft_pressed():
	Arcane.pad.calibratePointer(true)


func _on_CalibratePointerBottomRight_pressed():
	Arcane.pad.calibratePointer(false)


func _on_Attack_pressed():
	Arcane.msg.emitToViews(Events.AttackEvent.new())


func TakeDamage(e, from):
	Arcane.pad.vibrate(500)
	Arcane.utils.writeToScreen("ouch!")
