extends KinematicBody2D

var separacao = 43
onready var sprite := $AnimatedSprite
var velocity = Vector2()
var direction = 0
export (int) var dano = 10
onready var hp := 5.0
onready var player := get_parent().get_node("Player")
onready var bullet :=  preload("res://Bullets/EnemyBullet/EnemyBullet.tscn")
onready var hpBar := $HUD

func get_dano():
	return dano

func _ready() -> void:
	sprite.play("visible")
	hpBar.setMaxValue(hp)
	hpBar.updateBar(hp)
	$Timer.start(2.0)

func rec_dmg(val):
	$AnimationPlayer.play("Hit")
	print(hp, " ", val, " ", hp - val)
	hp = hp - val
	if(hp <= 0):
		self.queue_free()
	hpBar.updateBar(hp)
		
func attack():
	if $Timer.time_left<0.5 and get_node("VisibilityNotifier2D").is_on_screen():
		$Timer.start(1.5)
		var vec_to_player = (player.position - position).normalized()
		var bulletNode := bullet.instance()
		if (vec_to_player.x < 0):
			bulletNode.position.x = global_position.x - separacao
		else:
			bulletNode.position.x = global_position.x + separacao

		bulletNode.position.y = global_position.y
		bulletNode.set_vec(vec_to_player, vec_to_player.angle())
		owner.add_child(bulletNode)
	

func _physics_process(delta):
	attack()
	if ((player.position.x - position.x) > 0 and direction == 0):
		scale.x = scale.x*-1
		direction = 1
	elif ((player.position.x - position.x) < 0 and direction == 1):
		scale.x = scale.x*-1
		direction = 0
	
	move_and_slide(velocity, Vector2.UP)
	


func _on_VisibilityNotifier2D2_screen_entered() -> void:
	pass # Replace with function body.
