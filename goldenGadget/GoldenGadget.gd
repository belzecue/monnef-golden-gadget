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
# version: 0.1.0 (2019-2020)
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
#   func F(f): return GG.F_(f)
#
# All examples presume "imports" above are present and autoloading is configured.
# Nice examples are located in GGTests script at the end.

tool
extends Node

var GGI = preload("GGInternal.gd").new()

func _ready() -> void:
	_words_splitter.compile("[^\\s]+")
	_lines_splitter.compile("[^\n]+")

# main wrapper function
func arr(array) -> GGArray:
	# TODO: support string via to_utf8?
	return GGArray.new(array)

func with_ctx(f: FuncRef, ctx) -> CtxFRef1: return CtxFRef1.new(f, ctx)

func with_ctx2(f: FuncRef, ctx) -> CtxFRef2: return CtxFRef2.new(f, ctx)

# ----------------------------------------------------------------------------------------------------------------------

# utility functions

func assert_(cond: bool, msg: String) -> void: GGI.assert_(cond, msg)
var assert__ = funcref(self, "assert_")

func crash_(msg: String) -> void: GGI.crash_(msg)
var crash = funcref(self, "crash_")

# logical and
func l_and_(x: bool, y: bool) -> bool: return x && y
var l_and = funcref(self, "l_and_")

# logical or
func l_or_(x: bool, y: bool) -> bool: return x || y
var l_or = funcref(self, "l_or_")

# adds two values
func add_(x: int, y: int) -> int: return x + y
var add = funcref(self, "add_")

# subtracts second argument from first
func subtract_(x: int, y: int) -> int: return x - y
var subtract = funcref(self, "subtract_")

# and operation performed on array of bools
func a_and_(x: Array) -> bool: return arr(x).foldl_fn(l_and, true)
var a_and = funcref(self, "a_and_")

# or operation performed on array of bools
func a_or_(x: Array) -> bool: return arr(x).foldl_fn(l_or, false)
var a_or = funcref(self, "a_or_")

# shallow equality check
func eq_(a, b) -> bool: return GGI.eq_(a, b)
var eq = funcref(self, "eq_")

# shallow not-equality check
func neq_(a, b) -> bool: return !GGI.eq_(a, b)
var neq = funcref(self, "neq_")

# deep equality check
func eqd_(a, b) -> bool: return GGI.eqd_(a, b)
var eqd = funcref(self, "eqd_")

# determines equality (==) of a field (given name and value in args parameter) in object (first parameter)
func eq_field_(object, args) -> bool:
	if object && args.name in object: return object[args.name] == args.value
	return false
var eq_field = funcref(self, "eq_field_")

func call_spread_(f: FuncRef, arr: Array): return GGI.call_spread_(f, arr)
var call_spread = funcref(self, "call_spread_")

func snake_to_pascal_case_(x: String) -> String: return arr(x.split("_")).map_fn(capitalize).join("")
var snake_to_pascal_case = funcref(self, "snake_to_pascal_case_")

func capitalize_(x: String) -> String:
	if x.length() == 0: return ""
	return capitalize_first_(x[0]) + x.substr(1, x.length() - 1).to_lower()
var capitalize = funcref(self, "capitalize_")

func capitalize_first_(x: String) -> String:
	if x.length() == 0: return ""
	var arr = x.to_utf8()
	return x[0].to_upper() + PoolByteArray(tail_(arr)).get_string_from_utf8()
var capitalize_first = funcref(self, "capitalize_first_")

func noop1_(x) -> void: pass
var noop1 = funcref(self, "noop1_")

func noop2_(x, y) -> void: pass
var noop2 = funcref(self, "noop2_")

func noop3_(x, y, z) -> void: pass
var noop3 = funcref(self, "noop3_")

func noop4_(x, y, z, a) -> void: pass
var noop4 = funcref(self, "noop4_")

func multiply_(x, y): return x * y
var multiply = funcref(self, "multiply_")

func modulo_(x, y):
	if x is float and y is float: return fmod(x, y)
	elif x is int and y is int: return x % y
var modulo = funcref(self, "modulo_")

