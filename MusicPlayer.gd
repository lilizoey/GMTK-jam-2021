extends AudioStreamPlayer

const target_volume := -5
const min_volume := -35
const fade_speed := 20

var next_song: AudioStream

enum PlayingState {
	playing,
	stopped,
	fade_out,
	fade_in,
}

var playing_state := 0

func _ready():
	mix_target = 0
	bus = "Music"
	volume_db = target_volume

func play_song(new_song: AudioStream):
	if new_song and stream and new_song.resource_path == stream.resource_path:
		return
	next_song = new_song
	playing_state = PlayingState.fade_out

func _process(delta):
	match playing_state:
		PlayingState.playing:
			pass
		PlayingState.stopped:
			pass
		PlayingState.fade_out:
			volume_db -= delta * fade_speed
			if volume_db < min_volume:
				playing_state = PlayingState.fade_in
				stream = next_song
				playing = true
		PlayingState.fade_in:
			volume_db += delta * fade_speed
			if volume_db > target_volume:
				playing_state = PlayingState.playing
				volume_db = target_volume
