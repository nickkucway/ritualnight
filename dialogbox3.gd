extends Area

var active = false

func _ready():
	connect("body_entered", self, '_on_NPC_body_entered')
	connect("body_exited", self, '_on_NPC_body_exited')
	
func _on_NPC_body_entered(body):
	if body.name == 'Player':
		active = true
		$talk.visible = true
		
func _input(event):
	if get_node_or_null('DialogNode') ==null:
		if event.is_action_pressed("interact") and active:
			get_tree().paused = true
			var dialog = Dialogic.start('convo3')
			dialog.pause_mode = Node.PAUSE_MODE_PROCESS
			dialog.connect('timeline_end', self, 'unpause')
			add_child(dialog)
			
func unpause(timelime_name):
	get_tree().paused = false
		
func _on_NPC_body_exited(body):
	if body.name == 'Player':
		active = false
		$talk.visible = false
