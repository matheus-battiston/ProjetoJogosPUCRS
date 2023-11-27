extends Node

onready var selected = 1

var VoltarSelecionado = "[color=#FF0000]Voltar[/color]"

func _ready() -> void:
	$CanvasLayer/Voltar.bbcode_text = VoltarSelecionado

func _process(delta: float) -> void:
	
	var enter = Input.is_action_just_pressed("ui_accept")
	
	if enter:
		get_tree().change_scene("res://Menu/Menu.tscn")
