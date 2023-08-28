extends GDShellCommand
# res://addons/gdshell/commands/hello.gd


func _init():

	COMMAND_AUTO_ALIASES = {
		"ig": "invert_gravity", # `sayHelloAlias` is alias to `sayHello`
  	}


func _main(argv, data):
	output("Inverting Gravity!")
	EventBus.emitEvent('invert_gravity')

	return {}
