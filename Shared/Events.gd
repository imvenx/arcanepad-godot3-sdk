class_name Events

class AttackEvent extends AEvents.ArcaneBaseEvent:
	func _init().("Attack"):
		pass

class TakeDamageEvent extends AEvents.ArcaneBaseEvent:
	
	var damage: int
	
	func _init(_damage: int).("TakeDamage"):
		damage = _damage
