extends KinematicBody2D

var velocity = Vector2()
var direction = -1
onready var sprite := $AnimatedSprite
export (int) var dano = 30
onready var hp := 7
onready var hpBar := $HUD
var death_animation_length = 0
var death_animation_timer = 0


func get_dano():
	return dano
	
func rec_dmg(val):
	$AnimationPlayer.play("Hit")
	hp = hp - val
	if (hp < 1):
		self.queue_free()
	hpBar.updateBar(hp)
	
func _ready():
	death_animation_length = 1
	hpBar.setMaxValue(hp)
	if direction == 1:
		$AnimatedSprite.scale.x = -1
	else:
		$AnimatedSprite.scale.x = 1
		

func _physics_process(delta):
		if is_on_wall() or (not $RayCast2D.is_colliding() and is_on_floor()):
			direction = direction * -1
			scale.x = scale.x * -1
		velocity.y += 1
		sprite.play("walk")
		velocity.x = 50 * direction
		if(hp < 1):
			velocity.x = 0

		move_and_slide(velocity, Vector2.UP)
