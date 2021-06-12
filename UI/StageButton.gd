extends Button

export var stage_name: String = ""

func _on_pressed():
	Global.play_stage_name(stage_name)
