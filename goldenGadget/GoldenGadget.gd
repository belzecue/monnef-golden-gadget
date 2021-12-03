#
#    _|_|_|            _|        _|                            _|_|_|                  _|                        _|
#  _|          _|_|    _|    _|_|_|    _|_|    _|_|_|        _|          _|_|_|    _|_|_|    _|_|_|    _|_|    _|_|_|_|
#  _|  _|_|  _|    _|  _|  _|    _|  _|_|_|_|  _|    _|      _|  _|_|  _|    _|  _|    _|  _|    _|  _|_|_|_|    _|
#  _|    _|  _|    _|  _|  _|    _|  _|        _|    _|      _|    _|  _|    _|  _|    _|  _|    _|  _|          _|
#    _|_|_|    _|_|    _|    _|_|_|    _|_|_|  _|    _|        _|_|_|    _|_|_|    _|_|_|    _|_|_|    _|_|_|      _|_|
#                                                                                                _|
#                                                                                            _|_|
# Golden Gadget
# GDScript utility library focused on functional programming (FP)
#
# version: 0.5.0 (2019-2021)
# author:  monnef
# license: MIT
# repo:    https://gitlab.com/monnef/golden-gadget
#
# If you use this library, I would be happy for a star on GitLab or a tweet/gab/post.
# But of course you are not required to do so (license is very permissive), it's up to you.
#
# setup:
#  1) download source code
#  2) unpack and copy "goldenGadget" directory to your project
#  3) Project -> Project Settings -> AutoLoad -> add this script as "GG" with singleton enabled
#
# recommended "imports":
#   func G(arr) -> GGArray: return GG.arr(arr)
#
# All examples presume "imports" above are present and autoloading is configured.
# Nice examples are located in GGTests script at the end.

## If some function is undocumented here (e.g. [[size_]]), please see documentation of [[GGArray]].
##
## `FuncLike<A, B>` means function-like value which represents a function taking one argument of type `A` and returns value of type `B`.
## @fileDocumentation

tool
extends Node

var GGI = preload("GGInternal.gd").new()

func _ready() -> void:
	_words_splitter.compile("[^\\s]+")
	_lines_splitter.compile("[^\n]+")
	# _lower_upper_case_splitter.compile("\\p{Lu}*(?:\\p{Ll}|\\d)*") # Godot doesn't support unicode property codes :(
	_lower_upper_case_splitter.compile("[A-Z]*[a-z0-9]*")

## Wraps `Array` into [[GGArray]].
## @param arr {Array<T>} array to wrap
## @return {GGArray<T>}  wrapped array
## Recommended "import" (code at a start of a file we want to use the `arr` in):
## `func G(arr) -> GGArray: return GG.arr(arr)`
func arr(array) -> GGArray:
	# TODO: support string via to_utf8?
	return GGArray.new(array)

func with_ctx(f: FuncRef, ctx) -> CtxFRef1: return CtxFRef1.new(f, ctx)

func with_ctx2(f: FuncRef, ctx) -> CtxFRef2: return CtxFRef2.new(f, ctx)

# ----------------------------------------------------------------------------------------------------------------------

const MAX_INT = 9223372036854775807

# ----------------------------------------------------------------------------------------------------------------------

# utility functions

## Terminate/halt/quit program.
## @param error_code {int} Exit code returned from the Godot process (0 means normal exit, >0 means an error)
func quit_(error_code: int = 0) -> void: GGI.quit_(error_code)
var quit = funcref(self, "quit_")

func parse_cmd_args_(args: Array) -> Dictionary:
	var res:= {}
	for arg in args:
		if arg.find("=") > -1:
			var kv = arg.split("=")
			res[kv[0].lstrip("--")] = kv[1]
		elif arg.begins_with("--"):
			res[arg.lstrip("--")] = true
	return res
var parse_cmd_args = funcref(self, "parse_cmd_args_")

func get_cmd_args_() -> Dictionary: return parse_cmd_args_(OS.get_cmdline_args())
var get_cmd_args = funcref(self, "get_cmd_args_")

## Assert condition is `true`, terminate program with error message otherwise.
func assert_(cond: bool, msg: String) -> void: GGI.assert_(cond, msg)
var assert__ = funcref(self, "assert_")

## Assert two values are equal (using [[eqd]]).
func assert_eq_(actual, expected, note: String = "") -> void: GGI.assert_eq_(actual, expected, note)
var assert_eq = funcref(self, "assert_eq_")

## Terminate program with error message.
func crash_(msg: String) -> void: GGI.crash_(msg)
var crash = funcref(self, "crash_")

## logical and
func l_and_(x: bool, y: bool) -> bool: return x && y
var l_and = funcref(self, "l_and_")

## logical or
func l_or_(x: bool, y: bool) -> bool: return x || y
var l_or = funcref(self, "l_or_")

## adds two values
func add_(x: int, y: int) -> int: return x + y
var add = funcref(self, "add_")

## subtracts second argument from first
func subtract_(x: int, y: int) -> int: return x - y
var subtract = funcref(self, "subtract_")

## `and` operation performed on array of bools
## @param x {Array<bool>}
## @return {bool}
func a_and_(x: Array) -> bool: return arr(x).foldl_fn(l_and, true)
var a_and = funcref(self, "a_and_")

## `or` operation performed on array of `bool`s
## @param x {Array<bool>}
## @return {bool}
func a_or_(x: Array) -> bool: return arr(x).foldl_fn(l_or, false)
var a_or = funcref(self, "a_or_")

## shallow equality check
func eq_(a, b) -> bool: return GGI.eq_(a, b)
var eq = funcref(self, "eq_")

## shallow not-equality check
func neq_(a, b) -> bool: return !GGI.eq_(a, b)
var neq = funcref(self, "neq_")

## deep equality check
func eqd_(a, b) -> bool: return GGI.eqd_(a, b)
var eqd = funcref(self, "eqd_")

## determines equality (==) of a field (given name and value in args parameter) in object (first parameter)
func eq_field_(object, args) -> bool:
	if object && args.name in object: return object[args.name] == args.value
	return false
var eq_field = funcref(self, "eq_field_")

## Invoke a function with parameters given in array.
func call_spread_(f: FuncRef, arr: Array): return GGI.call_spread_(f, arr)
var call_spread = funcref(self, "call_spread_")

## Convert string from snake to pascal case
func snake_to_pascal_case_(x: String) -> String: return arr(x.split("_")).map_fn(capitalize).join("")
var snake_to_pascal_case = funcref(self, "snake_to_pascal_case_")

## Convert string from snake to camel case.
func snake_to_camel_case_(x: String) -> String: return decapitalize_first_(arr(x.split("_")).map_fn(capitalize).join(""))
var snake_to_camel_case = funcref(self, "snake_to_camel_case_")

var _lower_upper_case_splitter = RegEx.new()

## Convert string from camel to snake case.
func camel_to_snake_case_(x: String) -> String:
	return arr(_lower_upper_case_splitter.search_all(x))\
	  .map("x => x.get_string()")\
	  .filter("x => x != \"\"")\
	  .map(capitalize_all)\
	  .join("_")
var camel_to_snake_case = funcref(self, "camel_to_snake_case_")

## Capitalize string - convert first character to upper case and all other to lower case.
func capitalize_(x: String) -> String:
	if x.length() == 0: return ""
	return capitalize_first_(x[0]) + x.substr(1, x.length() - 1).to_lower()
var capitalize = funcref(self, "capitalize_")

