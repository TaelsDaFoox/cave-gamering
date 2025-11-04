extends Node3D
var block = load("res://objects/block.tscn")
@onready var csgCombiner = $CSGCombiner3D

func _ready() -> void:
	for i in 10:
		for j in 10:
			var blockspawn = block.instantiate()
			blockspawn.position.x=i
			blockspawn.position.z=j
			csgCombiner.add_child(blockspawn)
