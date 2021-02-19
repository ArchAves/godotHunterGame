extends KinematicBody2D

var speed = 170  # speed in pixels/sec
var velocity = Vector2.ZERO
var direction = "Down"
var playerState = "Idle"
var playerStance = "Stand"
var combo = playerStance + playerState + direction
var colliding = GlobalVars.colliding
var lastKnownLoc = preload("res://lastKnownLoc.tscn")
signal areaCollide


func get_input():
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		direction = "Right"
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		direction = "Left"
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
		direction = "Down"
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		direction = "Up"
	if Input.is_action_just_pressed("ui_crouch"):
		playerStance = "Crouch"
		speed = 95
	if Input.is_action_just_pressed("ui_stand"):
		playerStance = "Stand"
		speed = 145
	if Input.is_action_pressed("ui_sprint") and playerStance != "Crouch":
		playerState = "Sprint"
		speed = 240
	if Input.is_action_just_released("ui_sprint") and playerStance != "Crouch":
		playerState = "Walk"
		speed = 170
	if velocity == Vector2(0,0):
		playerState = "Idle"
	if velocity != Vector2(0,0) and playerState != "Sprint":
		playerState = "Walk"
	combo = playerStance + playerState + direction
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	get_input()
	if playerState == "Idle":
		$Area2D/CollisionShape2D.shape.radius = 0
	if playerStance == "Crouch" and playerState == "Walk":
		$Area2D/CollisionShape2D.shape.radius = 70
	if playerStance == "Stand" and playerState == "Walk":
		$Area2D/CollisionShape2D.shape.radius = 120
	if playerStance == "Stand" and playerState == "Sprint":
		$Area2D/CollisionShape2D.shape.radius = 150
	$PlayerSprite.play(combo)
	move_and_slide(velocity)




func _on_Area2D_body_entered(body):
	emit_signal("areaCollide")