## Capitalize first character of string (doesn't touch other characters).
func capitalize_first_(x: String) -> String:
	if x.length() == 0: return ""
	var arr = x.to_utf8()
	return x[0].to_upper() + PoolByteArray(tail_(arr)).get_string_from_utf8()
var capitalize_first = funcref(self, "capitalize_first_")

## Capitalize all characters.
func capitalize_all_(x: String) -> String: return x.to_upper()
var capitalize_all = funcref(self, "capitalize_all_")

## Decapitalize first character of string (doesn't touch other characters).
func decapitalize_first_(x: String) -> String:
	if x.length() == 0: return ""
	var arr = x.to_utf8()
	return x[0].to_lower() + PoolByteArray(tail_(arr)).get_string_from_utf8()
var decapitalize_first = funcref(self, "decapitalize_first_")

## Do nothing.
## @param x {any}
func noop1_(x) -> void: pass
var noop1 = funcref(self, "noop1_")

## Do nothing.
## @param x {any}
## @param y {any}
func noop2_(x, y) -> void: pass
var noop2 = funcref(self, "noop2_")

## Do nothing.
## @param x {any}
## @param y {any}
## @param z {any}
func noop3_(x, y, z) -> void: pass
var noop3 = funcref(self, "noop3_")

## Do nothing.
## @param x {any}
## @param y {any}
## @param z {any}
## @param a {any}
func noop4_(x, y, z, a) -> void: pass
var noop4 = funcref(self, "noop4_")

## Multiple two numbers.
func multiply_(x, y): return x * y
var multiply = funcref(self, "multiply_")

## Calculate modulo of two numbers (of same type).
## @param x {int | float} First number
## @param y {int | float} Second number
## @return {int | float}  Modulo of input numbers, has same type.
func modulo_(x, y):
	if x is float and y is float: return fmod(x, y)
	elif x is int and y is int: return x % y
var modulo = funcref(self, "modulo_")

## Add one to a given number.
func inc_(x): return x + 1
var inc = funcref(self, "inc_")

## Subtract one from a given number.
func dec_(x): return x - 1
var dec = funcref(self, "dec_")

## Negate given number.
func negate_num_(x): return -x
var negate_num = funcref(self, "negate_num_")

## Logic not.
func negate_(x: bool) -> bool: return !x
var negate = funcref(self, "negate_")

## Get a value in a given field.
## @param obj {Object | Dictionary}
## @param field_name {String}
## @return {any}
## Crashes on a missing field.
func get_fld_(obj, field_name): return GGI.get_fld_(obj, field_name)
var get_fld = funcref(self, "get_fld_")

## Get a value in a given field. If the field is missing, return a given default value.
## @param obj {Object | Dictionary}
## @param field_name {String}
## @param default {any}
## @return {any}
func get_fld_or_else_(obj, field_name, default): return GGI.get_fld_or_else_(obj, field_name, default)
var  get_fld_or_else = funcref(self, "get_fld_or_else_")

## Get a value in a given field. If the field is missing, return `null`.
## @param obj {Object | Dictionary}
## @param field_name {String}
## @param default {any}
## @return {any}
func get_fld_or_null_(obj, field_name): return GGI.get_fld_or_null_(obj, field_name)
var  get_fld_or_null = funcref(self, "get_fld_or_null_")

## Merge two dictionaries.
## @param default {Dictionary} Base dictionary
## @param donor {Dictionary} Dictionary to be merged into base (overrides same fields)
## @return {Dictionary} New merged dictionary
func merge_(default: Dictionary, donor: Dictionary) -> Dictionary:
	var r = default.duplicate()
	for k in donor.keys(): r[k] = donor[k]
	return r
var merge = funcref(self, "merge_")

## Get a first item in a pair.
func fst_(pair: Array): return GGI.fst_(pair)
var fst = funcref(self, "fst_")

## Get a second item in a pair.
func snd_(pair: Array): return GGI.snd_(pair)
var snd = funcref(self, "snd_")

## Compile script and return new instance of it.
func compile_script_(src: String): return GGI.compile_script_(src)
var compile_script = funcref(self, "compile_script_")

## Compile a script with one function, instantiate the script and return a `funcref` of the function.
func compile_function_(expr: String) -> FuncRef: return GGI.function_(expr)
var compile_function = funcref(self, "compile_function_")

## Create function-like object depending on type of `f`.
## * `FuncRef` - pass same value
## * `String` - compiles function and returns its `FuncRef`
##              `"x => x + 1"` ~ get `FuncRef` of `func f(x): return x + 1`
## * `Array` - partial application (creates `CtxFRef1`)
##             `["x, y => x + y", 1]` which is functionally equivalent to `"x => x + 1"`
## @param f {FuncRef | String | Array<any>}
## @return {FuncRef | CtxFRef1}
func F_(f): return GGI.f_like_to_func(f)

## Flip arguments of given two-argument function.
## @param f {FuncLike<A, B, R>}
## @return {FuncLike<B, A, R>}
## @example `GG.flip_("x, y => x - y")` has same meaning in GG as `"y, x => x - y"`
## @example `G([0, 1, 2]).map("x, y => x - y", 10).val` return `[-10, -9, -8]`, in the map call the function with context is equivalent to `x => x - 10`
## @example `G([0, 1, 2]).map(GG.flip_("x, y => x - y"), 10).val` return `[10, 9, 8]`, in the map call the function with context is equivalent to `x => 10 - x`
## @example `G([0, 1, 2]).map(GG.flip_(GG.subtract), 10).val` returns `[10, 9, 8]`
func flip_(f): return GGI.flip_(f)
var flip = funcref(self, "flip_")

## Get keys of `Dictionary` or `Object`.
## @param obj {Dictionary | Object}
## @return {Array<String>}
## @example `GG.keys_({a = 1, b = 2})` returns `["a", "b"]`
func keys_(obj):
	if obj == null: return null
	var is_dict = obj is Dictionary
	var is_obj = obj is Object
	GGI.assert_(is_dict || is_obj, "keys function expects Object or Dictionary")
	return obj.keys() if is_dict else arr(obj.get_property_list()).map_fld("name").val
var keys = funcref(self, "keys_")

## Get key by given value. Supports `Dictionary` and `Object` (custom classes).
## @param obj {Dictionary | Object}
## @param val {any}
## @return {any | null} Returns `null` if value is not found.
## Useful for finding a name of an enum item from an item value.
## @example `GG.key_from_val_({a = 1, b = 2}, 1)` returns `"a"`.
func key_from_val_(obj, val):
	for key in keys_(obj):
		if key in obj:
			var curr_val = obj[key]
			if typeof(curr_val) == typeof(val) && curr_val == val: return key
	return null
var key_from_val = funcref(self, "key_from_val_")

## Call a method when the method exists and return its result, otherwise return `null`.
## @param obj {Object} Object owning the method
## @param method_name {String} Object owning the method
## @param args {Array<any>} Arguments to pass to the method
## @return {any} What method returned, or `null` when `obj` is `null` or `obj` has no such method
## @example `GG.ap_if_defined_(GG, "add_", [2, 5])` returns `7`
## @example `GG.ap_if_defined_(GG, "_non_existing_method", [2, 5])` returns `null`
func ap_if_defined_(obj, method_name: String, args: Array):
	if obj && obj.has_method(method_name):
		return call_spread_(funcref(obj, method_name), args)
	return null
var ap_if_defined = funcref(self, "ap_if_defined_")