func inc_(x): return x + 1
var inc = funcref(self, "inc_")

func dec_(x): return x - 1
var dec = funcref(self, "dec_")

func negate_num_(x): return -x
var negate_num = funcref(self, "negate_num_")

func negate_(x: bool) -> bool: return !x
var negate = funcref(self, "negate_")

# obj is either Dictionary (created via {}) or Object (e.g. a custom  class)
# throws on missing field
func get_fld_(obj, field_name: String): return GGI.get_fld_(obj, field_name)
var get_fld = funcref(self, "get_fld_")

# obj is either Dictionary or Object
# returns default when field is not found
func get_fld_or_else_(obj, field_name: String, default): return GGI.get_fld_or_else_(obj, field_name, default)
var  get_fld_or_else = funcref(self, "get_fld_or_else_")

# obj is either Dictionary or Object
# returns null when field is not found
func get_fld_or_null_(obj, field_name: String): return GGI.get_fld_or_null_(obj, field_name)
var  get_fld_or_null = funcref(self, "get_fld_or_null_")

# get first item in pair
func fst_(pair: Array): return GGI.fst_(pair)
var fst = funcref(self, "fst_")

# get second item in pair
func snd_(pair: Array): return GGI.snd_(pair)
var snd = funcref(self, "snd_")

# compile script and return new instance of it
func compile_script_(src: String): return GGI.compile_script_(src)
var compile_script = funcref(self, "compile_script_")

# compile script with one function, instantiate script and return funcref of the function
func compile_function_(expr: String) -> FuncRef: return GGI.function_(expr)
var compile_function = funcref(self, "compile_function_")

# create function-like object depending on type of f
# FuncRef - pass same value
# String  - compiles function and returns its FuncRef
#           "x => x + 1" ~ get FuncRef of "func f(x): return x + 1"
# Array   - partial application (creates CtxFRef1)
#           ["x, y => x + y", 1] which is functionally equivalent to "x => x + 1"
func F_(f): return GGI.f_like_to_func(f)

# get keys of Dictionary or Object. returns Array of Strings
func keys_(obj):
	if obj == null: return null
	var is_dict = obj is Dictionary
	var is_obj = obj is Object
	GGI.assert_(is_dict || is_obj, "keys function expects Object or Dictionary")
	return obj.keys() if is_dict else arr(obj.get_property_list()).map_fld("name").val
var keys = funcref(self, "keys_")

# get key by given value, supports Dictionary and Object (custom classes). null if not found.
func key_from_val_(obj, val):
	for key in keys_(obj):
		if key in obj:
			var curr_val = obj[key]
			if typeof(curr_val) == typeof(val) && curr_val == val: return key
	return null
var key_from_val = funcref(self, "key_from_val_")

# call method when method exists and pass result, otherwise null
func ap_if_defined_(obj, method_name, args: Array):
	if obj && obj.has_method(method_name):
		return call_spread_(funcref(obj, method_name), args)
	return null
var ap_if_defined = funcref(self, "ap_if_defined_")

# get random item from an array
# throws on empty array
func sample_(arr: Array): return GGI.sample_(arr)
var sample = funcref(self, "sample_")

# get random item from an array
# returns null for empty array
func sample_or_null_(arr: Array): return GGI.sample_or_null_(arr)
var sample_or_null = funcref(self, "sample_or_null_")

# format DateTime (if no provided current will be used) in following format: YYYY-MM-DD--HH-MM-SS
# example: 2019-12-19--13-03-18
func format_datetime_(date = null) -> String:
	if !date: date = OS.get_datetime()
	return "%s-%02d-%02d--%02d-%02d-%02d" % [date.year, date.month, date.day, date.hour, date.minute, date.second]
var format_datetime = funcref(self, "format_datetime_")

