extends CharacterBody3D
@onready var camera = $Camera3D
@export var move_speed :=10
@export var mouse_sensitivity:=0.005
@onready var flashlight = $SpotLight3D
@onready var enemytimer=$EnemySpawnTimer
var spook = load("res://spooky.tscn")
func _physics_process(delta: float) -> void:
	var input_dir = Input.get_vector("left","right","forward","backward")
	input_dir = input_dir.rotated(-camera.rotation.y)
	velocity.x=input_dir.x*move_speed
	velocity.z=input_dir.y*move_speed
	move_and_slide()
	flashlight.rotation.y = lerp_angle(flashlight.rotation.y,camera.rotation.y,delta*10)
	flashlight.rotation.x = lerp_angle(flashlight.rotation.x,camera.rotation.x,delta*10)
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("lock mouse"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("unlock mouse"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		camera.rotation.y-=event.relative.x*mouse_sensitivity
		camera.rotation.x-=event.relative.y*mouse_sensitivity
		camera.rotation.x= clampf(camera.rotation.x,-PI/2,PI/2)