## Get a random item from an array.
## @param arr {Array<T>} the input array
## @return {T} a randomly picked item
## @typeParam T {any}    type of items in the array
## @example `sample_([1, 2])` returns `1` or `2` with equal chance
## @example `sample_([])` crashes
## Crashes on an empty array.
func sample_(arr: Array): return GGI.sample_(arr)
var sample = funcref(self, "sample_")

## Get a random item from an array.
## @param arr {Array<T>} the input array
## @return {T | null}    a random item, or null for an empty array
## @typeParam T {any}    type of items in the array
## @example `sample_or_null_([1, 2])` returns `1` or `2` with equal chance
## @example `sample_or_null_([])` returns always `null`
func sample_or_null_(arr: Array): return GGI.sample_or_null_(arr)
var sample_or_null = funcref(self, "sample_or_null_")

## Format `DateTime` (if no provided, current will be used) in following format: `YYYY-MM-DD--HH-MM-SS`
## @param date {DateTime | null}
## @return {String}
## @example Possible output: `"2019-12-19--13-03-18"`
func format_datetime_(date = null) -> String:
	if !date: date = OS.get_datetime()
	return "%s-%02d-%02d--%02d-%02d-%02d" % [date.year, date.month, date.day, date.hour, date.minute, date.second]
var format_datetime = funcref(self, "format_datetime_")

enum TimeFormat {
	HOURS   = 1 << 0,
	MINUTES = 1 << 1,
	SECONDS = 1 << 2,
	MILISECONDS = 1 << 3,
	MINSEC = 1 << 1 | 1 << 2,
	MINSECMILI = 1 << 1 | 1 << 2 | 1 << 3,
	DEFAULT = 7
}

## Format time.
## @param time {float} Time in seconds
## @param options {Dictionary}
## Options:
## * `format`           - default `TimeFormat.DEFAULT` (hours + minutes + seconds)
## * `delim`            - delimiter, default `":"`
## * `digit_format`     - default `"%02d"`
## * `hours_format`     - default is `digit_format`
## * `minutes_format`   - default is `digit_format`
## * `seconds_format`   - default is `digit_format` (or `"%05.2f"` when TimeFormat.MILISECONDS is in `format`)
## @example `GG.format_time_(0)` returns `"00:00:00"`
## @example `GG.format_time_(45296)` returns `"12:34:56"`
## @example `GG.format_time_(81, {format = GG.TimeFormat.MINSEC})` returns `"01:21"`
## @example `GG.format_time_(62.1, {format = GG.TimeFormat.MINSECMILI})` returns `"01:02.10"`
## @example `GG.format_time_(81, {format = GG.TimeFormat.MINUTES | GG.TimeFormat.SECONDS})` returns `"01:21"`
## @example `GG.format_time_(62, {digit_format = "%d"})` returns `"0:1:2"`
## @example `GG.format_time_(0, {delim = "•"})` returns `"00•00•00"`
## @example `GG.format_time_(45296.7, {hours_format = "H = %d", minutes_format = "M = %d", seconds_format = "S = %.1f", delim = " | "})` returns `"H = 12 | M = 34 | S = 56.7"`
func format_time_(time: float, options: Dictionary = {}) -> String:
	var digit_format = get_fld_or_else_(options, "digit_format", "%02d")
	var format = get_fld_or_else_(options, "format", TimeFormat.DEFAULT)
	var default_milisecs_format = "%05.2f"
	var seconds_format = get_fld_or_else_(options, "seconds_format", default_milisecs_format if format & TimeFormat.MILISECONDS else digit_format)
	var minutes_format = get_fld_or_else_(options, "minutes_format", digit_format)
	var hours_format = get_fld_or_else_(options, "hours_format", digit_format)
	var delim = get_fld_or_else_(options, "delim", ":")

	var hours = (hours_format % [time / 3600]) if format & TimeFormat.HOURS else null
	var minutes = (minutes_format % [fmod(time, 3600) / 60]) if format & TimeFormat.MINUTES else null
	var seconds = (seconds_format % [fmod(time, 60)]) if format & TimeFormat.SECONDS else null
	var miliseconds = (seconds_format % [fmod(time, 1)]).lstrip("0 ") if format & TimeFormat.MILISECONDS && !format & TimeFormat.SECONDS else null

	# hack around Godot's broken float zero padding (inserts spaces instead of zeroes) - https://github.com/godotengine/godot/issues/39237
	if seconds_format == default_milisecs_format && seconds != null:
		seconds = (seconds as String).replace(" ", "0")

	return arr([hours, minutes, seconds, miliseconds]).compact().join(delim)
var format_time = funcref(self, "format_time_")

## Test if two `float` values are same (within margin of `eps`).
## @param x {float} first value
## @param y {float} second value
## @param eps {float} accepted margin
## @return {bool}
func floats_are_equal_(x: float, y: float, eps:= 0.0001) -> bool: return x + eps >= y && x - eps <= y
var floats_are_equal = funcref(self, "floats_are_equal_")

## Format `float` to 2 decimal places.
## @param x {float | null}
## @return {String}
## @example `format_float_2_(1.23456)` returns `"1.23"`
func format_float_2_(x) -> String:
	if x is float: return "%.2f" % x
	return str(x)
var format_float_2 = funcref(self, "format_float_2_")

## Format `Vector2` to 2 decimal places.
## @param x {Vector2 | null}
## @return {String}
## @example `format_vec2_2_(Vector2(1.2345, 0))` returns `"1.23, 0.00"`
func format_vec2_2_(x) -> String:
	if x is Vector2: return "%.2f, %.2f" % [x.x, x.y]
	return str(x)
var format_vec2_2 = funcref(self, "format_vec2_2_")

## Format `Vector3` to 2 decimal places.
## @param x {Vector3 | null}
## @return {String}
## @example `format_vec3_2_(Vector3(1.2345, 0, 7))` returns `"1.23, 0.00, 7.00"`
func format_vec3_2_(x) -> String:
	if x is Vector3: return "%.2f, %.2f, %.2f" % [x.x, x.y, x.z]
	return str(x)
var format_vec3_2 = funcref(self, "format_vec3_2_")

## Save a screenshot.
## Optionally takes an options dictionary:
## * `quiet`          - when true silence all console output
## * `dir`            - overrides screenshot directory (default is `"user://screenshots"`, expanded for example like this: `"/home/user/.local/share/godot/app_userdata/project/screenshots"`)
## Returns dictionary with following fields:
## * `dir`            - screenshot directory. Example: `"/home/user/.local/share/godot/app_userdata/project/screenshots"`
## * `result`         - Error code, use OK constant to test if taking screenshot was successful. Example: `12`
## * `stage`          - last reached stage, either `"create_dir"` or `"save"`. Example: `"save"`
## * `file_name`      - image file name (without directory). Example: `"2019-12-19--13-20-35.png"`
## * `full_file_name` - full path to screenshot file. Example: `"/home/user/.local/share/godot/app_userdata/project/screenshots/2019-12-19--13-20-35.png"`
func take_screenshot_(options: Dictionary = {}) -> Dictionary:
	var quiet = get_fld_or_else_(options, "quiet", false)
	var override_dir = get_fld_or_null_(options, "dir")

	var res = {}
	var img:= get_viewport().get_texture().get_data()

	img.flip_y()
	var screenshot_dir = override_dir if override_dir else OS.get_user_data_dir() + "/screenshots"
	var dir_res = Directory.new().make_dir_recursive(screenshot_dir)
	res.dir = screenshot_dir
	if dir_res != OK:
		if !quiet: printerr("Failed to create a screenshot directory '%s'." % screenshot_dir)
		res.result = dir_res
		res.stage = "create_dir"
	else:
		var file_name = format_datetime_() + ".png"
		var full_file_name = screenshot_dir + "/" + file_name
		var save_res = img.save_png(full_file_name)
		res.stage = "save"
		res.file_name = file_name
		res.full_file_name = full_file_name
		if save_res != OK:
			if !quiet: printerr("Saving screenshot as '%s' failed. Error code is %s." % [full_file_name, save_res])
			res.result = save_res
		else:
			if !quiet: print("Saved screenshot as '%s'." % full_file_name)
			res.result = OK
	return res
