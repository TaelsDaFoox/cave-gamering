extends Control
@onready var shirt = $SubViewport/shirt
var player
@onready var shirtText = $ShirtText
func _physics_process(delta: float) -> void:
	shirt.rotation.y+=delta*0.5
func _ready() -> void:
	player=get_parent().get_node("Player")
	updateShirtText()

func _on_right_pressed() -> void:
	Global.shirtnum=fposmod(Global.shirtnum+1,256)
	updateShirtText()
	if player:
		player.setShirt(Global.shirtnum)
func _on_left_pressed() -> void:
	Global.shirtnum= fposmod(Global.shirtnum-1,256)
	updateShirtText()
	if player:
		player.setShirt(Global.shirtnum)

func updateShirtText():
	shirtText.text="Shirt\n"+str(Global.shirtnum)
