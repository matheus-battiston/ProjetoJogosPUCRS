extends KinematicBody2D

var velocity = Vector2()
var direction = -1
onready var sprite := $AnimatedSprite
export (int) var dano = 1
export (int) var hp := 7.0
export (float) var timerTiro = 2.5
onready var hpBar := $HUD
onready var player := get_parent().get_node("Player")
onready var bullet :=  preload("res://Bullets/EnemyBullet/EnemyBullet.tscn")
var death_animation_length = 0
var death_animation_timer = 0
var invertido = -1
var ladoCorreto = 1
var velocidade = 50
var separacao = 20
export (int) var danoColisao = 1

func mudar_direcao():
	return is_on_wall()
	
func get_dano():
	return dano
	
func rec_dmg(val):
	$AnimationPlayer.play("Hit")
	hp = hp - val
	if (hp < 1):
		self.queue_free()
	hpBar.updateBar(hp)
	
func _ready():
	
	$Timer.start(2.0)
	death_animation_length = 1
	hpBar.setMaxValue(hp)
	hpBar.updateBar(hp)
	if direction == 1:
		$AnimatedSprite.scale.x = invertido
	else:
		$AnimatedSprite.scale.x = ladoCorreto
		

func attack():
	if $Timer.time_left<0.5 and get_node("VisibilityNotifier2D").is_on_screen():
		$Timer.start(timerTiro)
		var vec_to_player = (player.position - position).normalized()
		var bulletNode := bullet.instance()
		bulletNode.dano = dano
		if (vec_to_player.x < 0):
			bulletNode.position.x = global_position.x - separacao
		else:
			bulletNode.position.x = global_position.x + separacao

		bulletNode.position.y = global_position.y
		bulletNode.set_vec(vec_to_player, vec_to_player.angle())
		owner.add_child(bulletNode)
		$Tiro.shotAudio()
	

func _physics_process(delta):
		attack()
		if mudar_direcao():
			direction = direction * invertido
			scale.x = scale.x * invertido
		sprite.play("default")
		velocity.x = velocidade * direction

		move_and_slide(velocity, Vector2.UP)