var take_screenshot = funcref(self, "take_screenshot_")

## Delete all children of a given parent (calls `queue_free` on children).
func delete_children_(parent: Node) -> void:
	for c in parent.get_children(): c.queue_free()
var delete_children = funcref(self, "delete_children_")

## Get recursively all children.
## @param parent {Node}
## @return {Array<Node>}
func get_children_rec_(parent: Node) -> Array:
	var children = parent.get_children()
	return arr(children).map("x => [x]").append(arr(children).map(get_children_rec).flatten_raw().val).flatten_raw().val
var get_children_rec = funcref(self, "get_children_rec_")

## Set a parent of a node. Similar to `add_child`, but allows adding nodes which already have a parent (aka reparent).
## @param child {Node}      Node of which parent will be set
## @param new_parent {Node} New parent node
## @return {Node}           Child node
func set_node_parent_(child: Node, new_parent: Node) -> Node:
	if child.get_parent(): child.get_parent().remove_child(child)
	new_parent.add_child(child)
	return child
var set_node_parent = funcref(self, "set_node_parent_")

## Safer `get_node` alternative which will crash when a parent, a path or a node are `null`/empty.
## @param parent {Node | null}    Of which node we want to retrieve a child
## @param path {NodePath | null}  Path to a child
## @return {Node | null}          Child node or `null` on failure
func get_node_or_crash_(parent, path) -> Node:
	var is_node_path = path is NodePath
	assert_(path != null && ((is_node_path && !path.is_empty()) || !is_node_path), "missing path")
	assert_(parent != null, "missing parent node")
	var node = parent.get_node(path)
	assert_(node != null, "missing child")
	return node
var get_node_or_crash = funcref(self, "get_node_or_crash_")

## Get a child node. If there is any problem, return `null`.
## @param parent {Node | null}             Of which node we want to retrieve a child
## @param path {NodePath | String | null}  Path to a child
## @return {Node | null}                   Child node or `null` on failure
func get_node_or_null_(parent, path):
	if path == null || (path is NodePath && path.is_empty()): return null
	if parent == null: return null
	return parent.get_node_or_null(path)
var get_node_or_null = funcref(self, "get_node_or_null_")

## Get nth parent from a node.
func get_nth_parent_(start: Node, level: int):
	if level < 1: return null
	var c = start
	for i in range(level): c = c.get_parent()
	return c
var get_nth_parent = funcref(self, "get_nth_parent_")

## Create a `Timer` node, connect timeout signal to the method and start.
## @param on {Node} Parent node for `Timer`, contains callback method
## @param method_name {String} Name of a method which is called after timer finishes
## @param time {float} Amount of time in seconds before callback method is called
## @param one_shot {bool} Should the new `Timer` run in one-shot mode? If it does, `Timer` is destroyed after time elapses, otherwise `Timer` remains.
## @return {Timer} New `Timer` node
func create_timer_and_start_(on: Node, method_name: String, time: float, one_shot:= true) -> Timer:
	var t = Timer.new()
	t.wait_time = time
	t.one_shot = one_shot
	if one_shot: t.connect("timeout", self, "_on_dynamic_timer_end", [t])
	t.connect("timeout", on, method_name)
	on.add_child(t)
	t.start()
	return t
var create_timer_and_start = funcref(self, "create_timer_and_start_")

func _on_dynamic_timer_end(t: Timer) -> void: t.queue_free()

var _words_splitter:= RegEx.new()

## Split a string to an array of words.
## @param x {String} Input string
## @return {Array<String>} words
## @example `words_raw_("a  b")` will return `["a", "b"]`.
func words_raw_(x: String) -> Array: return words_(x).val
var words_raw = funcref(self, "words_raw_")

## Split a string to an array of words.
## @param x {String} Input string
## @return {GGArray<String>} words
## @example `words_("a  b")` will return `arr(["a", "b"])`.
func words_(x: String) -> GGArray: return arr(_words_splitter.search_all(x)).map("x => x.strings[0]")
var words = funcref(self, "words_")

## Join words array to one string
## @param xs {Array<String>} Input array of words
## @return {String} Joined words
## @example `unwords_(["a", "b"])` returns `"a b"`
func unwords_(xs: Array) -> String: return arr(xs).join(" ")
var unwords = funcref(self, "unwords_")

var _lines_splitter:= RegEx.new()

## Split string with new line sequences to an array of lines
## Same as [[lines_]], but returns `Array<String>` instead of `GGArray<String>`.
func lines_raw_(x: String) -> Array: return lines_(x).val
var lines_raw = funcref(self, "lines_raw_")

## Split string with new line sequences to an array of lines
## @param x {String} Input text
## @return {GGArray<String>} Array containing lines as items (without new line sequences)
## @example `lines_("a\n\nb")` returns `arr(["a", "b"])`
func lines_(x: String) -> GGArray: return arr(_lines_splitter.search_all(x)).map("x => x.strings[0]")
var lines = funcref(self, "lines_")

## Join an array of lines to a string.
## @example `unlines_(["a", "b"])` returns `"a\nb"`
func unlines_(xs: Array) -> String: return arr(xs).join("\n")
var unlines = funcref(self, "unlines_")

## Calls first function with given input then sequentially takes a result from a previous function and passes it to a next one.
## Supports lambdas (string, e.g. `"x => x + 1"`) and partial application of 2 argument functions (e.g. `[GG.take, 2]`)
## Options dictionary fields:
## * print - if `true` then input, middle values and result is printed
## @example `pipe_(0, [inc_, inc_])` returns `2`, it is equivalent to `inc_(inc_(0))`.
## @example `pipe_([1, 2], [[GG.take, 1], "xs => xs[0] * 10"])` returns `10`, it is equivalent to `take_([1, 2], 1)[0] * 10`.
func pipe_(input, functions: Array, options = null): return GGI.pipe_(input, functions, options)
var pipe = funcref(self, "pipe_")

## Similar to [[pipe_]], but returns "piped" function composed from all passed functions.
## If you intend to call the resulting function immediately, use rather [[pipe_]] for better performance.
func flow_(functions: Array): return GGI.flow_(functions)
var flow = funcref(self, "flow_")

## Identity function - returns same value it got in an argument.
## @typeParam T {any}
## @param x {T} Input value
## @return {T} Same value as on input
func id_(x): return x
var id = funcref(self, "id_")

## Construct a function accepting one argument.
## This new function ignores passed argument and always returns `x` (an argument it was created with).
## @typeParam T {any}
## @param x {T} Value to be returned from constructed function
## @return {FuncLike<any, T>}
## @example `const_(1).call_func("Gorn")` returns `1`
## @example `const_("Resistance is futile!").call_func("Resist!")` returns `"Resistance is futile!"`
func const_(x): return GGI.const_(x)
var const__ = funcref(self, "const_")

