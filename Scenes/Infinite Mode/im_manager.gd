extends Node2D


@onready var deathWall = $"death_wall"


var parts = [
	preload("res://Scenes/Infinite Mode/Parts/part_1.tscn"),
	preload("res://Scenes/Infinite Mode/Parts/part_2.tscn"),
	preload("res://Scenes/Infinite Mode/Parts/part_3.tscn"),
	preload("res://Scenes/Infinite Mode/Parts/part_4.tscn"),
]

var offset = Vector2(100, 0)

@onready var player = $"../player"

# Called when the node enters the scene tree for the first time.
func _ready():

	EventBus.addEventListener('die', restart)

	for i in 3:
		addPart()

func restart(args = {}):
	offset = Vector2.ZERO

	for i in $"parts".get_children():
		i.queue_free()

	for i in 3:
		addPart()

	deathWall.position = Vector2(-deathWall.size.x - 200, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	deathWall.position.x += 2

	var distance = offset.x - player.position.x

	if (distance < 300):
		addPart()

	deathWall.position.y = player.position.y - deathWall.size.y / 2


func addPart():
	var scenePack: PackedScene = parts.pick_random()

	var scene: Node2D = scenePack.instantiate()

	scene.position = offset

	var offsetPosition: Marker2D = scene.find_child('endoffset')

	print(offsetPosition.position)

	scene.modulate = Color(1, 1, 1, 0)

	var tween = create_tween()

	tween.tween_property(scene, 'modulate', Color(1, 1, 1, 1), 1)

	offset += offsetPosition.position

	$"parts".add_child(scene)


