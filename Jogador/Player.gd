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
export (int) var hp = 10


onready var hpBar := get_tree().get_root().get_node("Game/Level1/Player/HUD")
onready var target := position
onready var sprite := $Sprite
onready var sound := $PlayerSound
onready var bullet := preload("res://Bullets/PlayerBullet/Bullet.tscn")
var dir = 1
var danoColisao = 1
var knockBack = 2000

var velocity = Vector2.ZERO
var rotation_dir = 0

func _input(event):
	if event.is_action_pressed("click"):
		target = get_global_mouse_position()
		
		
func rec_dmg(val):
	$AnimationPlayer.play("Hit")
	hp = hp - val
	if(hp < 1):
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://GameOver.tscn")
	hpBar.updateBar(hp)

func recupera_vida():
	hp = 10
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
		
	if jump and is_on_floor():		
		velocity.y = jump_speed
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
		if $Timer.time_left==0:
			sprite.play("shoot")
			$Timer.start(timer)
			var bulletNode := bullet.instance()
			if (dir == 1):
				bulletNode.position.x = global_position.x + (xgun*dir)
			else:
				bulletNode.position.x = global_position.x - 43
			bulletNode.position.y = global_position.y - ygun
			owner.add_child(bulletNode)
			bulletNode.set_direction(dir)
	else:
		sprite.play("idle")

		sprite.stop()
		
		
func _physics_process(delta):
	var collided = $Player.get_overlapping_areas()
	
	get_side_input()
	velocity.y += gravity * delta
	
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if(collided.size() > 0):
		if(collided[0].get_name() == "Medkit"):
			recupera_vida()
		elif(collided[0].get_name() == "Helicoptero"):
			get_tree().change_scene("res://Levels/Level2.tscn")
		else:
			rec_dmg(danoColisao)
			if(collided[0].get_owner().position.x>position.x):
				velocity.x = -knockBack
				velocity.y = -500
			else:
				velocity.x = knockBack
				velocity.y = -500
			velocity = move_and_slide(velocity, Vector2.UP)