## Call function-like `f` with `x`, return `x` (ignore return value of `f`).
## @typeParam T {any}
## @param x {T} Input value
## @param f {FuncLike<T, any>} Function accepting input value
## @return {T} Input value `x`
func tap_(x, f): return GGI.tap_(x, f)
var tap = funcref(self, "tap_")

## Format bool (default formatting uses upper-case, this function uses lower-case).
## @param x {bool}  Input value
## @return {String} Formatted value
func fmt_bool_(x: bool) -> String: return "true" if x else "false"
var fmt_bool = funcref(self, "fmt_bool_")

## Create an array of length `n` where all items are `x`.
## @typeParam T {any}
## @param x {T} Item used for filling the array
## @param n {int} Number of items
## @return {Array<T>}
## @example `replicate_("a", 3)` returns `["a", "a", "a"]`
func replicate_(x, n: int) -> Array: return GGI.replicate_(x, n)
var replicate = funcref(self, "replicate_")

## Create an n-dimensional array and fill its every cell with given `zero` value
## @typeParam T {any}
## @param zero {T} Value to assign to all cells
## @param dimensions {Array<int>} Dimensions (lengths) of new nested array.
## @return {Array<any>} Nested (n-dimensional) array
## @example `new_array_(0, [1])` returns `[0]`
## @example `new_array_(0, [3])` returns `[0, 0, 0]`
## @example `new_array_(0, [1, 2])` returns `[[0, 0]]`
## @example `new_array_("x", [2, 3])` returns `[["x", "x", "x"], ["x", "x", "x"]]`
func new_array_(zero, dimensions: Array) -> Array: return GGI.new_array_(zero, dimensions)
var new_array = funcref(self, "new_array_")

## Create an n-dimensional array and fill its every cell with a value returned by `cell_value_getter`.
## @typeParam T {any}
## @param cell_value_getter {FuncLike<Array<int>, T>} Function which accepts coordinates (array of numbers) and returns a value for a cell on those coordinates
## @param dimensions {Array<int>} Dimensions (lengths) of new nested array.
## @return {Array<any>} Nested (n-dimensional) array
## @example `generate_array_(GG.id, [3])` returns `[[0], [1], [2]]`
## @example `generate_array_("x => x[0] * 10 + x[1]", [2, 3])` returns `[ [0, 1, 2], [10, 11, 12] ]`
func generate_array_(cell_value_getter, dimensions: Array) -> Array: return GGI.generate_array_(cell_value_getter, dimensions)
var generate_array = funcref(self, "generate_array_")

## Convert array of floats to array of integers. Useful for correcting parsed JSONs.
## @param arr {Array<float>}
## @return {Array<int>}
## @example `float_arr_to_int_arr_([1.0, 2.0])` returns `[1, 2]`
func float_arr_to_int_arr_(arr: Array) -> Array: return GGI.float_arr_to_int_arr_(arr)
var float_arr_to_int_arr = funcref(self, "float_arr_to_int_arr_")

## Get field values from given object/dictionary as an array (indices of output array matches those of input array)
## @param obj {Object | Dictionary} Input value
## @param field_names {Array<String>} Names of fields to read values from
## @return {Array<any>} Read values of given fields
## @example `get_fields_({x = 2, y = true}, ["x", "y"])` returns `[2, true]`
func get_fields_(obj, field_names: Array) -> Array: return GGI.get_fields_(obj, field_names)
var get_fields = funcref(self, "get_fields_")

## Set field values of object/dictionary according to arrays of values and field names (indices of arrays match).
## @param obj {Object | Dictionary} Target for setting values on
## @param values {Array<any>} List of values
## @param field_names {Array<string>} List of corresponding field names
## @return {void}
## @example `var dict = {x = 2, y = true}; GG.set_fields_(dict, [69, false], ["x", "y"])` results in `dict` to be equal to `{x = 69, y = false}`
func set_fields_(obj, values: Array, field_names: Array) -> void: GGI.set_fields_(obj, values, field_names)
var set_fields = funcref(self, "set_fields_")

## Return `on_false`/`on_true` depending on value of `cond`
## @typeParam T {any} Return type
## @param cond {bool} Condition
## @param on_false {T} Value to return when `cond` is `false`
## @param on_true {T} Value to return when `cond` is `true`
## @return {T}
## @example `bool_(true, 0, 1)` returns `1`
## @example `bool_(x == 0, "not zero", "is zero")` returns `"is zero"` when `x` is `0`, otherwise returns `"not zero"`
func bool_(cond: bool, on_false, on_true): return GGI.bool_(cond, on_false, on_true)
var bool__ = funcref(self, "bool_")

## Same as [[bool_]], but `on_false`/`on_true` are functions.
## Only selected function will be called and its return value will be returned from `bool_lazy`.
## @typeParam T {any} Return type
## @param cond {bool} Condition
## @param on_false {FuncLike<T>} Function to call and return its result when `cond` is `false`
## @param on_true {FuncLike<T>} Function to call and return its result when `cond` is `true`
## @return {T}
func bool_lazy_(cond: bool, on_false, on_true): return GGI.bool_lazy_(cond, on_false, on_true)
var bool_lazy = funcref(self, "bool_lazy_")

## Pause specific node. Disables all processing by a given node.
## @param node {Node}  Branch to pause.
## @param value {bool} True means pause, false means resume (unpause)
func pause_one_(node: Node, value: bool) -> void: GGI.pause_one_(node, value)
var pause_one = funcref(self, "pause_one_")

## Pause a branch starting with given node (recursive variant of [[pause_one_]]).
## @param node {Node}  Branch to pause.
## @param value {bool} True means pause, false means resume (unpause)
func pause_(node: Node, value: bool) -> void: GGI.pause_(node, value)
var pause = funcref(self, "pause_")

## Get random direction 2D vector.
func rand_dir2_() -> Vector2: return Vector2(randf() - .5, randf() - .5).normalized()
var rand_dir2 = funcref(self, "rand_dir2_")

## Get random direction 3D vector.
func rand_dir3_() -> Vector3: return Vector3(randf() - .5, randf() - .5, randf() - .5).normalized()
var rand_dir3 = funcref(self, "rand_dir3_")

## Get random 2D vector.
func rand_vec2_(from:= Vector2(-1, -1), to:= Vector2(1, 1)) -> Vector2: return Vector2(rand_float_(from.x, to.x), rand_float_(from.y, to.y))

## Get randomly `1` or `-1`.
func rand_sign_(): return -1 if randf() < .5 else 1
var rand_sign = funcref(self, "rand_sign_")

## Get random `bool`.
func rand_bool_(): return randf() > .5
var rand_bool = funcref(self, "rand_bool_")

## Get random `float` from range [`from`, `to`].
## @example `rand_float_(1, 2)` may return `1.7324`
func rand_float_(from: float, to: float) -> float:
	return from + randf() * (to - from)
var rand_float = funcref(self, "rand_float_")

## Get random `float` from `center` and maximum difference of `radius`.
## @example `rand_float_r_(5)` may return `-2.4271` (random number from -5 to 5)
func rand_float_r_(radius: float, center: float = 0.0) -> float:
	return rand_float_(center - radius, center + radius)
var rand_float_r = funcref(self, "rand_float_")

## Get random `int` from range [`from`, `to`] (including both endpoints).
## @example `rand_int_(1, 5)` may return `5`
func rand_int_(from: int, to: int) -> int:
	return from + randi() % (to - from + 1)
var rand_int = funcref(self, "rand_int_")

## Get random opaque color (alpha set to 1).
## @return {Color}
func randc_() -> Color: return Color(randf(), randf(), randf(), 1)
var randc = funcref(self, "randc_")

