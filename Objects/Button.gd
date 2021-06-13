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

func _ready():
	if on:
		button_down(null)
	else:
		button_up(null)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		match type:
			Types.toggled:
				if on:
					button_up(body)
				else:
					button_down(body)
			Types.held:
				button_down(body)
			Types.once:
				button_down(body)


func _on_body_exited(body):
	if body.is_in_group("Player"):
		match type:
			Types.toggled:
				pass
			Types.held:
				button_up(body)
			Types.once:
				pass

func button_up(body):
	on = false
	emit_signal("turned_off", body)
	
	match type:
		Types.held:
			$Sprite.frame = 0
		Types.toggled:
			$Sprite.frame = 4
		Types.once:
			$Sprite.frame = 2

func button_down(body):
	on = true
	emit_signal("turned_on", body)
	
	match type:
		Types.held:
			$Sprite.frame = 1
		Types.toggled:
			$Sprite.frame = 5
		Types.once:
			$Sprite.frame = 3

