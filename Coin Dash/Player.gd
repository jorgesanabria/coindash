extends Area2D
signal pickup
signal hurt


export (int) var speed
var velocity:Vector2 = Vector2()
var screensize:Vector2 = Vector2(480, 720)

func start(pos: Vector2):
	self.set_process(true)
	self.position = pos
	$AnimatedSprite.animation = "idle"
	pass

func die():
	$AnimatedSprite.animation = "hurt"
	self.set_process(false)
	pass

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * self.speed
	pass

func _process(delta):
	self.get_input()
	self.position += velocity * delta
	self.position.x = clamp(self.position.x, 0, self.screensize.x)
	self.position.y = clamp(self.position.y, 0, self.screensize.y)
	
	if self.velocity.length() > 0:
		$AnimatedSprite.animation = "run"
		$AnimatedSprite.flip_h = self.velocity.x < 0
	else:
		$AnimatedSprite.animation = "idle"
	pass

func _on_Player_area_entered(area):
	if area.is_in_group("coins"):
		area.pickup()
		self.emit_signal("pickup", "coin")
	if area.is_in_group("obstacles"):
		self.emit_signal("hurt")
		self.die()
	if area.is_in_group("powerups"):
		area.pickup()
		emit_signal("pickup", "powerup")
	pass
