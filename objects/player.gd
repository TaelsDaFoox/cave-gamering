extends CharacterBody3D
#@onready var camera = $Camera3D
@export var move_speed :=6
@onready var model = $model
@onready var interact = $model/Interact
var grabbedthing = null
func _physics_process(delta: float) -> void:
	var input_dir = Input.get_vector("left","right","forward","backward")
	if input_dir:
		model.rotation.y=lerp_angle(model.rotation.y,-input_dir.angle()-PI/2,delta*20)
	#input_dir = input_dir.rotated(-camera.rotation.y)
	velocity.x=input_dir.x*move_speed
	velocity.z=input_dir.y*move_speed
	if grabbedthing and not input_dir:
		position=position.lerp(Vector3(round(position.x+0.5)-0.5,position.y,round(position.z+0.)-0.5),delta*10)
	move_and_slide()
	
	if grabbedthing and not Input.is_action_pressed("A"):
		position.x = round(position.x+0.5)-0.5
		position.z = round(position.z+0.5)-0.5
		var posBuffer = grabbedthing.global_position
		var placedobj = grabbedthing.duplicate()
		placedobj.global_position = posBuffer
		placedobj.get_node("CollisionShape3D").disabled=false
		get_parent().add_child(placedobj)
		grabbedthing.queue_free()
		grabbedthing=null
	
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
				grabbedthing = grabbedobj
				model.rotation.y=round((model.rotation.y/(PI/2)))*(PI/2)
				#model.rotation.y=Vector2(position.x,position.z).angle_to(Vector2(grabbedobj.position.x,grabbedobj.position.z))
				grabstuff[0].queue_free()
