extends Node

var players := [] 
var gameStarted := false
var isGamePaused := false
var playerScene = preload("res://Player/Player.tscn")

#onready var Arcane = get_node('/root/Arcane')

func _ready():
	Arcane.msg.on("ArcaneClientInitialized", funcref(self, "onArcaneClientInitialized"))

func onArcaneClientInitialized(initialState):
	for pad in initialState.pads:
		createPlayer(pad)
		
#	initialState.pads[0].onDisconnect(asd)
		
	Arcane.msg.on("IframePadConnect", funcref(self, "onIframePadConnect"))
	Arcane.msg.on("IframePadDisconnect", funcref(self, "onIframePadDisconnect"))

func onIframePadConnect(e):
	var playerExists = false
	for _player in players:
		if _player.pad.iframeId == e.iframeId:
			playerExists = true
			break
	if playerExists:
		return

	var pad = ArcanePad.new(e.deviceId, e.internalId, e.iframeId, true, e.user)
	createPlayer(pad)

func asd():
	print('asdasd')

func onIframePadDisconnect(event):
	var player = null
	for _player in players:
		if _player.pad.iframeId == event.iframeId:
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
