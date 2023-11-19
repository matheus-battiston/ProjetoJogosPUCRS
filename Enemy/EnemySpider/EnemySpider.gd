extends KinematicBody2D

var velocity = Vector2()
var direction = -1
onready var sprite := $AnimatedSprite
export (int) var dano = 30
onready var hp := 7.0
onready var hpBar := $HUD
var death_animation_length = 0
var death_animation_timer = 0
var invertido = -1
var ladoCorreto = 1
var velocidade = 50

func mudar_direcao():
	return is_on_wall() or (not $RayCast2D.is_colliding() and is_on_floor())
	

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
		$AnimatedSprite.scale.x = invertido
	else:
		$AnimatedSprite.scale.x = ladoCorreto
		

func _physics_process(delta):
		if mudar_direcao():
			direction = direction * invertido
			scale.x = scale.x * invertido
		velocity.y += 1
		sprite.play("walk")
		velocity.x = velocidade * direction

		move_and_slide(velocity, Vector2.UP)
