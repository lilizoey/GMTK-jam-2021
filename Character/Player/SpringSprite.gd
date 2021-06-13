extends Sprite


export var player_1_path: NodePath
onready var player_1: RigidBody2D = get_node(player_1_path)
export var player_2_path: NodePath
onready var player_2: RigidBody2D = get_node(player_2_path)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	var player_len := (player_1.position - player_2.position).length()
	scale.x = player_len / 72.0
	position.x = (player_1.position.x + player_2.position.x) / 2.0
	position.y = (player_1.position.y + player_2.position.y) / 2.0
	rotation = Vector2.RIGHT.angle_to(player_2.position - player_1.position)
