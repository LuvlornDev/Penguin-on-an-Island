extends CharacterBody2D

@export var SPEED: float = 300.0
@export var HP: float = 5
@export var DAMAGE: float = 10
@export var attack_cooldown: float = 0.5
@export var attack_duration: float = 0.2

var score: int = 10000  # empieza en 10000
var attack_timer: float = 0.0
var attack_active: bool = false

# Referencias basadas en tu estructura de nodos
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player_collision: CollisionShape2D = $CollisionShape2D
@onready var player_area: Area2D = $Area2D

func _ready():
	print("=== PLAYER SETUP ===")
	print("Sprite found:", sprite != null)
	print("Player Area2D found:", player_area != null)
	
	if player_area:
		if not player_area.body_entered.is_connected(_on_player_area_body_entered):
			player_area.body_entered.connect(_on_player_area_body_entered)
		if not player_area.area_entered.is_connected(_on_player_area_area_entered):
			player_area.area_entered.connect(_on_player_area_area_entered)
		print("✅ Player area signals connected")

func _physics_process(delta: float) -> void:
	# Movimiento
	var direction_x := Input.get_axis("left", "right")
	var direction_y := Input.get_axis("up", "down")
	
	# Voltear sprite según dirección
	if sprite:
		if direction_x < 0:
			sprite.flip_h = true
		elif direction_x > 0:
			sprite.flip_h = false
	
	# Aplicar movimiento
	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if direction_y:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	move_and_slide()
	
	# Sistema de ataque
	if attack_timer > 0:
		attack_timer -= delta
	
	var z_pressed = Input.is_action_just_pressed("z") if InputMap.has_action("z") else Input.is_key_pressed(KEY_Z)
	
	if sprite and not attack_active:
		if sprite.animation != "default" or not sprite.is_playing():
			sprite.play("default")
	
	# Reducir score con el tiempo
	score -= int(100 * delta)  # por ejemplo, baja 100 puntos por segundo
	if score < 0:
		score = 0
	print("📉 Score:", score)
	
	# Revisar vida
	if HP <= 0:
		die()

func _on_player_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("bad"):
		HP -= 1
		print("💔 Player HP:", HP)
		if HP <= 0:
			die()

func _on_player_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("bad"):
		HP -= 1
		print("💔 Player hit by projectile! HP:", HP)
		area.queue_free()
		if HP <= 0:
			die()

func add_score(amount: int) -> void:
	score += amount
	print("📈 Score:", score)

func die() -> void:
	print("💀 Player has died!")
	queue_free()  # elimina al jugador de la escena
