extends CharacterBody3D
#@onready var camera = $Camera3D
@export var move_speed :=6
@onready var model = $model
@onready var interact = $model/Interact
func _physics_process(delta: float) -> void:
	var input_dir = Input.get_vector("left","right","forward","backward")
	if input_dir:
		model.rotation.y=lerp_angle(model.rotation.y,-input_dir.angle()-PI/2,delta*20)
	#input_dir = input_dir.rotated(-camera.rotation.y)
	velocity.x=input_dir.x*move_speed
	velocity.z=input_dir.y*move_speed
	move_and_slide()
	
	var grabstuff = interact.get_overlapping_bodies()
	if grabstuff:
		if Input.is_action_pressed("A"):
			if grabstuff[0].get_parent()!=self:
				position.x=round(position.x+0.5)-0.5
				position.z=round(position.z+0.5)-0.5
				var grabbedobj = grabstuff[0].duplicate()
				grabbedobj.position=grabstuff[0].global_position-global_position
				grabbedobj.get_node("CollisionShape3D").disabled=true
				add_child(grabbedobj)
				model.rotation.y=round((model.rotation.y/(PI/2)))*(PI/2)
				#model.rotation.y=Vector2(position.x,position.z).angle_to(Vector2(grabbedobj.position.x,grabbedobj.position.z))
				grabstuff[0].queue_free()
