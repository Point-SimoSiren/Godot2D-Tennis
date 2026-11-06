extends CharacterBody2D
class_name Ball

signal paddle_hit
signal missed

const RADIUS := 12.0
const INITIAL_SPEED := 365.0
const MAX_SPEED := 650.0

var paddle: Paddle
var active := false
var speed := INITIAL_SPEED


func _ready() -> void:
	var shape := CircleShape2D.new()
	shape.radius = RADIUS
	var collision := CollisionShape2D.new()
	collision.shape = shape
	add_child(collision)


func launch() -> void:
	position = Vector2(randf_range(280.0, 680.0), 142.0)
	speed = INITIAL_SPEED
	velocity = Vector2(randf_range(-0.38, 0.38), 1.0).normalized() * speed
	active = true
	visible = true


func _physics_process(delta: float) -> void:
	if not active:
		return

	var motion := velocity * delta
	for bounce_index in range(4):
		var collision := move_and_collide(motion)
		if collision == null:
			break

		if collision.get_collider() == paddle and velocity.y > 0.0:
			var offset := clampf((position.x - paddle.position.x) / (Paddle.WIDTH / 2.0), -1.0, 1.0)
			speed = minf(speed + 18.0, MAX_SPEED)
			velocity = Vector2(offset * 0.9, -1.0).normalized() * speed
			paddle_hit.emit()
		else:
			# Heijastus pinnan normaalin suhteen säilyttää tulokulman.
			velocity = velocity.bounce(collision.get_normal())

		motion = velocity.normalized() * collision.get_remainder().length()

	if position.y > 660.0:
		active = false
		visible = false
		missed.emit()


func _draw() -> void:
	draw_circle(Vector2.ZERO, RADIUS + 7.0, Color(1.0, 0.85, 0.37, 0.11))
	draw_circle(Vector2.ZERO, RADIUS + 3.0, Color(1.0, 0.85, 0.37, 0.22))
	draw_circle(Vector2.ZERO, RADIUS, Color("ffd36e"))
	draw_circle(Vector2(-3.5, -4.0), 3.5, Color(1, 1, 1, 0.72))
