extends KinematicBody

var hotkeys = {
	KEY_1: 0,
	KEY_2: 1,
	KEY_3: 2,
	KEY_4: 3,
	KEY_5: 4,
	KEY_6: 5,
	KEY_7: 6,
	KEY_8: 7,
	KEY_9: 8,
	KEY_0: 9,
}

export var mouse_sens = 0.5


onready var camera = $Camera
onready var character_mover = $CharacterMover
onready var health_manager = $HealthManager
onready var weapon_manager = $Camera/WeaponManager
onready var pickup_manager = $PickupManager
onready var lowchar_portrait = $CanvasLayer/lowhealth/Sprite/AnimationPlayer
onready var medchar_portrait = $CanvasLayer/medhealth/Sprite/AnimationPlayer
onready var fullchar_portrait = $CanvasLayer/fullhealth/Sprite/AnimationPlayer
var dead = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	character_mover.init(self)
	pickup_manager.max_player_health = health_manager.max_health
	health_manager.connect("health_changed", pickup_manager, "update_player_health")
	pickup_manager.connect("got_pickup", weapon_manager, "get_pickup")
	pickup_manager.connect("got_pickup", health_manager, "get_pickup")
	health_manager.init()
	health_manager.connect("dead", self, "kill")
	weapon_manager.init($Camera/FirePoint, [self])

func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().change_scene("res://menuscreen.tscn")
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	
	if dead:
		lowchar_portrait.play("dead")
		medchar_portrait.play("dead")
		fullchar_portrait.play("dead")
		return
		
	var move_vec = Vector3()
	if Input.is_action_pressed("move_forwards"):
		move_vec += Vector3.FORWARD
	if Input.is_action_pressed("move_backwards"):
		move_vec += Vector3.BACK
	if Input.is_action_pressed("move_left"):
		move_vec += Vector3.LEFT
	if Input.is_action_pressed("move_right"):
		move_vec += Vector3.RIGHT
	character_mover.set_move_vec(move_vec)
	if Input.is_action_just_pressed("jump"):
		character_mover.jump()
		
	weapon_manager.attack(Input.is_action_just_pressed("attack"), Input.is_action_pressed("attack"))

		
func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= mouse_sens * event.relative.x
		camera.rotation_degrees.x -= mouse_sens * event.relative.y
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)
	if event is InputEventKey and event.pressed:
		if event.scancode in hotkeys:
			weapon_manager.switch_to_weapon_slot(hotkeys[event.scancode])
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_WHEEL_DOWN:
			weapon_manager.switch_to_next_weapon()
		if event.button_index == BUTTON_WHEEL_UP:
			weapon_manager.switch_to_last_weapon()
		
func hurt(damage, dir):
	health_manager.hurt(damage, dir)
	lowchar_portrait.play("hurt")
	medchar_portrait.play("hurt")
	fullchar_portrait.play("hurt")
	print('hit')

func heal(amount):
	health_manager.heal(amount)

func kill():
	dead = true
	character_mover.freeze()



func _on_AnimationPlayer_animation_finished(hurt):
	lowchar_portrait.play("idle")
	medchar_portrait.play("idle")
	fullchar_portrait.play("idle")
	
