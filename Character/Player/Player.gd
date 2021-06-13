extends RigidBody2D

signal fell_off(player)
signal enter_ground(player)

export var max_speed := 128.0
export var time_to_desired := 0.2
export var max_force := 512.0
export var other_path: NodePath
onready var other: RigidBody2D = get_node(other_path)
onready var animated_sprite := $AnimatedSprite

var maintain_distance := 900

func _ready():
	$OnFloor.connect("left_floor", self, "_on_left_floor")
	$OnFloor.connect("enter_ground", self, "_on_enter_ground")

func _integrate_forces(state: Physics2DDirectBodyState):
	if Global.paused:
		state.set_linear_velocity(Vector2.ZERO)
		return
	
	var lv := state.get_linear_velocity()
	var delta := state.get_step()
	
	if lv.length() > 6.0:
		if lv.x > 0:
			animated_sprite.animation = "WalkRight"
		elif lv.x < 0:
			animated_sprite.animation = "WalkLeft"
	else:
		if animated_sprite.animation == "WalkRight":
			animated_sprite.animation = "IdleRight"
		elif animated_sprite.animation == "WalkLeft":
			animated_sprite.animation = "IdleLeft"
	
	var move_dir := Vector2.ZERO
	
	if Input.is_action_pressed("move_down"):
		move_dir += Vector2.DOWN
	if Input.is_action_pressed("move_up"):
		move_dir += Vector2.UP
	if Input.is_action_pressed("move_left"):
		move_dir += Vector2.LEFT
	if Input.is_action_pressed("move_right"):
		move_dir += Vector2.RIGHT
	
	var desired_lv := move_dir * max_speed
	var diff := desired_lv - lv
	if diff.length() > max_force:
		diff = diff.normalized() * max_force
	
	lv += diff * (delta / time_to_desired)
	
	var vector_to_other := other.global_position - global_position
	var distance_to_other := vector_to_other.length()

	if distance_to_other > maintain_distance:
		lv += (other.global_position - global_position).normalized() * \
			(distance_to_other - maintain_distance) * \
			(distance_to_other - maintain_distance)
	
	if lv.length() > max_speed:
		lv = lv.normalized() * max_speed
	
	
	if lv.length() < 1.0:
		lv = Vector2.ZERO
	
	

	state.set_linear_velocity(lv)
	

func _on_left_floor():
	emit_signal("fell_off", self)

func _on_enter_ground():
	emit_signal("enter_ground", self)

func die():
	animated_sprite.play("Fall")
