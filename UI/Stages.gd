extends GridContainer

const stage_button_scene := preload("res://UI/StageButton.tscn")

func _ready():
	for stage in Global.main_stages:
		var new_button := stage_button_scene.instance()
		new_button.init(stage)
		add_child(new_button)
