extends Control


func _ready():
	$ProgressBar.value = 10

func updateBar(hp):
	$ProgressBar.value = hp
	
func setMaxValue(value):
	$ProgressBar.max_value = value
