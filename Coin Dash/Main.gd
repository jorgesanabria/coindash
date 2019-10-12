extends Node2D

export (PackedScene) var Coin
export (int) var playtime
export (PackedScene) var Powerup;

var level: int
var score: int
var time_left: int
var screensize: Vector2
var playing: bool = false

func _ready():
	randomize()
	self.screensize = self.get_viewport().get_visible_rect().size
	$Player.screensize = self.screensize
	$Player.hide()
	pass

func new_game():
	self.playing = true
	self.level = 1
	self.score = 0
	self.time_left = self.playtime
	$Player.start($PlayerStart.position)
	$Player.show()
	$GameTimer.start()
	self.spawn_coins()
	$HUD.update_score(self.score)
	$HUD.update_timer(self.time_left)
	pass

func spawn_coins():
	for i in range(4 + level):
		var c = self.Coin.instance()
		$CoinContainer.add_child(c)
		c.screensize = self.screensize
		c.position = Vector2(rand_range(0, self.screensize.x), rand_range(0, self.screensize.y))
	$LevelSound.play()
	pass
	
func _process(delta):
	if self.playing and $CoinContainer.get_child_count() == 0:
		self.level += 1
		self.time_left += 5
		self.spawn_coins()
		$PowerupTimer.wait_time = rand_range(5, 10)
		$PowerupTimer.start()
	pass

func _on_GameTimer_timeout():
	self.time_left -= 1
	$HUD.update_timer(self.time_left)
	if self.time_left <= 0:
		self.game_over()
	pass

func _on_Player_hurt():
	self.game_over()
	pass

func _on_Player_pickup(type):
	match type:
		"coin":
			self.score += 1
			$HUD.update_score(self.score)
			$CoinSound.play()
		"powerup":
			self.time_left += 5
			$PowerupSound.play()
			$HUD.update_timer(self.time_left)
	pass

func game_over():
	self.playing = false
	$GameTimer.stop()
	for coin in $CoinContainer.get_children():
		coin.queue_free()
	$HUD.show_game_over()
	$Player.die()
	$EndSound.play()
	pass

func _on_PowerupTimer_timeout():
	var p = Powerup.instance()
	self.add_child(p)
	p.screensize = self.screensize
	p.position = Vector2(rand_range(0, self.screensize.x), rand_range(0, self.screensize.y))	
	pass
