extends Node2D

var total : float = 0
const SPEED : int = 100

func _ready() -> void:	
	update_score(total)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("right"):
		print("Right!")
	
func _process(delta) -> void:
	#print(delta)
	total += delta
	update_score(total)
	
func _physics_process(delta) -> void:
	if Input.is_action_pressed("right"):
		position.x += SPEED * delta

func update_score(current_score: float) -> void:
	$Score.text = str(current_score)
	
