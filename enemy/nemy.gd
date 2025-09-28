extends CharacterBody2D

@export var SPEED: float = 50.0
@export var HEALTH: float = 100.0
@export var ppsize: float = 400.0   # chase radius

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	var player = get_node("../Player")   # adjust path if needed
	if not player:
		return

	var distance = (player.position - position).length()

	if distance < ppsize:
		var direction = (player.position - position).normalized()
		velocity = direction * SPEED

		if sprite.animation != "run":
			sprite.play("run")

		# Flip depending on player side (inverted logic)
		if player.position.x > position.x:
			sprite.flip_h = true   # player to the right → face right
		else:
			sprite.flip_h = false  # player to the left → face left
	else:
		velocity = Vector2.ZERO
		if sprite.animation != "idle":
			sprite.play("idle")

	move_and_slide()
	
	
