extends Button

@export var audio_stream: AudioStream


func _on_pressed() -> void:
	Audio.play(audio_stream)
