extends Node2D

@export var next_scene: String = "res://game.tscn"
@export var min_time: float = 3.5  # duration of loading screen in seconds

@onready var anim = $AnimationPlayer  # your AnimationPlayer inside CanvasLayer

func _ready() -> void:
	# Play the label animation if it exists
	if anim.has_animation("loadanim"):
		anim.play("loadanim")
	
	# Start the loading timer
	_start_loading()

func _start_loading() -> void:
	# Wait at least min_time seconds
	await get_tree().create_timer(min_time).timeout
	
	# After 3.5 seconds, change to the next scene
	get_tree().change_scene_to_file(next_scene)
