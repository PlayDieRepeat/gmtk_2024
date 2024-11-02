extends Node
## AudioBankRobber is an autoload class used for holding all the different SoundBanks needed for audio playback.

var has_loaded:= false

func _process(_p_delta) -> void:
	if has_loaded:
		return

	has_loaded = true
