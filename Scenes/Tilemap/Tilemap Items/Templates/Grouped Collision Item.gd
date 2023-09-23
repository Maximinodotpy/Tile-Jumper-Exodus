extends Node2D

class_name GroupedCollisionTilemapItem

@export var id: String

var collision_count = 0

func _ready():
	add_to_group(id)

func entered():
	pass

func _on_area_2d_body_entered(body):
	if collision_count == 0:
		entered()

	collision_count += 1

	for node in get_tree().get_nodes_in_group(id):
		node.collision_count = collision_count

func _on_area_2d_body_exited(body):
	collision_count -= 1

	for node in get_tree().get_nodes_in_group(id):
		node.collision_count = collision_count
