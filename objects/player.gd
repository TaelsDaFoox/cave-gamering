extends CharacterBody3D
#@onready var camera = $Camera3D
@export var move_speed :=6
@onready var model = $model
@onready var interact = $Interact
var statetimer := 0.0
var state = "Idle"
var dragTarget=Vector3.ZERO
var grabbedthing = null
@onready var anim = $model/AnimationPlayer
@onready var shirt = $model/Armature/Skeleton3D/Shirt
var shirttex = load("res://materials/shirt.tres")
var shirtnum = randi_range(0,272)
func _ready() -> void:
	#shirttex.uv1_scale=Vector3(0.059,0.059,0)
	shirttex.uv1_offset=Vector3(0.0625*shirtnum,0.0625*floor(shirtnum/16.0),0.0)
	shirt.set_surface_override_material(0,shirttex)
func _physics_process(delta: float) -> void:
	statetimer=move_toward(statetimer,0.0,delta)
	#print(state)
	#print(statetimer)
	var input_dir = Input.get_vector("left","right","forward","backward")
	if input_dir and not grabbedthing:
		model.rotation.y=lerp_angle(model.rotation.y,-input_dir.angle()+PI/2,delta*20)
	#input_dir = input_dir.rotated(-camera.rotation.y)
	if state == "Drag":
		#global_position=global_position.lerp(dragTarget,delta*8)
		velocity=(global_position.lerp(dragTarget,7))-global_position
		velocity.y=0.0
		#print(velocity)
		if statetimer==0.0:
			state="Idle"
			snapPos()
	if grabbedthing:
		if state == "Idle":
			velocity=Vector3.ZERO
			anim.play("Grab",0.2,1.0)
		if state == "Drag":
			anim.play("Pull",0.2,velocity.length()*1.1)
		#velocity=Vector3.ZERO
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
			if input_dir and statetimer==0.0:
				var dragAng = round((input_dir.angle()/(PI/2)))*(PI/2)
				dragTarget = global_position+Vector3(cos(dragAng),0,sin(dragAng))
				state = "Drag"
				statetimer=0.5
	else:
		velocity.x=input_dir.x*move_speed
		velocity.z=input_dir.y*move_speed
		if input_dir:
			anim.play("Walk",0.2,3.0)
		else:
			anim.play("Idle",0.2,1.0)
		
	
	move_and_slide()
	
	var grabstuff = interact.get_overlapping_bodies()
	if grabstuff:
		if Input.is_action_pressed("A"):
			if grabstuff[0].get_parent()!=self:
				statetimer=0.15
				global_position.x=round(global_position.x+0.5)-0.5
				global_position.z=round(global_position.z+0.5)-0.5
				var grabbedobj = grabstuff[0].duplicate()
				grabbedobj.position=grabstuff[0].global_position-global_position
				grabbedobj.get_node("CollisionShape3D").disabled=true
				add_child(grabbedobj)
				grabbedthing = grabbedobj
				#model.rotation.y=round((model.rotation.y/(PI/2)))*(PI/2)
				model.rotation.y=-Vector2(global_position.x,global_position.z).angle_to_point(Vector2(grabbedobj.global_position.x,grabbedobj.global_position.z))+(PI/2)
				grabstuff[0].queue_free()
func snapPos():
	global_position.x = round(global_position.x+0.5)-0.5
	global_position.z = round(global_position.z-0.5)+0.5
