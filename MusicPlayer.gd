extends Area

onready var musicplayer = $Mainmusic

func _on_MusicPlayer_body_entered(body):
	musicplayer.play("Mainmusic")
