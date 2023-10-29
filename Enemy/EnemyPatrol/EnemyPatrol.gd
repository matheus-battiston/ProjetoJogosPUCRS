extends KinematicBody2D

var velocity = Vector2()
var direction = 1
var death = 0
onready var sprite := $AnimatedSprite
export (int) var dano = 30
onready var hp := 7
onready var hpBar := $HUD
var death_animation_length = 0
var death_animation_timer = 0


func get_dano():
	#sprite.play("attack")
	return dano
	
func rec_dmg(val):
	$AnimationPlayer.play("Hit")
	hp = 0

	hpBar.updateBar(hp)
	
func _ready():
	death_animation_length = 1
	hpBar.setMaxValue(hp)
	if direction == 1:
		$AnimatedSprite.scale.x = 1.9
	else:
		$AnimatedSprite.scale.x = -1.9
		

func _physics_process(delta):
	if death == 0:
		if is_on_wall() or (not $RayCast2D.is_colliding() and is_on_floor()):
			direction = direction * -1
			scale.x = scale.x * -1
		velocity.y += 1
		sprite.play("walk")
		velocity.x = 50 * direction
		if(hp < 1):
			death = 1
			velocity.x = 0
			sprite.play("death")
			death_animation_timer = 0

		move_and_slide(velocity, Vector2.UP)

	if death == 1:
		death_animation_timer += delta
		if death_animation_timer >= death_animation_length:
			self.queue_free()
