extends Area2D

signal collected

var taken := false


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if taken or not body is Ball or not body.active:
		return
	taken = true
	collected.emit()
	queue_free()


func _draw() -> void:
	draw_circle(Vector2.ZERO, 25.0, Color(1.0, 0.71, 0.23, 0.12))
	draw_circle(Vector2.ZERO, 19.0, Color("ffe194"))
	draw_circle(Vector2.ZERO, 16.0, Color("eaa52d"))
	draw_circle(Vector2.ZERO, 12.0, Color("ffd36e"))
	draw_line(Vector2(-5, -5), Vector2(5, -5), Color("b6701f"), 2.5)
	draw_line(Vector2(-5, 0), Vector2(5, 0), Color("b6701f"), 2.5)
	draw_line(Vector2(-5, 5), Vector2(5, 5), Color("b6701f"), 2.5)
	draw_circle(Vector2(-7, -9), 2.0, Color(1, 1, 1, 0.7))
