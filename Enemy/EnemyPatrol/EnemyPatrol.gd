extends KinematicBody2D

var velocity = Vector2()
var direction = 1
var death = 0
onready var sprite := $AnimatedSprite
export (int) var dano = 30
onready var hp := 3.0
onready var hpBar := $HUD
export (int) var danoColisao = 5
var death_animation_length = 1
var death_animation_timer = 0
var inverter = -1
var escala = 1
var velocidade = 50
var hpMin = 1


func mudar_direcao():
	return is_on_wall() or (not $RayCast2D.is_colliding() and is_on_floor())

func get_dano():
	#sprite.play("attack")
	return dano
	
func rec_dmg(val):
	$AnimationPlayer.play("Hit")
	hp = hp - val
	hpBar.updateBar(hp)
	
func _ready():
	hpBar.setMaxValue(hp)
	if direction == 1:
		$AnimatedSprite.scale.x = escala
	else:
		$AnimatedSprite.scale.x = -escala
		

func _physics_process(delta):
	if death == 0:
		if mudar_direcao():
			direction = direction * inverter
			scale.x = scale.x * inverter
		velocity.y += 1
		sprite.play("walk")
		velocity.x = velocidade * direction
		if(hp < hpMin):
			death = 1
			velocity.x = 0
			sprite.play("death")
			death_animation_timer = 0

		move_and_slide(velocity, Vector2.UP)

	if death == 1:
		death_animation_timer += delta
		if death_animation_timer >= death_animation_length:
			self.queue_free()
