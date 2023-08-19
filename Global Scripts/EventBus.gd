extends Node

var events = {}

func addEventListener(name: String, callable: Callable):
	if not events.has(name):
		events[name] = []

	events[name].append(callable)
	
func removeEventListener(name: String, callable: Callable):
	if events.has(name):
		var i = 0
		for saved_callable in events[name]:
			if callable == saved_callable:
				events[name].pop_at(i)
			i += 1
	
func emitEvent(name: String, arguments: Dictionary = {}):
	
	print('Event "' + name + '" called')
	
	if events.has(name):
		for callable in events[name]:
			print(callable)
			
			if callable.is_valid():
				callable.call(arguments)
