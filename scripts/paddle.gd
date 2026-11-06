extends AnimatableBody2D
class_name Paddle

const WIDTH := 126.0
const HEIGHT := 18.0
const MOVE_SPEED := 850.0
const LEFT_LIMIT := 54.0 + WIDTH / 2.0
const RIGHT_LIMIT := 906.0 - WIDTH / 2.0

var target_x := 480.0
var flash_time := 0.0


func _ready() -> void:
	var shape := RectangleShape2D.new()
	shape.size = Vector2(WIDTH, HEIGHT)
	var collision := CollisionShape2D.new()
	collision.shape = shape
	add_child(collision)
	sync_to_physics = true


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		target_x = clampf(event.position.x, LEFT_LIMIT, RIGHT_LIMIT)
	elif event is InputEventScreenTouch or event is InputEventScreenDrag:
		target_x = clampf(event.position.x, LEFT_LIMIT, RIGHT_LIMIT)


func _physics_process(delta: float) -> void:
	var direction := 0.0
	if Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_A):
		direction -= 1.0
	if Input.is_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_D):
		direction += 1.0
	if direction != 0.0:
		target_x = clampf(position.x + direction * MOVE_SPEED * delta, LEFT_LIMIT, RIGHT_LIMIT)
	position.x = move_toward(position.x, target_x, MOVE_SPEED * delta)
	if flash_time > 0.0:
		flash_time = maxf(0.0, flash_time - delta)
		queue_redraw()


func flash() -> void:
	flash_time = 0.16
	queue_redraw()


func _draw() -> void:
	var body_color := Color("fff5c0") if flash_time > 0.0 else Color("ff9b71")
	draw_rect(Rect2(-WIDTH / 2.0 - 3.0, -HEIGHT / 2.0 - 3.0, WIDTH + 6.0, HEIGHT + 6.0), Color(1.0, 0.53, 0.38, 0.16))
	draw_rect(Rect2(-WIDTH / 2.0, -HEIGHT / 2.0, WIDTH, HEIGHT), body_color)
	draw_rect(Rect2(-WIDTH / 2.0 + 5.0, -HEIGHT / 2.0 + 3.0, WIDTH - 10.0, 3.0), Color(1, 1, 1, 0.45))
