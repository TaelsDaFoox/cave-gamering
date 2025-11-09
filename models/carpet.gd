extends Node3D
@onready var mesh = $Plane
var carpettex = load("res://materials/carpet.tres")
func _ready() -> void:
	mesh.set_surface_override_material(0,carpettex)
	setCarpet(randi_range(0,67))
func setCarpet(carpetnum:int):
	carpettex.uv1_offset=Vector3(0.125*carpetnum,0.111*floor(carpetnum/9.0),0.0)
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("NewCarpet"):
		setCarpet(randi_range(0,67))
