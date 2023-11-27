extends AudioStreamPlayer2D

export (float) var tempoAudio = 0.38

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func shotAudio():
	self.play()
	yield(get_tree().create_timer(tempoAudio), "timeout")
	self.stop()
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
