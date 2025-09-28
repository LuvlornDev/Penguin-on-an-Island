extends Node2D

# --- Nodes ---
@onready var fade_rect: ColorRect = $CanvasLayer/FadeRect
@onready var start_text: Label = $CanvasLayer/StartText
@onready var copyright: Label = $CanvasLayer/Label
@onready var button_container: VBoxContainer = $CanvasLayer/ButtonContainer
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var game_logo: TextureRect = $CanvasLayer/GameLogo

# Buttons
@onready var play_button: TextureButton = $CanvasLayer/ButtonContainer/PlayButton
@onready var credits_button: TextureButton = $CanvasLayer/ButtonContainer/CreditsButton
@onready var quit_button: TextureButton = $CanvasLayer/ButtonContainer/QuitButton

# --- Variables ---
var buttons_visible: bool = false

# --- Preload button textures ---
var play_normal = preload("res://play.jpg")
var play_pressed = preload("res://playcl.jpg")
var credits_normal = preload("res://cred.jpg")
var credits_pressed = preload("res://credcl.jpg")
var quit_normal = preload("res://Captura de pantalla 2025-09-28 005037.png")
var quit_pressed = preload("res://quitcl.jpg")

func _ready():
	print("MainMenu _ready() called")  # Debug

	# Start invisible
	start_text.modulate.a = 0.0
	game_logo.modulate.a = 0.0
	copyright.modulate.a = 0.0

	# Fade in scene
	if fade_rect:
		fade_rect.color.a = 1.0
		var tween = create_tween()
		tween.tween_property(fade_rect, "color:a", 0.0, 1.0)

	# Fade in GameLogo and StartText
	var tween2 = create_tween()
	tween2.tween_property(game_logo, "modulate:a", 1.0, 1.0)
	tween2.tween_property(start_text, "modulate:a", 1.0, 1.0)
	tween2.tween_property(copyright, "modulate:a", 1.0, 1.0)

	# Hide buttons initially
	button_container.visible = false
	button_container.modulate.a = 1.0

	# Setup buttons
	setup_button(play_button, play_normal, play_pressed, on_play_pressed)
	setup_button(credits_button, credits_normal, credits_pressed, on_credits_pressed)
	setup_button(quit_button, quit_normal, quit_pressed, on_quit_pressed)

	set_process_input(true)

# --- Input to show menu ---
func _input(event):
	if not buttons_visible and event.is_pressed():
		if event is InputEventKey or event is InputEventMouseButton or event is InputEventJoypadButton:
			print("Input detected, showing buttons")
			buttons_visible = true
			fade_out_start_text()

# --- Fade out StartText then fade in buttons ---
func fade_out_start_text():
	print("Fading out start text")
	var tween = create_tween()
	tween.tween_property(start_text, "modulate:a", 0.0, 0.5)
	await tween.finished
	start_text.visible = false
	show_buttons()

func show_buttons():
	print("Showing buttons")
	button_container.visible = true
	button_container.modulate.a = 0.0
	button_container.mouse_filter = Control.MOUSE_FILTER_PASS

	var tween = create_tween()
	tween.tween_property(button_container, "modulate:a", 1.0, 0.5)
	await tween.finished

# --- Setup a TextureButton ---
func setup_button(button: TextureButton, normal_tex: Texture2D, pressed_tex: Texture2D, callback_func: Callable):
	if button == null:
		print("Warning: Button is null!")
		return

	button.texture_normal = normal_tex
	button.texture_pressed = pressed_tex
	button.texture_hover = normal_tex
	button.texture_disabled = normal_tex

	button.mouse_filter = Control.MOUSE_FILTER_PASS
	button.disabled = false

	button_container.mouse_filter = Control.MOUSE_FILTER_PASS

	# Connect pressed signal
	if not button.pressed.is_connected(callback_func):
		button.pressed.connect(callback_func)

# --- Button callbacks ---
func on_play_pressed():
	print("Play button pressed!")
	await _fade_out_buttons()
	fade_out_and_change_scene("res://LoadingScreen.tscn")

func on_credits_pressed():
	print("Credits button pressed!")
	await _fade_out_buttons()
	fade_out_and_change_scene("res://credits.tscn")

func on_quit_pressed():
	print("Quit button pressed!")
	await _fade_out_buttons()
	fade_out_and_quit()

# --- Fade out buttons helper ---
func _fade_out_buttons() -> void:
	if anim and anim.has_animation("fade_out_buttons"):
		anim.play("fade_out_buttons")
		await anim.animation_finished
	button_container.visible = false

# --- Fade helpers ---
func fade_out_and_change_scene(scene_path: String) -> void:
	print("Fading out to change scene: " + scene_path)
	if fade_rect:
		fade_rect.visible = true
		var tween = create_tween()
		tween.tween_property(fade_rect, "color:a", 1.0, 0.5)
		await tween.finished
	get_tree().change_scene_to_file(scene_path)

func fade_out_and_quit() -> void:
	print("Fading out to quit")
	if fade_rect:
		fade_rect.visible = true
		var tween = create_tween()
		tween.tween_property(fade_rect, "color:a", 1.0, 0.5)
		await tween.finished
	get_tree().quit()
