extends CharacterBody3D
#@onready var camera = $Camera3D
@export var move_speed :=6
@onready var model = $model
@onready var interact = $model/Interact
var statetimer := 0.0
var state = "Idle"
var dragTarget=Vector3.ZERO
var grabbedthing = null
func _physics_process(delta: float) -> void:
	#print(state)
	#print(statetimer)
	var input_dir = Input.get_vector("left","right","forward","backward")
	if input_dir:
		model.rotation.y=lerp_angle(model.rotation.y,-input_dir.angle()-PI/2,delta*20)
	#input_dir = input_dir.rotated(-camera.rotation.y)
	if state == "Drag":
		global_position=global_position.lerp(dragTarget,delta*8)
		statetimer=move_toward(statetimer,0.0,delta)
		if statetimer==0.0:
			state="Idle"
			snapPos()
	if grabbedthing:
		velocity=Vector3.ZERO
		if not Input.is_action_pressed("A") and statetimer==0.0:
			state = "Idle"
			snapPos()
			var posBuffer = grabbedthing.global_position
			var placedobj = grabbedthing.duplicate()
			placedobj.global_position = posBuffer
			placedobj.get_node("CollisionShape3D").disabled=false
			get_parent().add_child(placedobj)
			grabbedthing.queue_free()
			grabbedthing=null
		if state == "Idle" and grabbedthing:
			if input_dir:
				var dragAng = round((input_dir.angle()/(PI/2)))*(PI/2)
				dragTarget = global_position+Vector3(cos(dragAng),0,sin(dragAng))
				state = "Drag"
				statetimer=0.5
	else:
		velocity.x=input_dir.x*move_speed
		velocity.z=input_dir.y*move_speed
		
	
	move_and_slide()
	
	var grabstuff = interact.get_overlapping_bodies()
	if grabstuff:
		if Input.is_action_pressed("A"):
			if grabstuff[0].get_parent()!=self:
				global_position.x=round(global_position.x+0.5)-0.5
				global_position.z=round(global_position.z+0.5)-0.5
				var grabbedobj = grabstuff[0].duplicate()
				grabbedobj.position=grabstuff[0].global_position-global_position
				grabbedobj.get_node("CollisionShape3D").disabled=true
				add_child(grabbedobj)
				grabbedthing = grabbedobj
				#model.rotation.y=round((model.rotation.y/(PI/2)))*(PI/2)
				#model.rotation.y=Vector2(position.x,position.z).angle_to(Vector2(grabbedobj.position.x,grabbedobj.position.z))
				grabstuff[0].queue_free()
func snapPos():
	global_position.x = round(global_position.x+0.5)-0.5
	global_position.z = round(global_position.z-0.5)+0.5
