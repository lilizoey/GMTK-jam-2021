extends Area2D

signal left_floor
signal enter_ground

var is_on_floor := true

func _ready():
	pass # Replace with function body.


func _process(delta):
	var overlapping := false
	for i in get_overlapping_areas():
		overlapping = true
	for i in get_overlapping_bodies():
		overlapping = true
	if not overlapping and is_on_floor:
		emit_signal("left_floor")
		is_on_floor = false
	if overlapping and not is_on_floor:
		emit_signal("enter_ground")
		is_on_floor = true
