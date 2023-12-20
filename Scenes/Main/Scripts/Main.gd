extends Node2D

const PadScenePath = "res://Scenes/Pad/Pad.tscn"
const ViewScenePath = "res://Scenes/View/View.tscn"

var dir = Directory.new()

func _ready():
	call_deferred("goToPropperScene")
	

func goToPropperScene():
	if dir.file_exists(PadScenePath) and not dir.file_exists(ViewScenePath):
		goToPadScene()
		return
	
	goToViewScene()


func goToPadScene():
	var _sceneChange = get_tree().change_scene(PadScenePath)
	queue_free()


func goToViewScene():
	var viewScene = load(ViewScenePath).instance()
	get_tree().root.add_child(viewScene)
	get_tree().current_scene = viewScene
	queue_free()
