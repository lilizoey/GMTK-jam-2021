extends Node

const stage_select_scene := preload("res://UI/StageSelect.tscn")
const stage_select_music := preload("res://Misc/theme1_better.ogg")

var current_stage = null
var finished_current = false
var paused = false

enum State {
	locked,
	unlocked,
	completed,
	hidden
}

class StageState:
	var scene: PackedScene
	var state: int
	var name: String
	var song: AudioStream
	
	func _init(
		_scene: PackedScene, 
		_name: String,  
		_song: AudioStream, 
		init_state: int = State.locked
	):
		scene = _scene
		state = init_state
		name = _name
		song = _song

var main_stages := [
	"stage_1",
	"stage_2",
	"stage_3",
	"stage_4",
	"stage_5",
	"stage_6",
	"stage_7",
	"stage_8",
	"stage_9",
]

var stages := {
	main_stages[0] : StageState.new(preload("res://Stages/Stage1.tscn"), main_stages[0], preload("res://Misc/theme3.ogg"), State.unlocked),
	main_stages[1] : StageState.new(preload("res://Stages/Stage2.tscn"), main_stages[1], preload("res://Misc/theme3.ogg")),
	main_stages[2] : StageState.new(preload("res://Stages/Stage3.tscn"), main_stages[2], preload("res://Misc/theme3.ogg")),
	main_stages[3] : StageState.new(preload("res://Stages/Stage4.tscn"), main_stages[3], preload("res://Misc/theme3.ogg")),
	main_stages[4] : StageState.new(preload("res://Stages/Stage5.tscn"), main_stages[4], preload("res://Misc/theme3.ogg")),
	main_stages[5] : StageState.new(preload("res://Stages/Stage6.tscn"), main_stages[5], preload("res://Misc/theme3.ogg")),
	main_stages[6] : StageState.new(preload("res://Stages/Stage7.tscn"), main_stages[6], preload("res://Misc/theme3.ogg")),
	main_stages[7] : StageState.new(preload("res://Stages/Stage8.tscn"), main_stages[7], preload("res://Misc/theme3.ogg")),
	main_stages[8] : StageState.new(preload("res://Stages/Stage9.tscn"), main_stages[8], preload("res://Misc/theme3.ogg")),
}

func _ready():
	pass

func play_next():
	var next := get_next_available_stage()
	if next:
		play_stage(next)
	else:
		get_tree().change_scene_to(stage_select_scene)

func get_next_available_stage() -> StageState:
	var index := main_stages.find(current_stage)
	if index < 0 or index >= main_stages.size() - 1:
		return null
	else:
		return stages[main_stages[index + 1]]

func play_stage_name(stage_name: String) -> bool:
	var stage_state: StageState = stages.get(stage_name)
	return play_stage(stage_state)

func play_stage(stage_state: StageState) -> bool:
	if not stage_state or stage_state.state == State.locked:
		return false
	
	current_stage = stage_state.name
	
	get_tree().change_scene_to(stage_state.scene)
	MusicPlayer.play_song(stage_state.song)
	
	return true

func finished_current():
	stages[current_stage].state = State.completed
	var next_stage := get_next_available_stage()
	if next_stage and next_stage.state == State.locked:
		next_stage.state = State.unlocked

func get_current_stage_state() -> StageState:
	return stages[current_stage]
