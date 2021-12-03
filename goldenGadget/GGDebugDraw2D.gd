extends CanvasItem

class_name GGDebugDraw2D

var enabled:= !OS.has_feature("standalone")
var update_redraw_time:= 0.2 # second between forced redraws of all shapes
var default_draw_time:= 2.0 # default time for how long alive will shapes be
var default_point_size:= 1.2
var default_line_width:= 0.8
var default_ellpise_width:= 0.8
var default_color:= Color(1, 0, 1, 0.5)
var default_font = null # if null default font is obtained from Control via get_font("font")

var _shapes:= []
var _redraw_cd:= 0.0
var _default_font: Font

func point(pos: Vector2, color:= default_color, size:= default_point_size, time:= default_draw_time) -> void:
	_shapes.push_back({
		type = "point",
		pos = pos,
		color = color,
		size = size,
		time = time
	})

func line(pos_from: Vector2, pos_to: Vector2, color:= default_color, width:= default_line_width, time:= default_draw_time) -> void:
	_shapes.push_back({
		type = "line",
		pos_from = pos_from,
		pos_to = pos_to,
		color = color,
		width = width,
		time = time
	})

func rect(rect: Rect2, color:= default_color, time:= default_draw_time) -> void:
	_shapes.push_back({
		type = "rect",
		rect = rect,
		color = color,
		width = 1,
		time = time,
		filled = true,
	})

func rect_wire(rect: Rect2, color:= default_color, width:= default_line_width, time:= default_draw_time) -> void:
	_shapes.push_back({
		type = "rect",
		rect = rect,
		color = color,
		width = width,
		time = time,
		filled = false,
	})

func string(text: String, pos: Vector2, color:= default_color, font = default_font, time:= default_draw_time) -> void:
	_shapes.push_back({
		type = "string",
		pos = pos,
		text = text,
		color = color,
		font = font,
		time = time,
	})

func ellipse(pos: Vector2, size: Vector2, color:= default_color, time:= default_draw_time) -> void:
	_shapes.push_back({
		type = "ellipse",
		pos = pos,
		size = size,
		color = color,
		width = 1,
		filled = true,
		time = time
	})

func ellipse_wire(pos: Vector2, size: Vector2, color:= default_color, width:= default_ellpise_width, time:= default_draw_time) -> void:
	_shapes.push_back({
		type = "ellipse",
		pos = pos,
		size = size,
		color = color,
		width = width,
		filled = false,
		time = time
	})

func arrow(pos_from: Vector2, pos_to: Vector2, color:= default_color, width:= default_line_width, arrow_size:= 10.0, time:= default_draw_time) -> void:
	_shapes.push_back({
		type = "arrow",
		pos_from = pos_from,
		pos_to = pos_to,
		color = color,
		width = width,
		arrow_size = arrow_size,
		time = time
	})

func _ready() -> void:
	_default_font = Control.new().get_font("font")

func _draw() -> void:
	if !enabled: return
	for s in _shapes:
		match s.type:
			"point": draw_circle(s.pos, s.size, s.color)
			"line": draw_line(s.pos_from, s.pos_to, s.color, s.width)
			"rect": draw_rect(s.rect, s.color, s.filled, s.width)
			"string": draw_string(_default_font if s.font == null else s.font, s.pos, s.text, s.color)
			"ellipse": GG.draw_ellipse_(self, s.pos, s.size, s.color, s.width, s.filled)
			"arrow": GG.draw_arrow_(self, s.pos_from, s.pos_to, s.color, s.width, s.arrow_size)

func _process(delta: float) -> void:
	if !enabled: return
	for s in _shapes.duplicate():
		s.time -= delta
		if s.time < 0: _shapes.erase(s)
	_redraw_cd -= delta
	if _redraw_cd <= 0:
		_redraw_cd = update_redraw_time
		update()
