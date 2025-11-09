extends Control
@onready var firstbtn = $GridContainer/Button
func _ready() -> void:
	firstbtn.grab_focus()
func _on_button_pressed() -> void:
	pass # Replace with function body.
