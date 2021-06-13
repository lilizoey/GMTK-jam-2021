extends Node2D

signal die(character)

enum LinkageType {
	rod,
	rope,
	spring
}

export(LinkageType) var linkage_type = LinkageType.rod

onready var player_1 := $PlayerOne
onready var player_2 := $PlayerTwo
onready var camera2d := get_node_or_null("Camera2D")

onready var players_on_ground := {player_1: true, player_2: true}

onready var initial_pos: Vector2 = player_1.global_position
var initialized := false

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child.has_signal("fell_off"):
			child.connect("fell_off", self, "_on_player_fell_off")
		if child.has_signal("enter_ground"):
			child.connect("enter_ground", self, "_on_player_enter_ground")

func _physics_process(delta):
	if camera2d:
		camera2d.global_position = Vector2(
			(player_1.global_position.x + player_2.global_position.x) / 2,
			(player_1.global_position.y + player_2.global_position.y) / 2
		)
	
	if not initialized and (player_1.global_position - initial_pos).length() > 1.0:
		initialized = true
	

func _on_player_fell_off(player):
	players_on_ground[player] = false
	check_dead()

func _on_player_enter_ground(player):
	players_on_ground[player] = true

func check_dead():
	print("hh and ", initialized)
	if not initialized:
		return
	
	var off_ground := 0
	
	for player in players_on_ground.values():
		if not player:
			off_ground += 1
	
	if off_ground >= 2:
		die()
	elif off_ground == 1 and linkage_type != LinkageType.rod:
		die()

func die():
	emit_signal("die", self)
	for player in players_on_ground.keys():
		if not players_on_ground[player]:
			player.die()
	
	for child in get_children():
		if not child.is_in_group("Player"):
			child.visible = false
