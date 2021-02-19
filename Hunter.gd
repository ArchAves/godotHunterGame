extends KinematicBody2D
signal searchTimeExpired

var speed = 50
var path : = PoolVector2Array()


func _on_Timer_timeout():
	emit_signal("searchTimeExpired")
	
func _physics_process(delta):
	var distanceTowalk = speed * delta
	
	while distanceTowalk > 0 and path.size() > 0:
		var distancetoNextpoint = position.distance_to(path[0])
		if distanceTowalk <= distancetoNextpoint:
			position += position.direction_to(path[0]) * distanceTowalk
		else:
			position = path[0]
			path.remove(0)
		distanceTowalk -= distancetoNextpoint
		


var prev_pos = global_position
var velocity = Vector2()

func _process(delta):
	velocity = global_position - prev_pos
	prev_pos = global_position
	print(velocity)
