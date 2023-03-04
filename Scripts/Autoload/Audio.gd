extends Node

var volumeDB = 80

func getAudio(sound): if is_instance_valid(get_node(sound)): return get_node(sound)


func play(sound, pitch: float = 1.0, volmult = 1.0, loop: = false):
	var snd: = get_node(sound)
	if is_instance_valid(snd):
		if snd.stream is AudioStreamOGGVorbis:
			if (!loop and snd.stream.loop) or (loop and !snd.stream.loop):
				#print("Sound loop changed")
				snd.stream.loop = loop
		
		snd.play()
		snd.pitch_scale = pitch
		snd.volume_db = volumeDB * volmult


func stop(sound): if is_instance_valid(get_node(sound)): get_node(sound).stop()
