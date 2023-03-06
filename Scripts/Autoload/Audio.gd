extends Node

var num_players = 7
var audioplayers = []

func _ready():
	for i in num_players:
		var p = AudioStreamPlayer.new()
		add_child(p)
		audioplayers.append(p)
		if i==0:
			p.bus = "Music"
		else:
			p.bus = "Effects"
	#Added this to avoid hear rapes, already happened 2 times :(
	AudioServer.set_bus_volume_db(0,-20)

# s_playid -> 0 (Music), 1 (Typer), 2 (Menu), 3 (Player), 4 (Attack), 5 (PreAttack), 6 (Other)
func play(s_playid, stream, pitch = 1.0,loop = false):
	audioplayers[s_playid].stream = stream
	audioplayers[s_playid].play()
	audioplayers[s_playid].pitch_scale = pitch
	if audioplayers[s_playid] is AudioStreamOGGVorbis:
		audioplayers[s_playid].stream.loop = loop

#stop one audioplayer
func stop(s_playid):
	audioplayers[s_playid].stop()

#stop all the audioplayers
func stopall():
	for i in num_players:
		audioplayers[i].stop()
