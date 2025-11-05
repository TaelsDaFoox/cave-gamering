extends CharacterBody3D
#@onready var camera = $Camera3D
@export var move_speed :=8
@onready var model = $model
func _physics_process(delta: float) -> void:
	var input_dir = Input.get_vector("left","right","forward","backward")
	if input_dir:
		model.rotation.y=lerp_angle(model.rotation.y,-input_dir.angle()-PI/2,delta*20)
	#input_dir = input_dir.rotated(-camera.rotation.y)
	velocity.x=input_dir.x*move_speed
	velocity.z=input_dir.y*move_speed
	move_and_slide()
