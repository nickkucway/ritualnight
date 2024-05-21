extends Area


var bodies_to_exclude = []
export var damage = 20

signal attack

func set_damage(_damage: int):
	damage = _damage

func set_bodies_to_exclude(_bodies_to_exclude: Array):
	bodies_to_exclude = _bodies_to_exclude

func fire():
	emit_attack_signal()
	for body in get_overlapping_bodies():
		if body.has_method("hurt") and !body in bodies_to_exclude:
			body.hurt(damage, global_transform.origin.direction_to(body.global_transform.origin))
			
func emit_attack_signal():
	emit_signal("attack")
		
