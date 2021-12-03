tool
extends Resource

class_name FRef1Flipped

var _f

func _init(f) -> void:
	_f = f

func call_func(x, y): return _f.call_func(y, x)
