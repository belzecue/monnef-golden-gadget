extends Resource

class_name GGArray

var GGI = GGInternal.new()

var val setget , _get_val
var size setget , _get_size
var is_empty setget , _get_is_empty

var _val: Array

func _init(array: Array = []) -> void:
	_val = array

# get value
func _get_val() -> Array: return _val

func _w(x: Array) -> GGArray:
	# get_script is workaround GDScript's limitations (class cannot reference itself o_0)
	return get_script().new(x)


# ----------------------------------------------------------------------------------------------------------------------

# map every value in array using function reference (FuncRef or CtxFRef1)
func map_fn(f, ctx = GGI._EMPTY_CONTEXT) -> GGArray: return _w(GGI.map_fn_(_val, f, ctx))

# similar to map_fn, but also supports lambda string expressions (same as `map_fn(F(f), ctx)`)
func map(f, ctx = GGI._EMPTY_CONTEXT) -> GGArray: return _w(GGI.map_(_val, f, ctx))

# map outer method (method of one specific object, usualy one from which call originates - self)
func map_out_mtd(obj: Object, method_name: String, ctx = GGI._EMPTY_CONTEXT) -> GGArray:
	return map_fn(funcref(obj, method_name), ctx)

# map inner method (method on objects in value)
func map_in_mtd(inner_method_name: String, ctx = GGI._EMPTY_CONTEXT) -> GGArray:
	var r:= []
	for x in _val: r.push_back(GGI.call_f0_w_ctx(funcref(x, inner_method_name), ctx))
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

func _get_is_empty() -> bool: return size == 0

# ----------------------------------------------------------------------------------------------------------------------

# filter out values from array for which predicate function returns false
func filter_fn(predicate, ctx = GGI._EMPTY_CONTEXT) -> GGArray: return _w(GGI.filter_fn_(_val, predicate, ctx))

# similar to filter_fn, but also supports lambda string expressions (same as `filter_fn(F(f), ctx)`)
func filter(predicate, ctx = GGI._EMPTY_CONTEXT) -> GGArray: return _w(GGI.filter_(_val, predicate, ctx))

func filter_out_mtd(obj: Object, method_name: String, ctx = GGI._EMPTY_CONTEXT) -> GGArray:
	return filter_fn(funcref(obj, method_name), ctx)

func filter_in_mtd(inner_method_name: String, ctx = GGI._EMPTY_CONTEXT) -> GGArray:
	var r:= []
	for x in _val:
		if GGI.call_f0_w_ctx(funcref(x, inner_method_name), ctx): r.push_back(x)
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

func without(value_to_omit) -> GGArray: return _w(GGI.without_(_val, value_to_omit))
func compact() -> GGArray: return _w(GGI.compact_(_val))

# ----------------------------------------------------------------------------------------------------------------------

func find_by_fld_val(field_name: String, field_value):
	return (filter_by_fld_val(field_name, field_value)).head()

# ----------------------------------------------------------------------------------------------------------------------

# takes an operator and a zero value, reduces array to one value by repeatedly applying the operator to items from array
# f is of type func f<Result>(accumulator: Result, item: T) -> Result
func foldl_fn(f: FuncRef, zero, ctx = GGI._EMPTY_CONTEXT): return GGI.foldl_fn_(_val, f, zero, ctx)

# similar to foldl_fn, but also supports lambda string expressions (same as `foldl_fn(F(f), zero, ctx)`)
func foldl(f, zero, ctx = GGI._EMPTY_CONTEXT): return GGI.foldl_(_val, f, zero, ctx)

func foldl_mtd(obj: Object, method_name: String, zero, ctx = GGI._EMPTY_CONTEXT):
	return foldl_fn(funcref(obj, method_name), zero, ctx)

# ----------------------------------------------------------------------------------------------------------------------

# calls function-like on inner value. _w version wraps result into GGArray
func to(f): return GGI.f_like_to_func(f).call_func(_val)
func to_w(f) -> GGArray: return _w(to(f))

# TODO: raw version passing self?

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

# ----------------------------------------------------------------------------------------------------------------------

func sample(): return GGI.sample_(_val)

func sample_or_null(): return GGI.sample_or_null_(_val)

# ----------------------------------------------------------------------------------------------------------------------

# items are Array
func flatten() -> GGArray: return _w(GGI.flatten_(_val))

# items are GGArray (will be unwrapped)
func flatten_unwrapped() -> GGArray: return map_fld("val").flatten()

# ----------------------------------------------------------------------------------------------------------------------

func take(n: int) -> GGArray: return _w(GGI.take_(_val, n))

func take_right(n: int) -> GGArray: return _w(GGI.take_right_(_val, n))

func drop(n: int) -> GGArray: return _w(GGI.drop_(_val, n))

func drop_right(n: int) -> GGArray: return _w(GGI.drop_right_(_val, n))

# ----------------------------------------------------------------------------------------------------------------------

func reverse() -> GGArray: return _w(GGI.reverse_(_val))

# ----------------------------------------------------------------------------------------------------------------------

# call function-like with inner value, ignore result, return self
func tap(f) -> GGArray: # custom implementation to avoid rewrapping from using GGI.tap_
	GGI.f_like_to_func(f).call_func(_val)
	return self

# ----------------------------------------------------------------------------------------------------------------------

# sum all items in array
func sum() -> int: return GGI.sum_(_val)

# multiply all items in array
func product() -> int: return GGI.product_(_val)

# does predicate hold for all items?
# G([]).all("x => x > 0") ~ true
# G([1, 2, 1]).all("x => x > 0") ~ true
# G([1, 0, 1]).all("x => x > 0") ~ false
func all(p) -> bool: return GGI.all_(_val, p)

# does predicate hold for any item?
# G([]).any("x => x == 2") ~ false
# G([1, 2, 1]).any("x => x == 2") ~ true
# G([1, -1, 1]).any("x => x == 2") ~ false
func any(p) -> bool: return GGI.any_(_val, p)

# append item to end of array
func append(y) -> GGArray: return _w(GGI.append_(_val, y))

# prepend item to start of array
func prepend(y) -> GGArray: return _w(GGI.prepend_(_val, y))

# concatenate arrays (other to end)
func concat(other: Array) -> GGArray: return _w(GGI.concat_(_val, other))

# concatenate arrays (other to start)
func concat_left(other: Array) -> GGArray: return _w(GGI.concat_left_(_val, other))

# TODO:
# intersperse
# ? reject/filter_not
