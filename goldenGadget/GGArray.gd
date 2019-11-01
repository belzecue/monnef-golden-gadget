extends Resource

class_name GGArray

var GGI = GGInternal.new()

var val setget , _get_val
var size setget , _get_size

var _val: Array

const _EMPTY_CONTEXT = "This is a workaround GDScript's limitations:" +\
  " instances of user classes cannot be assigned to const (nor anything like 'Symbol' from JS exists)"

func _init(array: Array = []) -> void:
	_val = array

# get value
func _get_val() -> Array: return _val

func _w(x: Array) -> GGArray:
	# get_script is workaround GDScript's limitations (class cannot reference itself o_0)
	return get_script().new(x)

func _is_empty_ctx(x) -> bool: return x is String and x == _EMPTY_CONTEXT

func _call_f0_w_ctx(f, ctx = _EMPTY_CONTEXT): return f.call_func() if _is_empty_ctx(ctx) else f.call_func(ctx)
func _call_f1_w_ctx(f, x, ctx = _EMPTY_CONTEXT): return f.call_func(x) if _is_empty_ctx(ctx) else f.call_func(x, ctx)
func _call_f2_w_ctx(f, x, y, ctx = _EMPTY_CONTEXT):
	return f.call_func(x, y) if _is_empty_ctx(ctx) else f.call_func(x, y, ctx)

func _f_or_lamb(f) -> FuncRef: return GGI.function_(f) if f is String else f

# ----------------------------------------------------------------------------------------------------------------------

# map every value in array using function reference (FuncRef or CtxFRef1)
func map_fn(f, ctx = _EMPTY_CONTEXT) -> GGArray:
	var r:= []
	for x in _val: r.push_back(_call_f1_w_ctx(f, x, ctx))
	return _w(r)

# similar to map_fn, but also supports lambda string expressions (same as `map_fn(F(f), ctx)`)
func map(f, ctx = _EMPTY_CONTEXT) -> GGArray: return map_fn(_f_or_lamb(f), ctx)

# map outer method (method of one specific object, usualy one from which call originates - self)
func map_out_mtd(obj: Object, method_name: String, ctx = _EMPTY_CONTEXT) -> GGArray:
	return map_fn(funcref(obj, method_name), ctx)

# map inner method (method on objects in value)
func map_in_mtd(inner_method_name: String, ctx = _EMPTY_CONTEXT) -> GGArray:
	var r:= []
	for x in _val: r.push_back(_call_f0_w_ctx(funcref(x, inner_method_name), ctx))
	return _w(r)

# ----------------------------------------------------------------------------------------------------------------------

# map field
func map_fld(field_name: String) -> GGArray:
	var r:= []
	for x in _val:
		if x && field_name in x: r.push_back(x[field_name])
	return _w(r)

# ----------------------------------------------------------------------------------------------------------------------

# join string array
func join(delim: String = "", before: String = "", after: String = "") -> String:
	return before + PoolStringArray(_val).join(delim) + after

# ----------------------------------------------------------------------------------------------------------------------

# get value size (array length)
func _get_size() -> int: return _val.size()

# ----------------------------------------------------------------------------------------------------------------------

# filter out values from array for which predicate function returns false
func filter_fn(predicate, ctx = _EMPTY_CONTEXT) -> GGArray:
	var r:= []
	for x in _val: if _call_f1_w_ctx(predicate, x, ctx): r.push_back(x)
	return _w(r)

# similar to filter_fn, but also supports lambda string expressions (same as `filter_fn(F(f), ctx)`)
func filter(predicate, ctx = _EMPTY_CONTEXT) -> GGArray: return filter_fn(_f_or_lamb(predicate), ctx)

func filter_out_mtd(obj: Object, method_name: String, ctx = _EMPTY_CONTEXT) -> GGArray:
	return filter_fn(funcref(obj, method_name), ctx)

func filter_in_mtd(inner_method_name: String, ctx = _EMPTY_CONTEXT) -> GGArray:
	var r:= []
	for x in _val:
		if _call_f0_w_ctx(funcref(x, inner_method_name), ctx): r.push_back(x)
	return _w(r)

# ----------------------------------------------------------------------------------------------------------------------

func filter_by_fld(field_name: String) -> GGArray:
	var r:= []
	for x in _val:
		if field_name in x && x[field_name]: r.push_back(x)
	return _w(r)

# ----------------------------------------------------------------------------------------------------------------------

func filter_by_fld_val(field_name: String, field_value) -> GGArray:
	var r:= []
	for x in _val:
		if field_name in x && x[field_name] == field_value: r.push_back(x)
	return _w(r)

# ----------------------------------------------------------------------------------------------------------------------

func find_by_fld_val(field_name: String, field_value):
	return (filter_by_fld_val(field_name, field_value)).head()

# ----------------------------------------------------------------------------------------------------------------------

# takes an operator and a zero value, reduces array to one value by repeatedly applying the operator to items from array
# f is of type func f<Result>(accumulator: Result, item: T) -> Result
func foldl_fn(f: FuncRef, zero, ctx = _EMPTY_CONTEXT):
	var r = zero
	for x in _val: r = _call_f2_w_ctx(f, r, x, ctx)
	return r

# similar to foldl_fn, but also supports lambda string expressions (same as `foldl_fn(F(f), zero, ctx)`)
func foldl(f, zero, ctx = _EMPTY_CONTEXT): return foldl_fn(_f_or_lamb(f), zero, ctx)

func foldl_mtd(obj: Object, method_name: String, zero, ctx = _EMPTY_CONTEXT):
	return foldl_fn(funcref(obj, method_name), zero, ctx)

# ----------------------------------------------------------------------------------------------------------------------

# lambda string support?

func pipe(f: FuncRef): return f.call_func(_val)
func to(f: FuncRef): return pipe(f)

func pipe_w(f: FuncRef) -> GGArray: return _w(pipe(f))
func to_w(f: FuncRef): return pipe_w(f)

# ----------------------------------------------------------------------------------------------------------------------

func head(): return GGI.head_(_val)

func last(): return GGI.last_(_val)

func tail() -> GGArray:
	GGI.assert_(_get_size() > 0, "cannot call tail on empty array")
	return _w(GGI.tail_(_val))

func init() -> GGArray:
	GGI.assert_(_get_size() > 0, "cannot call init on empty array")
	return _w(GGI.init_(_val))

# ----------------------------------------------------------------------------------------------------------------------

func sort() -> GGArray: return _w(GGI.sort_(_val))

# lambda string support?

func sort_by(cmp_f: FuncRef) -> GGArray: return _w(GGI.sort_by_(_val, cmp_f))

func sort_by_fld(field_name: String) -> GGArray: return _w(GGI.sort_by_fld_(_val, field_name))

func sort_with(map_f: FuncRef) -> GGArray: return _w(GGI.sort_with_(_val, map_f))

# ----------------------------------------------------------------------------------------------------------------------

func zip(other: Array) -> GGArray: return _w(GGI.zip_(_val, other))

# ----------------------------------------------------------------------------------------------------------------------

# to suppress "The function 'map_out_mtd()' returns a value, but this value is never used." and similar
func noop() -> void: pass

# TODO:
# all, any
# take, drop, take_right, drop_right
# zip, without
# append, prepend, concat, intersperse
# ? reject/filter_not
