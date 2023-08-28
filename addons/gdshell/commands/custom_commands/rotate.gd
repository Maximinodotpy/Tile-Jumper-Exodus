extends GDShellCommand
# res://addons/gdshell/commands/hello.gd


func _init():

	COMMAND_AUTO_ALIASES = {
		"r": "rotate", # `sayHelloAlias` is alias to `sayHello`
  	}


func _main(argv, data):

	if argv.size() == 2:
		if argv[1] == 'l':
			EventBus.emitEvent('rotate_left')
		elif argv[1] == 'r':
			EventBus.emitEvent('rotate_right')
			output("Rotating Right!")
	else:
		output('There was no direction given (r or l)')

	return {}
