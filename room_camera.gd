extends Camera3D
@export var player: CharacterBody3D

func _physics_process(delta: float) -> void:
	if player:
		look_at(player.position)
