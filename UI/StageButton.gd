extends Button

export var stage_name: String = ""

func init(_stage_name: String):
	stage_name = _stage_name
	$Label.text = str(Global.main_stages.find(stage_name) + 1)
	var stage_state = Global.stages.get(stage_name)
	
	match stage_state.state:
		Global.State.locked:
			disabled = true
		Global.State.unlocked:
			modulate = Color(1.0, 1.0, 1.0)
		Global.State.completed:
			modulate = Color(0.75, 1.0, 0.75)
		Global.State.hidden:
			queue_free()

func _on_pressed():
	Global.play_stage_name(stage_name)
