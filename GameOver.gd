extends Control

onready var player_vars = get_node("/root/GameData")

func _process(delta: float) -> void:
	
	var enter = Input.is_action_just_pressed("ui_accept")
	
	if enter:
		player_vars.resetLevels()
		get_tree().change_scene("res://Menu/Menu.tscn")
