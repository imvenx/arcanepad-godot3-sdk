extends Node

var players := [] 
var gameStarted := false
var isGamePaused := false
var playerScene = preload("res://Scenes/View/Player/Player.tscn")

#func _ready():
#	var initParams = { 'arcaneCode': '0.30' }
#	Arcane.init()
#	Arcane.signals.connect("ArcaneClientInitialized", self, "onArcaneClientInitialized")


func initViewScene(initialState):
		
	Arcane.signals.connect("IframePadConnect", self, "onIframePadConnect")
	Arcane.signals.connect("IframePadDisconnect", self, "onIframePadDisconnect")
#
#	Arcane.utils.writeToScreen(Arcane.msg.deviceType)
#	if Arcane.msg.deviceType == 'pad': get_tree().change_scene("res://Pad/Pad.tscn")

	for pad in initialState.pads:
		createPlayer(pad)

func onIframePadConnect(e, _from):
	var playerExists = false
	for _player in players:
		if _player.pad.iframeId == e.iframeId:
			playerExists = true
			break
	if playerExists:
		return

	var pad = ArcanePad.new(e.deviceId, e.internalId, e.iframeId, true, e.user)
	createPlayer(pad)


func onIframePadDisconnect(e, _from):
	var player = null
	for _player in players:
		if _player.pad.iframeId == e.iframeId:
			player = _player
			break
			
	if player == null:
		push_error("Player not found to remove on disconnect")
		return

	destroy_player(player)


func createPlayer(pad):
	var newPlayer = playerScene.instance()
	print(newPlayer)
	newPlayer.initialize(pad)
	add_child(newPlayer)
	players.append(newPlayer)


func destroy_player(player):
	players.erase(player)
	if player:	player.queue_free()
	
	
