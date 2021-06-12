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
					on = not on
					emit_signal("turned_off", body)
				else:
					on = not on
					emit_signal("turned_on", body)
			Types.held:
				on = true
				emit_signal("turned_on", body)
			Types.once:
				on = true
				emit_signal("turned_on", body)


func _on_body_exited(body):
	if body.is_in_group("Player"):
		match type:
			Types.toggled:
				pass
			Types.held:
				on = false
				emit_signal("turned_off", body)
			Types.once:
				pass
