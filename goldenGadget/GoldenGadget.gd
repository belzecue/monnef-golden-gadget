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
# author: monnef
# version: 0.0.2
#
# setup:
#  1) download source code
#  2) unpack and copy "goldenGadget" directory to your project
#  3) Project -> Project Settings -> AutoLoad -> add this script as "GG" with singleton enabled
#
# recommended "imports":
#   func G(arr) -> GGArray: return GG.arr(arr)
#   func F(f: String) -> FuncRef: return GG.function_(f)
#
# All examples presume "imports" above are present and autoloading is configured.
# Nice examples are located in GGTests script at the end.

extends Node

var GGI = preload("GGInternal.gd").new()

# main wrapper function
func arr(array) -> GGArray: return GGArray.new(array)

func with_ctx(f: FuncRef, ctx) -> CtxFRef1: return CtxFRef1.new(f, ctx)

func with_ctx2(f: FuncRef, ctx) -> CtxFRef2: return CtxFRef2.new(f, ctx)

# ----------------------------------------------------------------------------------------------------------------------

# utility functions

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

# deep equality check
func eqd_(a, b) -> bool: return GGI.eqd_(a, b)
var eqd = funcref(self, "eqd_")

# determines equality (==) of a field (given name and value in args parameter) in object (first parameter)
func eq_field_(object, args) -> bool:
	if object && args.name in object: return object[args.name] == args.value
	return false
var eq_field = funcref(self, "eq_field_")

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

func call_spreaded_(f: FuncRef, arr: Array):
	match arr.size():
		0: return f.call_func()
		1: return f.call_func(arr[0])
		2: return f.call_func(arr[0], arr[1])
		3: return f.call_func(arr[0], arr[1], arr[2])
		4: return f.call_func(arr[0], arr[1], arr[2], arr[3])
		5: return f.call_func(arr[0], arr[1], arr[2], arr[3], arr[4])
		6: return f.call_func(arr[0], arr[1], arr[2], arr[3], arr[4], arr[5])
		7: return f.call_func(arr[0], arr[1], arr[2], arr[3], arr[4], arr[5], arr[6])
		8: return f.call_func(arr[0], arr[1], arr[2], arr[3], arr[4], arr[5], arr[6], arr[7])
		9: return f.call_func(arr[0], arr[1], arr[2], arr[3], arr[4], arr[5], arr[6], arr[7], arr[8])
		10: return f.call_func(arr[0], arr[1], arr[2], arr[3], arr[4], arr[5], arr[6], arr[7], arr[8], arr[9])
		_: push_error("call_spreaded doesn't support this number of arguments")
var call_spreaded = funcref(self, "call_spreaded_")

func snake_to_pascal_case_(x: String) -> String: return arr(x.split("_")).map_fn(capitalize).join("")
var snake_to_pascal_case = funcref(self, "snake_to_pascal_case_")

func capitalize_(x: String) -> String: return x.capitalize()
var capitalize = funcref(self, "capitalize_")

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
func get_fld_(obj, field_name: String): return GGI.get_fld_(obj, field_name)
var get_fld = funcref(self, "get_fld_")

func fst_(pair: Array): return GGI.fst_(pair)
var fst = funcref(self, "fst_")

func snd_(pair: Array): return GGI.snd_(pair)
var snd = funcref(self, "snd_")

func compile_script_(src: String): return GGI.compile_script_(src)
var compile_script = funcref(self, "compile_script_")

func function_(expr: String) -> FuncRef: return GGI.function_(expr)
var function = funcref(self, "function_")

# TODO:
# eq, neq
# words, unwords, lines, unlines
# ? product, sum
# ? compose, flow
# ? flip
