# YOUR CUSTOM EVENTS
class_name Events


class AttackEvent extends AEvents.ArcaneBaseEvent:
	func _init().(EventName.Attack):
		pass


class TakeDamageEvent extends AEvents.ArcaneBaseEvent:
	
	var damage: int
	
	func _init(_damage: int).(EventName.TakeDamage):
		damage = _damage
