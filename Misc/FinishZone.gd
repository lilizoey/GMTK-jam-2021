extends Area2D

signal player_reached
signal both_player_reached

var players_in := {}

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body):
	if body.is_in_group("Player"):
		players_in[body.name] = body
		emit_signal("player_reached")
		if players_in.size() == 2:
			emit_signal("both_player_reached")

func _on_body_exited(body):
	if body.is_in_group("Player"):
		players_in[body.name] = null
