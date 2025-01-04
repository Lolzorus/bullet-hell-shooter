extends Node


func play_sound(stream: AudioStream):
	# Create an AudioStreamPlayer to play the sound and avoid being cut by instance cleaning
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.stream = stream
	player.volume_db = -10
	player.play()
  
