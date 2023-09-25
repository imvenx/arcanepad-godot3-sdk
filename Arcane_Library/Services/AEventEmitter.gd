class_name AEventEmitter extends Node

var _events = {}

func on(eventName: String, callback: FuncRef):
	if not _events.has(eventName):
		_events[eventName] = []
	_events[eventName].append(callback)

func emit(eventName: String, eventData = null):
	if _events.has(eventName):
		for callback in _events[eventName]:
			callback.call_func(eventData)

func off(eventName: String, callback: FuncRef):
	if _events.has(eventName):
		_events[eventName].erase(callback)

func offAll(eventName: String):
	if _events.has(eventName):
		_events[eventName] = []
		
func dispose():
	_events.clear()
