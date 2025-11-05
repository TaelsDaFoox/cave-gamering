extends Node3D
var block = load("res://objects/block.tscn")
@onready var csgCombiner = $CSGCombiner3D
var worldsize := 16

func _ready() -> void:
	for i in 16:
		for j in 16:
			var blockspawn = block.instantiate()
			blockspawn.position.x=i-16/2
			blockspawn.position.z=j-16/2
			csgCombiner.add_child(blockspawn)