## Get random color (alpha is random).
## @return {Color}
func randca_() -> Color: return Color(randf(), randf(), randf(), randf())
var randca = funcref(self, "randca_")

## Get direction between two `Node2D`s.
func dir_to2_(from: Node2D, to: Node2D) -> Vector2: return (to.global_position - from.global_position).normalized()
var dir_to2 = funcref(self, "dir_to2_")

## Get direction between two `Spatial`s.
func dir_to3_(from: Spatial, to: Spatial) -> Vector3: return (to.global_transform.origin - from.global_transform.origin).normalized()
var dir_to3 = funcref(self, "dir_to3_")

## Construct [[Vector2]]. If second parametr is not given, use first parametr twice.
## @param x {int}
## @param y {int | null}
## @example `vec2_(2)` returns `Vector2(2, 2)`
func vec2_(x: int, y = null) -> Vector2:
	if y == null: return Vector2(x, x)
	return Vector2(x, y)
var vec2 = funcref(self, "vec2_")

## Construct [[Vector3]]. If second and third parametr is omitted, use first parametr thrice.
## Only allowed combinations of filled (non-null) arguments are x and x+y+z, otherwise crash ensues.
## @param x {int}
## @param y {int | null}
## @param z {int | null}
## @example `vec3_(2)` returns `Vector3(2, 2, 2)`
func vec3_(x: int, y = null, z = null) -> Vector3:
	if y == null && z == null: return Vector3(x, x, x)
	assert_(y != null && z != null, "expected to either only get first argument, or all arguments. got %s, %s, %s" % [x, y, z])
	return Vector3(x, y, z)
var vec3 = funcref(self, "vec3_")

## Limit given integer number to specified range.
func clampi_(value: int, min_val: int, max_val: int) -> int:
	if value < min_val: return min_val
	if value > max_val: return max_val
	return value
var clampi = funcref(self, "clampi_")

## Get absolute value of an integer (distance from zero).
func absi_(value: int) -> int: return value if value >= 0 else -value
var absi = funcref(self, "absi_")

## Is given array empty?
func is_empty_(arr: Array) -> bool: return GGI.is_empty_(arr)
var is_empty = funcref(self, "is_empty_")

func byte_array_to_texture_(arr: Array, flags:= 0) -> Texture:
	var b_arr = PoolByteArray(arr)
	var img = Image.new()
	img.create_from_data(arr.size(), 1, false, Image.FORMAT_R8, b_arr)
	var tex = ImageTexture.new()
	tex.create_from_image(img, flags)
	return tex
var byte_array_to_texture = funcref(self, "byte_array_to_texture_")

## Read JSON from file. Crash on error.
## @param path {String} Path to JSON file
## @return {Dictionary} Parsed JSON
func read_json_file_or_crash_(path: String, error_tag:= ""):
	var res = read_json_file_or_error_(path)
	if res.error == OK:
		return res.result
	else:
		crash_(("" if error_tag.empty() else ("[" + error_tag + "]")) + res.message)
var read_json_file_or_crash = funcref(self, "read_json_file_or_crash_")

## Read JSON from file.
## @param path {String} Path to JSON file
## @return {Dictionary | null} Parsed JSON
func read_json_file_or_null_(path: String):
	var res = read_json_file_or_error_(path)
	return res.result
var read_json_file_or_null = funcref(self, "read_json_file_or_null_")

## Read JSON from file. Return object describing result.
## Returns dictionary with following fields:
## * `result`             - parsed JSON from file (a `Dictionary`), or `null` on error. Example: `{field = "value"}`
## * `message`            - error message. Example: `"TODO"`
## * `error`              - error number from `file.open` or `JSON.parse`
## * `error_line`         - error line from `JSON.parse` error
## * `error_string`       - error string from `JSON.parse` error
## @param path {String} Path to JSON file
## @return {Dictionary}
func read_json_file_or_error_(path: String) -> Dictionary:
	var file = File.new()
	var open_res = file.open(path, File.READ)
	if open_res != OK:
		return {message = "failed to open JSON file \"%s\": %s" % [path, open_res], error = open_res, result = null}
	var res = JSON.parse(file.get_as_text())
	if res.error != OK:
		return {
			message = "failed to parse JSON file - %s: %s" % [res.error_line, res.error_string],
			error = res.error,
			error_line = res.error_line,
			error_string = res.error_string,
			result = null
		}
	file.close()
	return {result = res.result, error = OK}
var read_json_file_or_error = funcref(self, "read_json_file_or_error_")

## Is code running inside editor (in `tool` mode)?
var in_editor: bool setget , get_in_editor_
func get_in_editor_() -> bool: return Engine.editor_hint
var get_in_editor = funcref(self, "get_in_editor_")

func draw_cross_(obj: CanvasItem, center: Vector2, radius: float, color:= Color.cyan, width:= 1.0) -> void:
	var ox:= Vector2(radius, 0); var oy:= Vector2(0, radius)
	obj.draw_line(center - ox, center + ox, color, width)
	obj.draw_line(center - oy, center + oy, color, width)
var draw_cross = funcref(self, "draw_cross_")

func draw_ellipse_(obj: CanvasItem, center: Vector2, radius: Vector2, color:= Color.cyan, width:= 1.0, filled:= true, points_count:= 32) -> void:
	var points:= []
	var step:= 360.0 / points_count
	var d:= 0.0
	# TODO: optimize, axis-aligned ellipse is 4 symetrical
	var points_count_processed = points_count if filled else points_count + 3
	for i in range(points_count_processed):
		points.push_back(Vector2(radius.x * cos(deg2rad(d)), radius.y * sin(deg2rad(d))) + center)
		d += step
	if filled:
		obj.draw_polygon(points, replicate_(color, points_count))
	else:
		points.push_back(points[0])
		obj.draw_polyline(points, color, width)
var draw_ellipse = funcref(self, "draw_ellipse_")

func draw_arrow_(obj: CanvasItem, pos_from: Vector2, pos_to: Vector2, color:= Color.cyan, width:= 1.0, arrow_size:= 10.0, arrow_angle:= PI / 4, point_fix_size:= 2.0) -> void:
	obj.draw_line(pos_from, pos_to, color, width)
	var back_line:= pos_from.direction_to(pos_to) * arrow_size

	var a1_start:= pos_to
	var a1_end:= pos_to + back_line.rotated(PI + arrow_angle)
	a1_start -= a1_start.direction_to(a1_end) * width / point_fix_size
	obj.draw_line(a1_start, a1_end, color, width)

	var a2_start:= pos_to
	var a2_end:= pos_to + back_line.rotated(PI - arrow_angle)
	a2_start -= a2_start.direction_to(a2_end) * width / point_fix_size
	obj.draw_line(a2_start, a2_end, color, width)

## Load resource relative to directory of given script
func load_relative_(script: Node, path: String):
	return load("%s/%s" % [script.get_script().get_path().get_base_dir(), path])
var load_relative = funcref(self, "load_relative_")

## Get progress of current animation in AnimatedSprite
## @return {float} Progress of animation, interval [0, 1)
func anim_get_progress_(anim: AnimatedSprite) -> float:
	var frame_count = anim.frames.get_frame_count(anim.animation)
	return float(anim.frame) / frame_count

var debug_draw_2d: GGDebugDraw2D setget , _get_debug_draw_2d

func _get_debug_draw_2d() -> GGDebugDraw2D:
	if !debug_draw_2d:
		var i = load_relative_(self, "GGDebugDraw2D.tscn").instance()
		get_tree().root.add_child(i)
		debug_draw_2d = i
	return debug_draw_2d

