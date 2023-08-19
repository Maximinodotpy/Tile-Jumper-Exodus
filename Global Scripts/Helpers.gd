extends Node

func getSceneRoot():
	return get_tree().root.get_child(-1)

func formatSeconds(time : float, use_milliseconds : bool) -> String:
	var minutes := time / 60
	var seconds := fmod(time, 60)
	if not use_milliseconds:
		return "%02d:%02d" % [minutes, seconds]
	var milliseconds := fmod(time, 1) * 100
	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds]

func getAllFilesInDirectory(path):
	var files = []
	var dir = DirAccess.open(path)
	
	if dir:
		dir.list_dir_begin()
	
		while true:
			var file = dir.get_next()
			if file == "":
				break
			elif not file.begins_with("."):
				files.append(file)
				
		return files
