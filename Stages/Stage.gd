extends Node2D

export var wait_for_both := false

onready var stage_finished_ui := $UI/StageFinished

func _ready():
	for child in get_children():
		if child.has_signal("die"):
			child.connect("die", self, "_on_character_die")
		
	Global.paused = false

func exit_reached():
	Global.finished_current()
	stage_finished_ui.visible = true
	Global.paused = true

func next_level():
	Global.play_next()
	
func exit_stage():
	get_tree().change_scene_to(Global.stage_select_scene)

func _on_FinishZone_both_player_reached():
	exit_reached()

func _on_FinishZone_player_reached():
	if not wait_for_both:
		exit_reached()

func _on_character_die(character):
	print("aaa")
	if character.is_in_group("Player"):
		exit_stage()

func pause():
	Global.paused = not Global.paused
	if Global.paused:
		$UI/Pause.visible = true
		MusicPlayer.play_song(preload("res://Misc/theme2_elevator_thing_le_fun_est_present.ogg"))
	else:
		$UI/Pause.visible = false
		MusicPlayer.play_song(Global.get_current_stage_state().song)


func _unhandled_input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("pause"):
			pause()
