extends Resource

## A wrapper of an `Array` offering a rich selection of general utility functions.
## .
## GodoDoc doesn't yet support documentation of `var`s, so here are at least copied out examples (a temporary solution):
## * Getter for unpacking [[Array]]
##   `G([1, 2]).val` returns `[1, 2]`
## * Get length of a wrapped array.
##   `G([1, 2]).size` returns `2`
## * Is wrapped array empty?
##   `G([]).is_empty` returns `true`
##   `G([1, 2]).is_empty` returns `false`
## @fileDocumentation

class_name GGArray

## @internal
var GGI = GGInternal.new()

## Getter for unpacking [[Array]]
## @example `G([1, 2]).val` returns `[1, 2]`
var val setget , _get_val

## Get length of a wrapped array.
## @example `G([1, 2]).size` returns `2`
var size setget , _get_size

## Is wrapped array empty?
## @example `G([]).is_empty` returns `true`
## @example `G([1, 2]).is_empty` returns `false`
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

## Map every value in an array using a given function.
## @typeparam T {any} Input [[GGArray]] item type
## @typeparam U {any} Output [[GGArray]] item type
## @param f {Func<T, U>} Mapping function (`FuncRef` or `CtxFRef1`)
## @param ctx {any} Context for function
## @return {U}
## @example `G([1, 2]).map_fn(GG.inc_).val` returns `[2, 3]`
func map_fn(f, ctx = GGI._EMPTY_CONTEXT) -> GGArray: return _w(GGI.map_fn_(_val, f, ctx))

## Similar to [[map_fn]], but also supports function-like type.
## @typeparam T {any} Input [[GGArray]] item type
## @typeparam U {any} Output [[GGArray]] item type
## @param f {FuncLike<T, U>} Mapping function
## @param ctx {any} Context for function
## @return {U}
## @example `G([1, 2]).map("x => x + 1").val` returns `[2, 3]`
func map(f, ctx = GGI._EMPTY_CONTEXT) -> GGArray: return _w(GGI.map_(_val, f, ctx))

## Map an outer method (method of one specific object, usually one from which call originates - `self`)
func map_out_mtd(obj: Object, method_name: String, ctx = GGI._EMPTY_CONTEXT) -> GGArray:
	return map_fn(funcref(obj, method_name), ctx)

## Map an inner method (a method on objects in [[GGArray]] item).
func map_in_mtd(inner_method_name: String, ctx = GGI._EMPTY_CONTEXT) -> GGArray:
	var r:= []
	for x in _val: r.push_back(GGI.call_f0_w_ctx(funcref(x, inner_method_name), ctx))
	return _w(r)

# ----------------------------------------------------------------------------------------------------------------------

## Map a field in `Object` or `Dictionary`.
## @example `G([{name = "Spock"}, {name = "Scotty"}]).map_fld("name").val` returns `["Spock", "Scotty"]`
func map_fld(field_name: String) -> GGArray:
	var r:= []
	for x in _val:
		if x && field_name in x: r.push_back(x[field_name])
	return _w(r)

# ----------------------------------------------------------------------------------------------------------------------

## Call a function for every value in an array.
## @example `G(["Firefly", "Daedalus"]).for_each("x -> print(x)")` prints `Firefly` and `Daedalus` on separate lines (two calls)
func for_each(f, ctx = GGI._EMPTY_CONTEXT) -> void: GGI.for_each_(_val, f, ctx)

# ----------------------------------------------------------------------------------------------------------------------

## Join an array of `String`s.
## @example `G(["Dog", "Cat", "Frog"]).join(", ")` returns `"Dog, Cat, Frog"`
## @example `G([1, 2, 3]).join(", ", "<", ">")` returns `"<1, 2, 3>"`
func join(delim: String = "", before: String = "", after: String = "") -> String:
	return GGI.join_(_val, delim, before, after)

