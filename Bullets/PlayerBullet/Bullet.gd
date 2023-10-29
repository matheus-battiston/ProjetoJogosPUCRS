extends KinematicBody2D

onready var velocity := Vector2()
onready var speed := 5
onready var direction := 1
onready var damage := 1

func set_direction(dir):
	direction = dir;
	velocity.x  = speed * direction

func _physics_process(_delta):
	var collide = move_and_collide(velocity)
	if(collide):
		if("Enemy" in collide.collider.name):
			print(collide.collider.name)
			collide.collider.rec_dmg(1)
 
		queue_free()
