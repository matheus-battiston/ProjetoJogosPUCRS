extends Control

func _process(delta: float) -> void:
	
	var enter = Input.is_action_just_pressed("ui_accept")
	
	if enter:
		get_tree().change_scene("res://Menu/Menu.tscn")