## Similar as [[join]], but wraps a result in [[GGArray]].
func join_w(delim: String = "", before: String = "", after: String = "") -> GGArray:
	return _w([join(delim, before, after)])

# ----------------------------------------------------------------------------------------------------------------------

# get value size (array length)
func _get_size() -> int: return _val.size()

func _get_is_empty() -> bool: return self.size == 0

# ----------------------------------------------------------------------------------------------------------------------

## Filter out values from an array for which predicate function returns `false`.
func filter_fn(predicate, ctx = GGI._EMPTY_CONTEXT) -> GGArray: return _w(GGI.filter_fn_(_val, predicate, ctx))

## Similar to [[filter_fn]], but supports [[FuncLike]].
## @example `G(range(-4, 4)).filter("x => x >= 2").val` returns `[2, 3]`
func filter(predicate, ctx = GGI._EMPTY_CONTEXT) -> GGArray: return _w(GGI.filter_(_val, predicate, ctx))

## Filter contents using a method on one specific `Object`.
func filter_out_mtd(obj: Object, method_name: String, ctx = GGI._EMPTY_CONTEXT) -> GGArray:
	return filter_fn(funcref(obj, method_name), ctx)

## Filter contents using a method on each item in an array.
func filter_in_mtd(inner_method_name: String, ctx = GGI._EMPTY_CONTEXT) -> GGArray:
	var r:= []
	for x in _val:
		if GGI.call_f0_w_ctx(funcref(x, inner_method_name), ctx): r.push_back(x)
	return _w(r)

# ----------------------------------------------------------------------------------------------------------------------

## Filter an array of objects using `bool` field.
## @example `G([{enabled = true, id = 0}, {enabled = false, id = 1}, {enabled = true, id = 2}]).filter_by_fld("enabled").map_fld("id").val` returns `[0, 2]`
func filter_by_fld(field_name: String) -> GGArray:
	var r:= []
	for x in _val:
		if field_name in x && x[field_name]: r.push_back(x)
	return _w(r)

# ----------------------------------------------------------------------------------------------------------------------

## Filter an array of objects using one field and field value.
## @example `G([{id = 0, name = "Zero"}, {id = 1, name = "One"}]).filter_by_fld_val("id", 1).map_fld("name").val` returns `["One"]`
func filter_by_fld_val(field_name: String, field_value) -> GGArray:
	var r:= []
	for x in _val:
		if field_name in x && x[field_name] == field_value: r.push_back(x)
	return _w(r)

# ----------------------------------------------------------------------------------------------------------------------

## Return a new [[GGArray]] omitting given value.
## @example `G([1, 2, 1]).without(1).val` returns `[2]`
func without(value_to_omit) -> GGArray: return _w(GGI.without_(_val, value_to_omit))

## Return a new [[GGArray]] omitting `null` items.
## @example `G([1, null, 3]).compact().val` returns `[1, 3]`
func compact() -> GGArray: return _w(GGI.compact_(_val))

# ----------------------------------------------------------------------------------------------------------------------

## Find an item by a value of a field.
## @example `G([{id = 0, name = "Zero"}, {id = 1, name = "One"}]).find_by_fld_val("id", 1).name` returns `"One"`
func find_by_fld_val(field_name: String, field_value):
	return filter_by_fld_val(field_name, field_value).head()

# ----------------------------------------------------------------------------------------------------------------------

## Takes an operator and a zero (initial) value, reduces array to one value by repeatedly applying the operator to items from an array.
## @param f {Func<R, T, R>} Operator
## @return {R}
func foldl_fn(f: FuncRef, zero, ctx = GGI._EMPTY_CONTEXT): return GGI.foldl_fn_(_val, f, zero, ctx)

## Similar to [[foldl_fn]], but also supports [[FuncLike]].
## @example `G([1, 2, 3]).foldl("a, x => a + x", -6)` returns `0` (-6 + 1 + 2 + 3)
func foldl(f, zero, ctx = GGI._EMPTY_CONTEXT): return GGI.foldl_(_val, f, zero, ctx)

