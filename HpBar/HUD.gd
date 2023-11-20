extends Control

export (int) var hp = 10

func _ready():
	$ProgressBar.value = hp

func updateBar(hp):
	$ProgressBar.value = hp
	
func setMaxValue(value):
	$ProgressBar.max_value = value
