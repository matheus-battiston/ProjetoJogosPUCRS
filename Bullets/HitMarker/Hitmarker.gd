extends AudioStreamPlayer2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func hitMark():
	self.play()
	yield(get_tree().create_timer(0.07), "timeout")
	self.stop()
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
