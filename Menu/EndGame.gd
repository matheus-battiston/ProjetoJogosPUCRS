extends Node

onready var selected = 1

var ComecarSelecionado = "[color=#FF0000]Recomeçar[/color]"
var SairSelecionado = "[color=#FF0000]Sair[/color]"
var InstrucSelecionado = "[color=#FF0000]NewGame+[/color]"

var ComecarNaoSelecionado = "[color=#FFFFFF]Recomeçar[/color]"
var SairNaoSelecionado = "[color=#FFFFFF]Sair[/color]"
var InstrucNaoSelecionado = "[color=#FFFFFF]NewGame+[/color]"
onready var player_vars = get_node("/root/GameData")

func _ready() -> void:
	_atualizar_texto()

func _process(delta: float) -> void:
	
	var up = Input.is_action_just_pressed('jump')
	var down = Input.is_action_just_pressed('down')
	var enter = Input.is_action_just_pressed("ui_accept")
	
	if up:
		selected = selected - 1
		if selected < 1:
			selected = 3
		_atualizar_texto()
	elif down:
		selected = selected + 1
		if selected > 3:
			selected = 1
		_atualizar_texto()
	elif enter:
		if selected == 1:
			get_tree().change_scene("res://Levels/Level1.tscn")
		elif selected == 2:
			player_vars.startNewGamePlus()
			get_tree().change_scene("res://Levels/Level1.tscn")
		elif selected == 3:
			get_tree().quit()

func _atualizar_texto() -> void:
	$CanvasLayer/Comec.bbcode_text = ComecarNaoSelecionado
	$CanvasLayer/Instru.bbcode_text = InstrucNaoSelecionado
	$CanvasLayer/Sair.bbcode_text = SairNaoSelecionado
	match selected:
		1:
			$CanvasLayer/Comec.bbcode_text = ComecarSelecionado
		2:
			$CanvasLayer/Instru.bbcode_text = InstrucSelecionado
		3:
			$CanvasLayer/Sair.bbcode_text = SairSelecionado
