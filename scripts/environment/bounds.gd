extends StaticBody2D


const GRID := 8
@export var r := Rect2i(-3, -2, 10, 4):
	get: return Rect2(r.position * GRID, r.size * GRID)


func _ready() -> void:
	add_bound(Vector2.DOWN, r.position.y)
	add_bound(Vector2.UP, -r.end.y)
	add_bound(Vector2.RIGHT, r.position.x)
	add_bound(Vector2.LEFT, -r.end.x)


func add_bound(normal: Vector2, distance: float) -> void:
	var col := CollisionShape2D.new()
	col.shape = WorldBoundaryShape2D.new()
	col.shape.normal = normal
	col.shape.distance = distance
	add_child(col)


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	var vp := get_viewport()
	var v := get_global_transform().affine_inverse() * (vp.get_canvas_transform().affine_inverse() * vp.get_visible_rect())
	v = v.merge(r)

	draw_rect(Rect2(v.position.x, v.position.y, v.size.x, r.position.y - v.position.y), Color.BLACK)
	draw_rect(Rect2(v.position.x, r.end.y, v.size.x, v.end.y - r.end.y), Color.BLACK)
	draw_rect(Rect2(v.position.x, r.position.y, r.position.x - v.position.x, r.size.y), Color.BLACK)
	draw_rect(Rect2(r.end.x, r.position.y, v.end.x - r.end.x, r.size.y), Color.BLACK)