# save screenshot
# optinally takes an options dictionary:
# quiet          - when true silence all console output
# dir            - overrides screenshot directory (default is "user://screenshots", expanded for example like this: "/home/user/.local/share/godot/app_userdata/project/screenshots")
# returns dictionary with following fields:
# dir            - screenshot directory. Example: "/home/user/.local/share/godot/app_userdata/project/screenshots"
# result         - Error code, use OK constant to test if taking screenshot was successful. Example: 12
# stage          - last reached stage, either "create_dir" or "save". Example: "save"
# file_name      - image file name (without directory). Example: "2019-12-19--13-20-35.png"
# full_file_name - full path to screenshot file. Example: "/home/user/.local/share/godot/app_userdata/project/screenshots/2019-12-19--13-20-35.png"
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

func delete_children_(parent: Node) -> void:
	for c in parent.get_children(): c.queue_free()
var delete_children = funcref(self, "delete_children_")

# safer `get_node` alternative which will crash when parent, path or node are null/empty
func get_node_or_crash_(parent: Node, path: NodePath) -> Node:
	assert_(path != null && !path.is_empty(), "missing path")
	assert_(parent != null, "missing parent node")
	var node = parent.get_node(path)
	assert_(node != null, "missing child")
	return node
var get_node_or_crash = funcref(self, "get_node_or_crash_")

# create Timer node, connect timeout signal to the method and start
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

func words_raw_(x: String) -> Array: return words_(x).val
var words_raw = funcref(self, "words_raw_")

# split string to array of words (e.g. "a  b" -> ["a", "b"])
func words_(x: String) -> GGArray: return arr(_words_splitter.search_all(x)).map("x => x.strings[0]")
var words = funcref(self, "words_")

# join words array to string (e.g. ["a", "b"] -> "a b")
func unwords_(xs: Array) -> String: return arr(xs).join(" ")
var unwords = funcref(self, "unwords_")

var _lines_splitter:= RegEx.new()

func lines_raw_(x: String) -> Array: return lines_(x).val
var lines_raw = funcref(self, "lines_raw_")

# split string to lines (e.g. "a\n\nb" -> ["a", "b"])
func lines_(x: String) -> GGArray: return arr(_lines_splitter.search_all(x)).map("x => x.strings[0]")
var lines = funcref(self, "lines_")

# join lines to string (e.g. ["a", "b"] -> "a\nb")
func unlines_(xs: Array) -> String: return arr(xs).join("\n")
var unlines = funcref(self, "unlines_")

# calls first function with given input then sequentially takes results from a previous function and passes to a next
# supports lambdas (string, e.g. "x => x + 1") and partial application of 2 arg. functions (e.g. [GG.take, 2])
# options dictionary fields:
#   debug - if true then input, middle values and result is printed
func pipe_(input, functions: Array, options = null): return GGI.pipe_(input, functions, options)
var pipe = funcref(self, "pipe_")

# identity
func id_(x): return x
var id = funcref(self, "id_")

# call function-like f with x, return x (ignore return value of f)
func tap_(x, f): return GGI.tap_(x, f)
var tap = funcref(self, "tap_")

# ----------------------------------------------------------------------------------------------------------------------
# see GGArray

func size_(x): return GGI.size_(x)
var size = funcref(self, "size_")

func head_(arr: Array): return GGI.head_(arr)
var head = funcref(self, "head_")

func last_(arr: Array): return arr[arr.size() - 1] if arr.size() > 0 else null
var last = funcref(self, "last_")

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

func map_(arr: Array, f, ctx = GGI._EMPTY_CONTEXT) -> Array: return GGI.map_(arr, f, ctx)
var map = funcref(self, "map_")

func filter_(arr: Array, f, ctx = GGI._EMPTY_CONTEXT) -> Array: return GGI.filter_(arr, f, ctx)
var filter = funcref(self, "filter_")

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

# drop first n items from array
func drop_(xs: Array, n: int) -> Array: return GGI.drop_(xs, n)
var drop = funcref(self, "drop_")

# drop last n items from array
func drop_right_(xs: Array, n: int) -> Array: return GGI.drop_right_(xs, n)
var drop_right = funcref(self, "drop_right_")

# reverse (invert) array
func reverse_(xs: Array) -> Array: return GGI.reverse_(xs)
var reverse = funcref(self, "reverse_")

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

# TODO:
# ? compose, flow
# ? flip
# ? obj_to_dict
# ? flatten_deep
