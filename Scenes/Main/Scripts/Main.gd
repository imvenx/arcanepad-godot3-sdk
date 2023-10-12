extends Node2D

const PadScenePath = "res://Scenes/Pad/Pad.tscn"
const ViewScenePath = "res://Scenes/View/View.tscn"

var dir = Directory.new()

func _ready():
	
	Arcane.init()
	Arcane.signals.connect("ArcaneClientInitialized", self, "onArcaneClientInitialized")


func onArcaneClientInitialized(initialState):
		
	if dir.file_exists(PadScenePath) and not dir.file_exists(ViewScenePath):
		goToPadScene()
		return
	
	if not dir.file_exists(PadScenePath) and dir.file_exists(ViewScenePath):
		goToViewScene(initialState)
		return
		
	if Arcane.msg.deviceType == 'pad': 
		goToPadScene()
		return
		
	elif Arcane.msg.deviceType == 'view': 
		goToViewScene(initialState)
		return
	

func goToPadScene():
	get_tree().change_scene(PadScenePath)
	queue_free()


func goToViewScene(initialState):
	var viewScene = load(ViewScenePath).instance()
	viewScene.initViewScene(initialState)
	get_tree().root.add_child(viewScene)
	get_tree().current_scene = viewScene
	queue_free()