## Contruct a new dictionary from given list of fields of a given object/dictionary.
## @param obj {Object | Dictionary}
## @param fields {Array<String>}
## @return {Dictionary}
func pick_(obj, fields: Array) -> Dictionary:
	var r = {}
	for k in fields: r[k] = get_fld_(obj, k)
	return r
var pick = funcref(self, "pick_")

## Assign all fields from `source` to `target`.
## @param target {Object | Dictionary}
## @return {void}
func assign_fields_(target, source) -> void:
	for k in keys_(source):
		target[k] = source[k]
var assign_fields = funcref(self, "assign_fields_")

## Create a new dictionary by copying all fields except those in given `fields` parameter.
## @param obj {Object | Dictionary}
## @param fields {Array<String>}
## @return {Dictionary}
func omit_(obj, fields: Array) -> Dictionary:
	var r = {}
	for k in keys_(obj):
		if !fields.has(k):
			r[k] = get_fld_(obj, k)
	return r
var omit = funcref(self, "omit_")

const _input_event_key_fields:= ["scancode", "physical_scancode", "alt", "shift", "control", "meta", "command"]
const _input_event_joypad_button_fields:= ["button_index"]
const _input_event_joypad_motion_fields:= ["axis", "axis_value"]
const _input_event_mouse_button_fields:= ["button_index"]

## Convert InputEvent to Dictionary.
## Supports: InputEventKey, InputEventJoypadButton, InputEventJoypadMotion and InputEventMouseButton
## @param e {InputEvent | null}
## @return {Dictionary | null}
func input_event_to_dict_(e: InputEvent):
	if e == null: return null
	match e.get_class():
		"InputEventKey":
			return merge_(
				pick_(e, _input_event_key_fields),
				{ type = "key" }
			)
		"InputEventJoypadButton":
			return merge_(
				pick_(e, _input_event_joypad_button_fields),
				{ type = "joypadButton" }
			)
		"InputEventJoypadMotion":
			return merge_(
				pick_(e, _input_event_joypad_motion_fields),
				{ type = "joypadMotion" }
			)
		"InputEventMouseButton":
			return merge_(
				pick_(e, _input_event_mouse_button_fields),
				{ type = "mouseButton" }
			)
		_: return null
var input_event_to_dict = funcref(self, "input_event_to_dict_")

## Convert Dictionary to InputEvent (see `input_event_to_dict_`).
## @param x {Dictionary | null}
## @return {InputEvent | null}
func dict_to_input_event_(x):
	if x == null: return null
	var type = get_fld_or_null_(x, "type")
	if type == null: return null
	var data = omit_(x, ["type"])
	match type:
		"key":
			var r:= InputEventKey.new()
			assign_fields_(r, data)
			return r
		"joypadButton":
			var r:= InputEventJoypadButton.new()
			assign_fields_(r, data)
			return r
		"joypadMotion":
			var r:= InputEventJoypadMotion.new()
			assign_fields_(r, data)
			return r
		"mouseButton":
			var r:= InputEventMouseButton.new()
			assign_fields_(r, data)
			return r
var dict_to_input_event = funcref(self, "dict_to_input_event_")

var fmt_input_event_tr_prefix:= "gg.controls."

## Format `InputEvent`. Formatting strings and translation function can be customized.
## Optional options:
## * `translate_func` {FuncLike<String, String>} - translation function
## * `fmt_str_key` {String}                      - formatting string for keyboard keys
## * `fmt_str_joypad_button` {String}            - formatting string for gamepad buttons
## * `fmt_str_joypad_motion` {String}            - formatting string for gamepad axis
## @param e {InputEvent}
## @param options {Dictionary}
func fmt_input_event_(e: InputEvent, options:= {}) -> String:
	var opts = merge_({
		translate_func = "x => tr(x)",
		fmt_str_key = "{tr_key} {key}",
		fmt_str_joypad_button = "{tr_joypad_button} {button_number}",
		fmt_str_joypad_motion = "{tr_joypad_axis} {axis_number} {tr_sign}",
		fmt_str_mouse_button = "{tr_mouse_button} {tr_mouse_button_number}"
	}, options)
	var t = F_(opts.translate_func)
	match e.get_class():
		"InputEventKey":
			var text = e.as_text()
			# workaround of Godot returning empty string for physical keys (confimed broken in 3.4)
			if text == "" && e.scancode == 0:
				var tmp_e:= e.duplicate()
				tmp_e.scancode = tmp_e.physical_scancode
				text = tmp_e.as_text()
			return opts.fmt_str_key.format({
				tr_key = t.call_func(fmt_input_event_tr_prefix + "key"),
				key = text
			})
		"InputEventJoypadButton":
			return opts.fmt_str_joypad_button.format({
				tr_joypad_button = t.call_func(fmt_input_event_tr_prefix + "joypadButton"), button_number = e.button_index
			})
		"InputEventJoypadMotion":
			return opts.fmt_str_joypad_motion.format({
				tr_joypad_axis = t.call_func(fmt_input_event_tr_prefix + "joypadAxis"),
				axis_number = e.axis,
				tr_sign = t.call_func(fmt_input_event_tr_prefix + "joypadAxis." + ("plus" if e.axis_value > 0 else "minus"))
			})
		"InputEventMouseButton":
			var t_key_mouse_button_number = fmt_input_event_tr_prefix + "mouseButton." + str(e.button_index)
			var tr_mouse_button_number = t.call_func(t_key_mouse_button_number)
			if tr_mouse_button_number == t_key_mouse_button_number: tr_mouse_button_number = str(e.button_index)
			return opts.fmt_str_mouse_button.format({
				tr_mouse_button = t.call_func(fmt_input_event_tr_prefix + "mouseButton"),
				tr_mouse_button_number = tr_mouse_button_number,
			})
		_: return t.call_func("unknown")
var fmt_input_event = funcref(self, "fmt_input_event_")

## Shift given color by specified amount.
## @param c {Color}
## @param n {float} In range of [-1 .. 1]. If you have degrees then divide it by 360, e.g. `60.0 / 360`.
## @example `GG.shift_hue_(Color.red, 0.5)` returns equivalent of `Color.cyan`
func shift_hue_(c: Color, n: float) -> Color:
	var h:= c.h + n
	if h < 0: h += 1
	return c.from_hsv(h, c.s, c.v)
var shift_hue = funcref(self, "shift_hue_")

## Print given data, optionally with a tag. Returns given data.
## Useful for debuging purposes, e.g. in pipe.
func debug_(x, tag:= ""): return GGI.debug_(x, tag)
var debug = funcref(self, "debug_")

func print_(x): print(x)
var print__ = funcref(self, "print_")

# TODO:
# format (`%` operator)
# partial ap. for more parameters?
# span/break
# ? compose
# ? obj_to_dict
# ? flatten_deep

# ----------------------------------------------------------------------------------------------------------------------
# See GGArray for docs for following functions.

func size_(x): return GGI.size_(x)
var size = funcref(self, "size_")

func head_(arr: Array): return GGI.head_(arr)
var head = funcref(self, "head_")

func head_or_null_(arr: Array): return GGI.head_or_null_(arr)
var head_or_null = funcref(self, "head_or_null_")

func last_(arr: Array): return GGI.last_(arr)
var last = funcref(self, "last_")

func last_or_null_(arr: Array): return GGI.last_or_null_(arr)
var last_or_null = funcref(self, "last_or_null_")

