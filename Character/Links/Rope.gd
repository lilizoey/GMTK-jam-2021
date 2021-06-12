extends Node2D


const segment := preload("res://Character/Links/RopeSegment.tscn")
export var link_count := 4

export var connection_one: NodePath
export var connection_two: NodePath
export var start: Vector2 = Vector2.ZERO
export var end := Vector2(0, 72)

onready var one: RigidBody2D = get_node(connection_one)
onready var two: RigidBody2D = get_node(connection_two)

var segments := []

func rope_length() -> float:
	return (end - start).length()

func rope_direction() -> Vector2:
	return (end - start).normalized()

func segment_length() -> float:
	return rope_length() / link_count

func _ready():
	
	for i in link_count:
		var segment_instance := segment.instance()
		add_child(segment_instance)
		segment_instance.position = start + rope_direction() * ((i * segment_length()) + segment_length() / 2)
		segment_instance.set_length(segment_length())
		segment_instance.rotation = Vector2.UP.angle_to(rope_direction())
		segments.append(segment_instance)
	
	for i in link_count - 1:
		var joint := PinJoint2D.new()
		add_child(joint)
		joint.position = start + rope_direction() * ((i * segment_length()) + segment_length())
		joint.node_a = segments[i].get_path()
		joint.node_b = segments[i + 1].get_path()
		joint.bias = 0.9

	connect_to_end(one, start, segments[0])
	connect_to_end(two, end, segments[segments.size() - 1])
	
	one.maintain_distance = rope_length() - 2
	two.maintain_distance = rope_length() - 2


func connect_to_end(body: RigidBody2D, target_pos: Vector2, segment: RigidBody2D):
	var joint := PinJoint2D.new()
	add_child(joint)
	joint.position = target_pos 
	body.global_position = joint.global_position
	joint.node_a = segment.get_path()
	joint.node_b = body.get_path()
	joint.bias = 0.9
	
