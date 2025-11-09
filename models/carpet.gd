extends Node3D
@onready var mesh = $Plane
var carpettex = load("res://materials/shirt.tres")
func _ready() -> void:
	mesh.set_surface_override_material(0,carpettex)
