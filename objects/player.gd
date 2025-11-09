extends CharacterBody3D
#@onready var camera = $Camera3D
@export var move_speed :=6
@onready var model = $model
@onready var interact = $Interact
var statetimer := 0.0
var state = "Idle"
var dragTarget=Vector3.ZERO
var angTarget=0.0
var grabbedthing = null
@onready var anim = $model/AnimationPlayer
@onready var shirt = $model/Armature/Skeleton3D/Shirt
var shirttex = load("res://materials/shirt.tres")
var inventory = load("res://Inventory.tscn")
var shirtmenu = load("res://shirtMenu.tscn")
func _ready() -> void:
	#shirttex.uv1_scale=Vector3(0.059,0.059,0)
	shirt.set_surface_override_material(0,shirttex)
	setShirt(0)
func _physics_process(delta: float) -> void:
	statetimer=move_toward(statetimer,0.0,delta)
	#print(state)
	#print(statetimer)
	var input_dir = Input.get_vector("left","right","forward","backward",0.5)
	if input_dir and not grabbedthing and not state=="Inventory":
		model.rotation.y=lerp_angle(model.rotation.y,-input_dir.angle()+PI/2,delta*20)
		interact.rotation.y=roundTo90(model.rotation.y)+PI
	#input_dir = input_dir.rotated(-camera.rotation.y)
	if state == "Push" or state == "Pull":
		#global_position=global_position.lerp(dragTarget,delta*8)
		velocity=(global_position.lerp(dragTarget,7))-global_position
		velocity.y=0.0
		#print(velocity)
		if statetimer==0.0:
			state="Idle"
			snapPos()
	if state == "TurnR" or state == "TurnL":
		anim.play(state,0.2,2.0)
		grabbedthing.rotation.y=lerp_angle(grabbedthing.rotation.y,angTarget,delta*10)
		if statetimer==0.0:
			state="Idle"
			snapPos()
	if grabbedthing:
		if state == "Idle":
			velocity=Vector3.ZERO
			anim.play("Grab",0.2,1.0)
		if state == "Push" or state == "Pull":
			anim.play(state,0.2,velocity.length()*1.1)
		#velocity=Vector3.ZERO
		if not Input.is_action_pressed("A") and statetimer==0.0:
			snapPos()
			var posBuffer = grabbedthing.global_position
			var rotBuffer = grabbedthing.rotation
			var placedobj = grabbedthing.duplicate()
			placedobj.global_position = posBuffer
			placedobj.rotation = rotBuffer
			placedobj.get_node("CollisionShape3D").disabled=false
			get_parent().add_child(placedobj)
			grabbedthing.queue_free()
			grabbedthing=null
			state = "Idle"
		if state == "Idle" and grabbedthing:
			if input_dir and statetimer==0.0:
				var dragAng = round((input_dir.angle()/(PI/2)))*(PI/2)
				dragTarget = global_position+Vector3(cos(dragAng),0,sin(dragAng))
				var grabAng = Vector2(global_position.x,global_position.z).angle_to_point(Vector2(grabbedthing.global_position.x,grabbedthing.global_position.z))#+(PI/2)
				#grabAng = model.rotation.y
				var angleDiff = (roundTo90(input_dir.angle())-grabAng)
				angleDiff=fmod(round(fposmod(angleDiff,2.0*PI)/(PI/2)),4.0)
				print(angleDiff)
				if angleDiff == 2.0:
					state = "Pull"
					statetimer=0.5
				if angleDiff == 0.0:
					state = "Push"
					statetimer=0.5
				if angleDiff == 1.0:
					angTarget=grabbedthing.rotation.y+(PI/2)
					state="TurnR"
					statetimer=0.5
				if angleDiff == 3.0:
					angTarget=grabbedthing.rotation.y-(PI/2)
					state="TurnL"
					statetimer=0.5
	elif state=="Idle" or state=="Grab": #no idea why this has to run for the grab animation to work but it's almost 1 AM and I don't care to look into it
		velocity.x=input_dir.x*move_speed
		velocity.z=input_dir.y*move_speed
		if input_dir:
			anim.play("Walk",0.2,velocity.length()/2.0)
		else:
			anim.play("Idle",0.2,1.0)
		
	
	move_and_slide()
	#print(state)
	
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
				model.rotation.y=roundTo90(-Vector2(global_position.x,global_position.z).angle_to_point(Vector2(grabbedobj.global_position.x,grabbedobj.global_position.z))+(PI/2))
				grabstuff[0].queue_free()
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("NewShirt"):
		setShirt(randi_range(0,255))
	if event.is_action_pressed("menu"):
		if state=="Idle":
			state="Inventory"
			anim.play("Inventory",0.3)
			velocity=Vector3.ZERO
			get_parent().add_child(shirtmenu.instantiate())
		elif state == "Inventory":
			state="Idle"
			get_parent().get_node("ShirtMenu").queue_free()
func snapPos():
	global_position.x = round(global_position.x+0.5)-0.5
	global_position.z = round(global_position.z-0.5)+0.5
func setShirt(shirtID:int):
	shirttex.uv1_offset=Vector3(0.0625*floor(shirtID/16.0),0.0625*shirtID,0.0)
	Global.shirtnum=shirtID
func roundTo90(angle:float):
	return round(angle/(PI/2))*(PI/2)