func tail_(arr: Array): return GGI.tail_(arr)
var tail = funcref(self, "tail_")

func init_(arr: Array): return GGI.init_(arr)
var init = funcref(self, "init_")

func sort_(arr: Array) -> Array: return GGI.sort_(arr)
var sort = funcref(self, "sort_")

func sort_by_(arr: Array, f: FuncRef) -> Array: return GGI.sort_by_(arr, f)
var sort_by = funcref(self, "sort_by_")

func sort_by_fld_(arr: Array, field_name: String) -> Array: return GGI.sort_by_fld_(arr, field_name)
var sort_by_fld = funcref(self, "sort_by_fld_")

func sort_with_(arr: Array, map_f: FuncRef) -> Array: return GGI.sort_with_(arr, map_f)
var sort_with = funcref(self, "sort_with_")

func zip_(arr_a: Array, arr_b: Array) -> Array: return GGI.zip_(arr_a, arr_b)
var zip = funcref(self, "zip_")

func zip_with_index_(a: Array) -> Array: return GGI.zip_with_index_(a)
var zip_with_index = funcref(self, "zip_with_index_")

func map_(arr: Array, f, ctx = GGI._EMPTY_CONTEXT) -> Array: return GGI.map_(arr, f, ctx)
var map = funcref(self, "map_")

func map_with_index_(arr: Array, f, ctx = GGI._EMPTY_CONTEXT) -> Array: return GGI.map_with_index_(arr, f, ctx)
var map_with_index = funcref(self, "map_with_index_")

func for_each_(arr: Array, f, ctx = GGI._EMPTY_CONTEXT) -> void: GGI.for_each_(arr, f, ctx)
var for_each = funcref(self, "for_each_")

func join_(array: Array, delim: String = "", before: String = "", after: String = "") -> String:
	return GGI.join_(array, delim, before, after)
var join = funcref(self, "join_")

func filter_(arr: Array, f, ctx = GGI._EMPTY_CONTEXT) -> Array: return GGI.filter_(arr, f, ctx)
var filter = funcref(self, "filter_")

func find_(arr: Array, predicate, ctx = GGI._EMPTY_CONTEXT): return GGI.find_(arr, predicate, ctx)
var find = funcref(self, "find_")

func find_or_null_(arr: Array, predicate, ctx = GGI._EMPTY_CONTEXT): return GGI.find_or_null_(arr, predicate, ctx)
var find_or_null = funcref(self, "find_or_null_")

func find_index_or_null_(arr: Array, predicate, ctx = GGI._EMPTY_CONTEXT): return GGI.find_index_or_null_(arr, predicate, ctx)
var find_index_or_null = funcref(self, "find_index_or_null_")

func find_index_(arr: Array, predicate, ctx = GGI._EMPTY_CONTEXT): return GGI.find_index_(arr, predicate, ctx)
var find_index = funcref(self, "find_index_")

func partition_(arr: Array, predicate, ctx = GGI._EMPTY_CONTEXT) -> Array: return GGI.partition_(arr, predicate, ctx)
var partition = funcref(self, "partition_")

func foldl_(arr: Array, f, zero, ctx = GGI._EMPTY_CONTEXT): return GGI.foldl_(arr, f, zero, ctx)
var foldl = funcref(self, "foldl_")

# flatten Array of Arrays into Array (e.g. [[1, 2], [3]] -> [1, 2, 3])
func flatten_(xs: Array) -> Array: return GGI.flatten_(xs)
var flatten = funcref(self, "flatten_")

# take first n items from array
func take_(xs: Array, n: int) -> Array: return GGI.take_(xs, n)
var take = funcref(self, "take_")

# take last n items from array
func take_right_(xs: Array, n: int) -> Array: return GGI.take_right_(xs, n)
var take_right = funcref(self, "take_right_")

func take_while_(xs: Array, p) -> Array: return GGI.take_while_(xs, p)
var take_while = funcref(self, "take_while_")

# drop first n items from array
func drop_(xs: Array, n: int) -> Array: return GGI.drop_(xs, n)
var drop = funcref(self, "drop_")

# drop last n items from array
func drop_right_(xs: Array, n: int) -> Array: return GGI.drop_right_(xs, n)
var drop_right = funcref(self, "drop_right_")

func drop_while_(xs: Array, pred) -> Array: return GGI.drop_while_(xs, pred)
var drop_while = funcref(self, "drop_while_")

func drop_while_right_(xs: Array, pred) -> Array: return GGI.drop_while_right_(xs, pred)
var drop_while_right = funcref(self, "drop_while_right_")

# reverse (invert) array
func reverse_(xs: Array) -> Array: return GGI.reverse_(xs)
var reverse = funcref(self, "reverse_")

func max_(xs: Array): return GGI.max_(xs)
var max__ = funcref(self, "max_")

func min_(xs: Array): return GGI.min_(xs)
var min__ = funcref(self, "min_")

func average_(xs: Array): return GGI.average_(xs)
var average = funcref(self, "average_")

func sum_(xs: Array) -> int: return GGI.sum_(xs)
var sum = funcref(self, "sum_")

func product_(xs: Array) -> int: return GGI.product_(xs)
var product = funcref(self, "product_")

# filter out value_to_omit from array
func without_(xs: Array, value_to_omit) -> Array: return GGI.without_(xs, value_to_omit)
var without = funcref(self, "without_")

# filter out null values
func compact_(xs: Array) -> Array: return GGI.compact_(xs)
var compact = funcref(self, "compact_")

func all_(xs: Array, p) -> bool: return GGI.all_(xs, p)
var all = funcref(self, "all_")

func any_(xs: Array, p) -> bool: return GGI.any_(xs, p)
var any = funcref(self, "any_")

func append_(xs: Array, y) -> Array: return GGI.append_(xs, y)
var append = funcref(self, "append_")

func prepend_(xs: Array, y) -> Array: return GGI.prepend_(xs, y)
var prepend = funcref(self, "prepend_")

func concat_(xs: Array, other: Array) -> Array: return GGI.concat_(xs, other)
var concat = funcref(self, "concat_")

func concat_left_(xs: Array, other: Array) -> Array: return GGI.concat_left_(xs, other)
var concat_left = funcref(self, "concat_left_")

func group_with_(xs: Array, f) -> Array: return GGI.group_with_(xs, f)
var group_with = funcref(self, "group_with_")

func transpose_(xs: Array) -> Array: return GGI.transpose_(xs)
var transpose = funcref(self, "transpose_")

func intersect_(xs: Array, ys: Array) -> Array: return GGI.intersect_(xs, ys)
var intersect = funcref(self, "intersect_")

func union_(xs: Array, ys: Array) -> Array: return GGI.union_(xs, ys)
var union = funcref(self, "union_")

func difference_(xs: Array, ys: Array) -> Array: return GGI.difference_(xs, ys)
var difference = funcref(self, "difference_")

func nub_(xs: Array) -> Array: return GGI.nub_(xs)
var nub = funcref(self, "nub_")

func uniq_(xs: Array) -> Array: return GGI.uniq_(xs)
var uniq = funcref(self, "uniq_")

func elem_(arr: Array, x) -> bool: return GGI.elem_(arr, x)
var elem = funcref(self, "elem_")

func not_elem_(arr: Array, x) -> bool: return GGI.not_elem_(arr, x)
var not_elem = funcref(self, "not_elem_")

func valid_index_(arr: Array, x) -> bool: return GGI.valid_index_(arr, x)
var valid_index = funcref(self, "valid_index_")
