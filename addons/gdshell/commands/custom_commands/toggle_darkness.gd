extends GDShellCommand
# res://addons/gdshell/commands/hello.gd


func _init():

	COMMAND_AUTO_ALIASES = {
		"td": "toggle_darkness", # `sayHelloAlias` is alias to `sayHello`
  	}


func _main(argv, data):
	EventBus.emitEvent('toggle_darkness')
	
	return {}
