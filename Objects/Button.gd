class_name FloorButton
extends Area2D

enum Types {
	toggled,
	held,
	once
}
export(Types) var type = Types.held

var on := false

signal turned_on(body)
signal turned_off(body)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		match type:
			Types.toggled:
				if on:
					emit_signal("turned_off", body)
				else:
					emit_signal("turned_on", body)
				on = not on
			Types.held:
				emit_signal("turned_on", body)
				on = true
			Types.once:
				emit_signal("turned_on", body)
				on = true


func _on_body_exited(body):
	if body.is_in_group("Player"):
		match type:
			Types.toggled:
				pass
			Types.held:
				emit_signal("turned_off", body)
				on = false
			Types.once:
				pass
