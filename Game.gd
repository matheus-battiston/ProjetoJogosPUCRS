extends Node2D

onready var sceneLimit : Position2D
onready var player : KinematicBody2D

var currentScene = null

func _ready():
	currentScene = get_child(0)
	sceneLimit = currentScene.get_node("SceneLimit")
	player = currentScene.get_node("Player")
	
func _input(event):
	if event.is_action_pressed("filter"):
		toggle_filter()	

func _physics_process(delta):
	if sceneLimit == null:
		return
	
	if player.position.y > sceneLimit.position.y:
		get_tree().change_scene("res://GameOver.tscn")
		
	if Input.is_key_pressed(KEY_X):
		call_deferred("goto_scene", "res://GameOver.tscn")
		
func toggle_filter():
	print("Bus count: "+str(AudioServer.bus_count))
	var filter : AudioEffectLowPassFilter = AudioServer.get_bus_effect(1, 0)
	if filter.cutoff_hz == 500:
		filter.cutoff_hz = 12000
	else:
		filter.cutoff_hz = 500
	
	
func goto_scene(path: String):
	print("Total children: "+str(get_child_count()))
	var world := get_child(0)
	world.free()
	var res := ResourceLoader.load(path)
	currentScene = res.instance()
	sceneLimit = null
	get_tree().get_root().add_child(currentScene)
