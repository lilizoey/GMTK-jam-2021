extends Node2D

export var move_force := 16.0
var body_to_move: RigidBody2D
var initialized := false

func _ready():
	pass

func init(_body_to_move: RigidBody2D):
	body_to_move = _body_to_move
	initialized = true

func _physics_process(delta):
	if not initialized:
		return
	
	var move_dir := Vector2.ZERO
	
	if Input.is_action_pressed("move_down"):
		move_dir += Vector2.DOWN
	if Input.is_action_pressed("move_up"):
		move_dir += Vector2.UP
	if Input.is_action_pressed("move_left"):
		move_dir += Vector2.LEFT
	if Input.is_action_pressed("move_right"):
		move_dir += Vector2.RIGHT
	
	body_to_move.add_central_force(move_dir * move_force)
