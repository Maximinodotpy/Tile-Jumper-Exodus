extends GDShellCommand
# res://addons/gdshell/commands/hello.gd

func _main(argv, data):
	output("Inverting Gravity!")
	EventBus.emitEvent('level:invert_gravity')
		
	return {}
