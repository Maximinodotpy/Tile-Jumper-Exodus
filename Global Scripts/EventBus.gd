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
	if events.has(name):
		for callable in events[name]:
			callable.call(arguments)

#func _process(delta):
#	print(events)
