extends Control
@onready var firstbtn = $GridContainer/Table
func _ready() -> void:
	firstbtn.grab_focus()
func _on_table_pressed() -> void:
	objSpawn(load("res://objects/table.tscn"))

func roundTo90(angle:float):
	return round(angle/(PI/2))*(PI/2)
func snapPosToGrid(pos:Vector3):
	return Vector3(round(pos.x-0.5)+0.5,1.0,round(pos.z-0.5)+0.5)
func objSpawn(obj):
	if not Global.playerGrab:
		var spawn = obj.instantiate()
		var playerAng = roundTo90(-Global.playerRot.y)+(PI/2)
		spawn.global_position=snapPosToGrid(Global.playerPos+Vector3(cos(playerAng),0.0,sin(playerAng)))
		get_parent().add_child(spawn)


func _on_remove_pressed() -> void:
	if Global.playerGrab:
		Global.playerGrab[0].queue_free()


func _on_chair_pressed() -> void:
	objSpawn(load("res://objects/chair.tscn"))
