extends CharacterBody2D 

const Bullet = preload("res://enemy/orbs.tscn") 

@export var bullet_speed: float = 400
@export var shoot_interval: float = 1.0
@export var shoot_range: float = 500.0 

@export var HEALTH = 100

@onready var player: Node2D = null
var shoot_timer: float = 0.0

func _ready() -> void:
	player = get_tree().current_scene.find_child("Player", true, false)
	if not player:
		push_warning("Player not found!")

func _process(delta: float) -> void:
	if not player:
		return
	
	shoot_timer -= delta
	if shoot_timer <= 0.0:

		if global_position.distance_to(player.global_position) <= shoot_range:
			shoot()
			shoot_timer = shoot_interval

func shoot() -> void:
	if not player:
		return
	
	var new_bullet = Bullet.instantiate()
	
	var dir_vec = (player.global_position - global_position).normalized()
	new_bullet.velocity = dir_vec * bullet_speed
	
	new_bullet.global_position = global_position + dir_vec * 20

	get_tree().current_scene.add_child(new_bullet)
	
	print("Enemy shot a bullet at", player.global_position)
