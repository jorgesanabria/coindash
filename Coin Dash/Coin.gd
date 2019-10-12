extends Area2D

var screensize: Vector2 = Vector2()

func pickup():
	self.monitoring = false
	$Tween.start()
	pass

func _ready():
	$Tween.interpolate_property($AnimatedSprite, 'scale',
								$AnimatedSprite.scale,
								$AnimatedSprite.scale * 3,
								0.3,
								Tween.TRANS_QUAD,
								Tween.EASE_IN_OUT)
	$Tween.interpolate_property($AnimatedSprite, 'modulate',
								Color(1, 1, 1, 1),
								Color(1, 1, 1, 0),
								0.3,
								Tween.TRANS_QUAD,
								Tween.EASE_IN_OUT)
	$Timer.wait_time = rand_range(3, 8)
	$Timer.start()
	pass


func _on_Tween_tween_all_completed():
	queue_free()
	pass


func _on_Timer_timeout():
	$AnimatedSprite.frame = 0
	$AnimatedSprite.play()
	pass


func _on_Coin_area_entered(area):
	if area.is_in_group("obstacles"):
		self.position = Vector2(rand_range(0, self.screensize.x), rand_range(0, self.screensize.y))
	pass
