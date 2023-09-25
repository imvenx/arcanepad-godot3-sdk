#extends Node
#
#class_name AUtils
#
#func ascii_to_char(ascii_code):
#	var char_map = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.~"
#	for i in range(char_map.length()):
#		if ascii_code == ord(char_map[i]):
#			return char_map[i]
#	return null
#
#func urlEncode(s):
#	var result = ""
#	var utf8_bytes = s.to_utf8()
#	for i in range(utf8_bytes.size()):
#		var byte = utf8_bytes[i]
#		var byte_as_char = ascii_to_char(byte)
#		if byte_as_char:
#			result += byte_as_char
#		elif byte == 32:  # ASCII for space
#			result += "+"
#		else:
#			result += "%" + "%02X" % byte
#	return result
#
#func objectToDictionary(obj):
#	var result = {}
#	if obj is Array or typeof(obj) in [TYPE_REAL, TYPE_STRING, TYPE_INT]:
#		return obj
#
#	for property in obj.get_property_list():
#		var name = property["name"]
#		# Skip unwanted or built-in properties.
#		if name in ["script"]:
#			continue
#
#		var value = obj.get(name)
#		# Handle recursive conversion of objects, dictionaries, and arrays.
#		if value is Object:
#			value = objectToDictionary(value)
#		elif value is Array:
#			var newArray = []
#			for item in value:
#				if item is Object:
#					newArray.append(objectToDictionary(item))
#				else:
#					newArray.append(item)
#			value = newArray
#
#		result[name] = value
#	return result
#
#static func dictionaryToObject(dictionary):
#	var className = dictionary["name"] + "Event"
#	var instance = ClassDB.instance(className)
#
#	if instance == null:
#		print("Failed to instantiate class: ", className)
#		return null
#
#	for key in dictionary.keys():
#		var method_name = "set_" + key
#		if instance.has_method(method_name):
#			instance.call(method_name, dictionary[key])
#		else:
#			print("Method does not exist: ", method_name)
#
#	return instance
