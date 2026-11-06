extends Node2D

const COIN_SCENE := preload("res://scenes/coin.tscn")
const COIN_POINTS := 10
const COIN_POSITIONS := [
	Vector2(190, 210), Vector2(480, 215), Vector2(770, 210),
	Vector2(315, 335), Vector2(645, 335), Vector2(480, 455),
]

@onready var paddle: Paddle = $Paddle
@onready var ball: Ball = $Ball

var hits := 0
var misses := 0
var points := 0
var coins_remaining := 0
var respawn_time := 0.0
var points_label: Label
var hits_label: Label
var misses_label: Label
var hint_label: Label


func _ready() -> void:
	randomize()
	add_wall("LeftWall", Vector2(33, 350), Vector2(18, 590))
	add_wall("RightWall", Vector2(927, 350), Vector2(18, 590))
	add_wall("TopWall", Vector2(480, 72), Vector2(900, 18))

	add_text("PALLOMAILA", Vector2(40, 14), 27, Color("eaf8ff"))
	points_label = add_text("", Vector2(390, 18), 20, Color("ffd36e"))
	hits_label = add_text("", Vector2(585, 18), 20, Color("ffb597"))
	misses_label = add_text("", Vector2(745, 18), 20, Color("9cd7e5"))
	hint_label = add_text("Liikuta mailaa: hiiri, kosketus tai ← → / A D", Vector2(48, 603), 17, Color("9bb8c8"))
	update_score()
	spawn_coins()

	ball.paddle = paddle
	ball.paddle_hit.connect(_on_paddle_hit)
	ball.missed.connect(_on_missed)
	ball.launch()


func _process(delta: float) -> void:
	if respawn_time <= 0.0:
		return
	respawn_time -= delta
	if respawn_time <= 0.0:
		hint_label.text = "Liikuta mailaa: hiiri, kosketus tai ← → / A D"
		if coins_remaining == 0:
			spawn_coins()
		ball.launch()


func spawn_coins() -> void:
	for coin_position in COIN_POSITIONS:
		var coin: Area2D = COIN_SCENE.instantiate()
		coin.position = coin_position
		coin.connect("collected", _on_coin_collected)
		add_child(coin)
		coins_remaining += 1


func add_wall(wall_name: String, wall_position: Vector2, wall_size: Vector2) -> void:
	var wall := StaticBody2D.new()
	wall.name = wall_name
	wall.position = wall_position
	var shape := RectangleShape2D.new()
	shape.size = wall_size
	var collision := CollisionShape2D.new()
	collision.shape = shape
	wall.add_child(collision)
	add_child(wall)


func add_text(content: String, at: Vector2, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = content
	label.position = at
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	add_child(label)
	return label


func update_score() -> void:
	points_label.text = "PISTEET  %d" % points
	hits_label.text = "OSUMAT  %d" % hits
	misses_label.text = "OHITUKSET  %d" % misses


func _on_coin_collected() -> void:
	points += COIN_POINTS
	coins_remaining -= 1
	update_score()


func _on_paddle_hit() -> void:
	hits += 1
	paddle.flash()
	update_score()


func _on_missed() -> void:
	misses += 1
	update_score()
	hint_label.text = "Ohi! Uusi pallo tulossa..."
	respawn_time = 0.75


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, Vector2(960, 640)), Color("091928"))
	draw_rect(Rect2(48, 84, 864, 510), Color("10283a"))
	for x in range(1, 10):
		draw_line(Vector2(48 + x * 86.4, 85), Vector2(48 + x * 86.4, 594), Color(0.55, 0.82, 0.90, 0.045), 1.0)
	for y in range(1, 6):
		draw_line(Vector2(48, 84 + y * 85), Vector2(912, 84 + y * 85), Color(0.55, 0.82, 0.90, 0.045), 1.0)
	draw_line(Vector2(42, 61), Vector2(918, 61), Color("357182"), 2.0)
	draw_rect(Rect2(38, 68, 7, 530), Color("69c8d1"))
	draw_rect(Rect2(915, 68, 7, 530), Color("69c8d1"))
	draw_rect(Rect2(38, 68, 884, 7), Color("69c8d1"))
	draw_line(Vector2(48, 596), Vector2(912, 596), Color("357182"), 2.0)