## Same as [[foldl_fn]], but instead of a `FuncRef` takes an object and a name of its method.
func foldl_mtd(obj: Object, method_name: String, zero, ctx = GGI._EMPTY_CONTEXT):
	return foldl_fn(funcref(obj, method_name), zero, ctx)

# ----------------------------------------------------------------------------------------------------------------------

## Calls [[FuncLike]] on the inner value.
func to(f): return GGI.f_like_to_func(f).call_func(_val)

## Calls [[FuncLike]] on the inner value and wraps the result in [[GGArray]].
func to_w(f) -> GGArray: return _w(to(f))

# TODO: raw version passing self?

# ----------------------------------------------------------------------------------------------------------------------

## Get first item or `null` for empty array.
## @example `G([1, 2, 3]).head()` returns `1`
func head(): return GGI.head_(_val)

## Get last item or `null` for empty array.
## @example `G([1, 2, 3]).last()` returns `3`
func last(): return GGI.last_(_val)

## Get all items except first one.
## @example `G([1, 2, 3]).tail().val` returns `[2, 3]`
func tail() -> GGArray:
	GGI.assert_(_get_size() > 0, "cannot call tail on empty array")
	return _w(GGI.tail_(_val))

## Get all items except last one.
## @example `G([1, 2, 3]).init().val` returns `[1, 2]`
func init() -> GGArray:
	GGI.assert_(_get_size() > 0, "cannot call init on empty array")
	return _w(GGI.init_(_val))

# ----------------------------------------------------------------------------------------------------------------------

## Return a sorted [[GGArray]].
func sort() -> GGArray: return _w(GGI.sort_(_val))

# lambda string support?

## Sort an array using a supplied compare function.
func sort_by(cmp_f: FuncRef) -> GGArray: return _w(GGI.sort_by_(_val, cmp_f))

## Sort an array of objects by one given field.
func sort_by_fld(field_name: String) -> GGArray: return _w(GGI.sort_by_fld_(_val, field_name))

## Sort an array using a mapping function (result is sorted on values obtained from the mapping function).
func sort_with(map_f: FuncRef) -> GGArray: return _w(GGI.sort_with_(_val, map_f))

# ----------------------------------------------------------------------------------------------------------------------

## Zip together two arrays.
## A length of a result is same length as a length of a shorter array (meaning arrays are **not** padded with `null`s to be of same length, but the larger array is truncated to match the length of the shorter one).
## @example `G([1, 2]).zip(["a", "b"]).val` returns `[[1, "a"], [2, "b"]]`
## @example `G([1]).zip(["a", "b"]).val` returns `[[1, "a"]]`
func zip(other: Array) -> GGArray: return _w(GGI.zip_(_val, other))

# ----------------------------------------------------------------------------------------------------------------------

## Does nothing, used to end a chain. Usually it's better to rather use chain-ending methods like [[for_each]] or [[to]].
## Can be used to suppress `The function 'map_out_mtd()' returns a value, but this value is never used.` and similar.
func noop() -> void: pass

# ----------------------------------------------------------------------------------------------------------------------

## Get a random item (crashes on an empty array).
## @example `G([1]).sample()` returns `1`
## @example `G(["Frog", "Toad"]).sample()` returns `"Frog"` or `"Toad"` with an equal chance
## @example `G([]).sample()` crashes
func sample(): return GGI.sample_(_val)

## Get a random item (`null` on an empty array).
## @example `G([1]).sample_or_null()` returns `1`
## @example `G(["Frog", "Toad"]).sample_or_null()` returns `"Frog"` or `"Toad"` with an equal chance
## @example `G([]).sample_or_null()` returns `null`
func sample_or_null(): return GGI.sample_or_null_(_val)

# ----------------------------------------------------------------------------------------------------------------------

