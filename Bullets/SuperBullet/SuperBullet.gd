extends KinematicBody2D

onready var velocity := Vector2()
onready var speed := 10
onready var direction := 1
onready var damage := 3
onready var hitMarker := get_parent().get_node("Player/HitMarker")

func set_direction(dir):
	direction = dir;
	velocity.x  = speed * direction

func _physics_process(_delta):
	var collide = move_and_collide(velocity)
	if(collide):
		if("Enemy" in collide.collider.name):
			collide.collider.rec_dmg(damage)
			hitMarker.hitMark()
			
		queue_free()
