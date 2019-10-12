extends CanvasLayer

signal start_game

func update_score(value: int):
	$MarginContainer/ScoreLabel.text = str(value)
	pass

func update_timer(value: int):
	$MarginContainer/TimeLabel.text = str(value)
	pass

func show_message(text: String):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()
	pass

func _on_MessageTimer_timeout():
	$MessageLabel.hide()
	pass

func _on_StartButton_pressed():
	$StartButton.hide()
	$MessageLabel.hide()
	self.emit_signal("start_game")
	pass

func show_game_over():
	self.show_message("Game over")
	yield($MessageTimer, "timeout")
	$StartButton.show()
	$MessageLabel.text = "Coin Dash"
	$MessageLabel.show()
	pass