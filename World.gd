extends Node2D
var LKL = preload("res://lastKnownLoc.tscn")
var instanceLKL = LKL.instance()
var playerVisible = false
onready var ray = get_node("Hunter/RayCast2D")



func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_SPACE:
			hunterRaySearch()

func _process(delta):
		hunterRaySearch()


func _on_Player_areaCollide():
	var bodies = $Player/Area2D.get_overlapping_bodies()
	for item in bodies:
		if item.is_in_group("hunter"):
			LKLinstancing()
			moveToPos()
			
func LKLinstancing():
		instanceLKL.position = $Player.position
		add_child(instanceLKL)

func hunterRaySearch():
	ray.cast_to = $Player.global_position - $Hunter.global_position
	ray.force_raycast_update()
	if ray.is_colliding():
		var collidedWith = ray.get_collider()
		if collidedWith.is_in_group('player'):
			#print('sees player')
			LKLinstancing()
			moveToPos()
		else:
			#print('sees non-player')
			pass


func _on_Hunter_searchTimeExpired():
	print("timer expired")
	
func moveToPos():
	var path = $Navigation2D.get_simple_path($Hunter.position, instanceLKL.position)
	$Line2D.points = path
	$Hunter.path = path
