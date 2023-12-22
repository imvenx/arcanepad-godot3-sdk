extends Node 

class_name AUtils

func getQueryParamsDictionary():
	var queryParams = {}
	if Engine.has_singleton("JavaScript"):
		var query_string = JavaScript.eval("window.location.search.substring(1);")
		
		if query_string.empty():
			return queryParams  # Return empty dictionary if no query string

		var pairs = query_string.split("&")
		
		for pair in pairs:
			var key_value = pair.split("=")
			if key_value.size() == 2:
				queryParams[key_value[0]] = key_value[1]
	
	return queryParams
	
	
func ascii_to_char(ascii_code):
	var char_map = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.~"
	for i in range(char_map.length()):
		if ascii_code == ord(char_map[i]):
			return char_map[i]
	return null


func urlEncode(s):
	var result = ""
	var utf8_bytes = s.to_utf8()
	for i in range(utf8_bytes.size()):
		var byte = utf8_bytes[i]
		var byte_as_char = ascii_to_char(byte)
		if byte_as_char:
			result += byte_as_char
		elif byte == 32:  # ASCII for space
			result += "+"
		else:
			result += "%" + "%02X" % byte
	return result


func objectToDictionary(obj):
	var result = {}
	if obj is Array or typeof(obj) in [TYPE_REAL, TYPE_STRING, TYPE_INT, TYPE_BOOL]:
		return obj

	for property in obj.get_property_list():
		var name = property.name
		if name in ["script"]:
			continue

		var value = null
		if obj.has_method("get"):
			value = obj.get(name)
		else:
			print("Method get() not found for ", name)

		if value == null:
#			print("Property is null: ", name)
			continue

		if value is Object:
			value = objectToDictionary(value)
		elif value is Array:
			var newArray = []
			for item in value:
				if item is Object:
					newArray.append(objectToDictionary(item))
				else:
					newArray.append(item)
			value = newArray

		result[name] = value
	return result


var textPosX: = 30
var textPosY = 30

func writeToScreen(text:String):
	prints('writing to screen:', text)
	var label = Label.new() 
	label.text = text 
	label.add_color_override("font_color", Color(0.2, 0.2, 0.2))
	add_child(label)  
	label.rect_position = Vector2(textPosX, textPosY) 
	textPosY += 20
