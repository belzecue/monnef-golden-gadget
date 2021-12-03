extends Node2D

func G(arr) -> GGArray: return GG.arr(arr)
var dd: GGDebugDraw2D

func _ready():
	yield(get_tree(), "idle_frame")
	dd = GG.debug_draw_2d
	draw_debug_shapes()

func draw_debug_shapes() -> void:
	print("draw_debug_shapes")
	var s:= Vector2(50, 30)
	var colors_count:= 7
	var colors:= G(range(colors_count)).map("x, ctx => Color.from_hsv(ctx[1], float(x) / ctx[0], float(x) / ctx[0], 1)", [colors_count, randf()]).val
	for i in range(colors_count):
		var c = colors[i]
		var y = i * 100
		var w1 = (i + 1) * 2
		dd.point(s + Vector2(0, y), c, (i + 2) * 3)
		dd.line(s + Vector2(70, y), s + Vector2(70 + 80, y + 20), c, w1)
		dd.rect(Rect2(s + Vector2(200, y), Vector2(50, 30)), c)
		dd.rect_wire(Rect2(s + Vector2(300, y), Vector2(50, 30)), c, w1)
		dd.string("^_^", Vector2(450, y + 50), c)
		dd.ellipse(s + Vector2(500, y + 15), Vector2(30, 15), c)
		dd.ellipse_wire(s + Vector2(600, y + 15), Vector2(30, 15), c, w1)
		dd.arrow(s + Vector2(660, y), s + Vector2(660 + 80, y + 20), c, w1, 10 + i * 5)

func _on_Button1_pressed() -> void:
	print("_on_Button1_pressed")
	GG.debug_draw_2d.point(Vector2(1170, 130), Color.goldenrod, 20) # draw cicle (large point)

func _on_Button2_pressed() -> void:
	print("_on_Button2_pressed")
	var count = 20
	var width_total:= 0.0
	for i in range(count):
		var start_pos = Vector2(1150 + sin(i) * 10, 250 + i * 10 + width_total)
		var end_pos = start_pos + Vector2(50, 0)
		var width = 0.5 + i * (7.0 / count)
		width_total += width
		var color = Color(0, 0.3 + i / (count * 2.0), 0)
		var time = 0.2 + i * 0.2
		GG.debug_draw_2d.line(start_pos, end_pos, color, width, time)