## Flattens [[GGArray]] of `Array`s to [[GGArray]] (spreads items).
## @example `G([[1, 2], [3]]).flatten().val` returns `[1, 2, 3]`
func flatten() -> GGArray: return _w(GGI.flatten_(_val))

## Flattens [[GGArray]] of [[GGArray|GGArrays]] to [[GGArray]] (spreads items).
## @example `G([G([1, 2]), G([3])]).flatten_unwrapped().val` returns `[1, 2, 3]`
func flatten_unwrapped() -> GGArray: return map_fld("val").flatten()

# ----------------------------------------------------------------------------------------------------------------------

## Take `n` items from a start of an array.
## @example `G([1, 2, 3, 4, 5]).take(2).val` returns `[1, 2]`
func take(n: int) -> GGArray: return _w(GGI.take_(_val, n))

## Take `n` items from an end of an array.
## @example `G([1, 2, 3, 4, 5]).take_right(2).val` returns `[4, 5]`
func take_right(n: int) -> GGArray: return _w(GGI.take_right_(_val, n))

## Drop (skip) n items from a start of an array.
## @example `G([1, 2, 3, 4, 5]).drop(2).val` returns `[3, 4, 5]`
func drop(n: int) -> GGArray: return _w(GGI.drop_(_val, n))

## Drop (skip) n items from an end of an array.
## @example `G([1, 2, 3, 4, 5]).drop_right(2).val` returns `[1, 2, 3]`
func drop_right(n: int) -> GGArray: return _w(GGI.drop_right_(_val, n))

# ----------------------------------------------------------------------------------------------------------------------

## Reverse order of items in an array.
## @example `G([1, 2, 3]).reverse().val` returns `[3, 2, 1]`
func reverse() -> GGArray: return _w(GGI.reverse_(_val))

# ----------------------------------------------------------------------------------------------------------------------

## Call FuncLike with inner value, ignore call result, return same array.
## @typeparam T {any} Type of [[GGArray]] items
## @param f {FuncLike<T, any>}
## @return {GGArray<T>}
func tap(f) -> GGArray: # custom implementation to avoid rewrapping from using GGI.tap_
	GGI.f_like_to_func(f).call_func(_val)
	return self

# ----------------------------------------------------------------------------------------------------------------------

## Sum all items in an array.
## @example `G([2, 3, 5]).sum()` returns `10`
func sum() -> int: return GGI.sum_(_val)

## Multiply all items in an array.
## @example `G([2, 3, 5]).product()` returns `30`
func product() -> int: return GGI.product_(_val)

## Does a predicate hold for all items?
## @typeparam T {any} Type of [[GGArray]] items
## @param p {FuncLike<T, bool>}
## @return {bool}
## @example `G([]).all("x => x > 0")` returns `true`
## @example `G([1, 2, 1]).all("x => x > 0")` returns `true`
## @example `G([1, 0, 1]).all("x => x > 0")` returns `false`
func all(p) -> bool: return GGI.all_(_val, p)

## Does a predicate hold for any item?
## @typeparam T {any} Type of [[GGArray]] items
## @param p {FuncLike<T, bool>}
## @return {bool}
## @example `G([]).any("x => x == 2")` returns `false`
## @example `G([1, 2, 1]).any("x => x == 2")` returns `true`
## @example `G([1, -1, 1]).any("x => x == 2")` returns `false`
func any(p) -> bool: return GGI.any_(_val, p)

## Append an item to an end of the array.
func append(y) -> GGArray: return _w(GGI.append_(_val, y))

## Prepend an item to a start of the array.
func prepend(y) -> GGArray: return _w(GGI.prepend_(_val, y))

## Concatenate arrays (`other` to end).
func concat(other: Array) -> GGArray: return _w(GGI.concat_(_val, other))

## Concatenate arrays (`other` to start)
func concat_left(other: Array) -> GGArray: return _w(GGI.concat_left_(_val, other))

# TODO:
# intersperse
# ? reject/filter_not
