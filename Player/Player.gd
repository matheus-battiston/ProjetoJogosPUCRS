extends KinematicBody2D

export (int) var speed = 100
export (int) var runSpeed = 240
export (float) var rotation_speed = 2.5
export (int) var gravity = 2500
export (int) var jump_speed = -1000 
export (PackedScene) var box : PackedScene
export (int) var xgun = 25
export (int) var ygun = -28
export (float) var timer = 0.3
export (int) var hp = 15

onready var hpBar := $HUD
onready var target := position
onready var sprite := $Sprite
onready var sound := $PlayerSound
onready var bullet := preload("res://Bullets/PlayerBullet/Bullet.tscn")
onready var super_bullet := preload("res://Bullets/SuperBullet/SuperBullet.tscn")
onready var anti_turret_bullet := preload("res://Bullets/AntiTurretBullet/AntiTurretBullet.tscn")
onready var hitMarker := $HitMarker

var weapon_selected = 1
onready var player_vars = get_node("/root/GameData")

var dir = 1
var danoColisao = 1
var knockBack = 2000
var super_bullet_unlocked = false
var velocity = Vector2.ZERO
var rotation_dir = 0

func _ready():
	super_bullet_unlocked = player_vars.item_unlocked
	$HUD.setMaxValue(hp)
	$HUD.updateBar(hp)

func _input(event):
	if event.is_action_pressed("click"):
		target = get_global_mouse_position()
		
func libera_super_bullet():
	super_bullet_unlocked = true
	player_vars.unlock()
func rec_dmg(val):
	$AnimationPlayer.play("Hit")
	val = val * player_vars.multiplier
	hp = hp - val
	if(hp < 1):
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://GameOver.tscn")
	hpBar.updateBar(hp)

func recupera_vida():
	hp = 15
	hpBar.updateBar(hp)

func get_rotation_input():
	rotation_dir = 0
	velocity = Vector2()
	if Input.is_action_pressed("right"):
		sprite.play("right")
		rotation_dir = 1
	if Input.is_action_pressed("left"):
		sprite.play("left")
# warning-ignore:standalone_expression
		rotation_dir - 1
	
func get_mouse_input():
	look_at(get_global_mouse_position())
	velocity = Vector2()
	if Input.is_action_pressed("down"):
		velocity = Vector2(-speed, 0).rotated(rotation)
	if Input.is_action_pressed("up"):
		velocity = Vector2(speed, 0).rotated(rotation)

func get_side_input():
	velocity.x = 0
	var right = Input.is_action_pressed('right')
	var left = Input.is_action_pressed('left')
	var jump = Input.is_action_just_pressed('jump')
	var shoot = Input.get_action_strength("shoot")
	var runRight = Input.get_action_strength("correr")
	var runLeft = Input.get_action_strength("correrEsquerda")
	var superBullet = Input.is_action_just_pressed("SuperBullet")
	var normalBullet = Input.is_action_just_pressed("Bullet1")
	var antiTurretBullet = Input.is_action_just_pressed("AntiTurretBullet")
			
	if jump and is_on_floor():		
		velocity.y = jump_speed
	elif superBullet && super_bullet_unlocked:
		weapon_selected = 5
	elif antiTurretBullet:
		weapon_selected = 2
	elif normalBullet:
		weapon_selected = 1
	elif runRight:
		velocity.x += runSpeed
		sprite.play("run")
		sprite.scale.x = 1
		dir = 1
	elif runLeft:
		velocity.x -= runSpeed
		sprite.play("run")
		sprite.scale.x = -1
		dir = -1
	elif right:
		velocity.x += speed
		sprite.play("right")
		sprite.scale.x = 1
		dir = 1
	elif left:
		velocity.x -= speed
		sprite.play("left")	
		sprite.scale.x = -1
		dir = -1
	elif shoot:
		var bulletNode
		if $Timer.time_left==0:
			sprite.play("shoot")
			$Timer.start(timer)
			if weapon_selected == 1:
				bulletNode = bullet.instance()
			elif weapon_selected == 2:
				bulletNode = anti_turret_bullet.instance()
			else :
				bulletNode = super_bullet.instance()
			if (dir == 1):
				bulletNode.position.x = global_position.x + (xgun*dir)
			else:
				bulletNode.position.x = global_position.x - 43
			bulletNode.position.y = global_position.y - ygun
			owner.add_child(bulletNode)
			bulletNode.set_direction(dir)
			$Tiro.shotAudio()
	else:
		sprite.play("idle")

		sprite.stop()
		
		
func _physics_process(delta):
	var collided = $Player.get_overlapping_areas()
	
	get_side_input()
	velocity.y += gravity * delta
	
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if (position.y > 600):
		get_tree().change_scene("res://GameOver.tscn")
		
	
	if(collided.size() > 0):
		if(collided[0].get_name() == "Medkit"):
			recupera_vida()
		elif(collided[0].get_name() == "UnlockSuperBullet"):
			libera_super_bullet()
		elif(collided[0].get_name() == "Helicoptero"):
			if player_vars.level == 2:
				player_vars.resetLevels()
				get_tree().change_scene("res://Menu/EndGame.tscn")
			else:
				player_vars.avancLevel()
				get_tree().change_scene("res://Levels/Level2.tscn")
		else:
			rec_dmg(collided[0].get_owner().danoColisao)
			if(collided[0].get_owner().position.x>position.x):
				velocity.x = -knockBack
				velocity.y = -500
			else:
				velocity.x = knockBack
				velocity.y = -500
			velocity = move_and_slide(velocity, Vector2.UP)

