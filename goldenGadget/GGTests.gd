extends Node

class_name GGTests

func G(arr) -> GGArray: return GG.arr(arr)
func F(f: String) -> FuncRef: return GG.function_(f)

const t = true
const f = false

func run() -> void:
	var start = OS.get_unix_time()
	_test_wrap()
	_test_map()
	_test_join()
	_test_filter()
	_test_fold()
	_test_pipe()
	_test_utils()
	_test_array()
	_test_call_spreaded()
	_test_strings()
	_test_math()
	_test_bool()
	_test_sort()
	_test_object()
	_test_pairs()
	_test_compile_script()
	_test_lambdas()
	_test_examples()
	_test_short_example()
	var stop = OS.get_unix_time()
	print("[GG] Golden Gadget Tests: SUCCESS (%fs; %s - %s)" % [(stop - start), start, stop])

func _assert(actual, expected) -> void:
	if !GG.eqd_(actual, expected):
		print("Expected: %s, Actual: %s" % [expected, actual])
		assert(false)

# args - arguments for function, last item is expected result
func _test_func(args, op) -> void:
	var actual = GG.call_spreaded_(op, GG.init_(args))
	var expected = GG.last_(args)
	_assert(actual, expected)

func _test_func_a(cases: Array, op: FuncRef) -> void:
	G(cases).map_out_mtd(self, "_test_func", op).noop()

func _test_arr_func(args, func_name) -> void:
	var input_arr = GG.head_(args)
	var f_args = GG.tail_(GG.init_(args))
	var expected = GG.last_(args)
	var g_arr = G(input_arr)
	var actual = GG.call_spreaded_(funcref(g_arr, func_name), f_args)
	_assert(actual, expected)

func _test_arr_func_a(cases: Array, func_name) -> void:
	G(cases).map_out_mtd(self, "_test_arr_func", func_name).noop()

func _test_arr_wrapped_func(args, func_name) -> void:
	var input_arr = GG.head_(args)
	var orig_arr = input_arr.duplicate()
	var f_args = GG.tail_(GG.init_(args))
	var expected = GG.last_(args)
	var g_arr = G(input_arr)
	var actual = GG.call_spreaded_(funcref(g_arr, func_name), f_args).val
	_assert(actual, expected)
	_assert(input_arr, orig_arr)

func _test_arr_wrapped_func_a(cases: Array, func_name) -> void:
	G(cases).map_out_mtd(self, "_test_arr_wrapped_func", func_name).noop()

# ----------------------------------------------------------------------------------------------------------------------

func _test_wrap() -> void:
	assert(G([]).val == [])
	assert(G([1, 2]).val == [1, 2])
	assert(G([1, 2]).size == 2)

# ----------------------------------------------------------------------------------------------------------------------

func _test_map() -> void:
	# map_fn
	assert(G([]).map_fn(funcref(self, "_get_x")).val == [])
	assert(G([{x = 1}]).map_fn(funcref(self, "_get_x")).val == [1])
	assert(G([{x = 1}, {a = 4, x = 2}]).map_fn(funcref(self, "_get_x")).val == [1, 2])

	# map_fn with ctx
	assert(G([{x = 1}, {a = 4, x = 2}]).map_fn(GG.with_ctx(funcref(self, "_get_x_and_add"), 10)).val == [11, 12])
	assert(G([{x = 1}, {a = 4, x = 2}]).map_fn(funcref(self, "_get_x_and_add"), 10).val == [11, 12])

	# map
	assert(G([{x = 1}]).map(funcref(self, "_get_x")).val == [1])
	assert(G([{x = 1}]).map("x => x.x").val == [1])

	# map with ctx
	assert(G([{x = 1}, {a = 4, x = 2}]).map(funcref(self, "_get_x_and_add"), 10).val == [11, 12])
	assert(G([{x = 1}, {a = 4, x = 2}]).map("x, ctx => x.x + ctx", 10).val == [11, 12])

	# map_out_mtd
	assert(G([]).map_out_mtd(self, "_get_x").val == [])
	assert(G([{x = 2}]).map_out_mtd(self, "_get_x").val == [2])
	assert(G([{x = 2}, {a = 4, x = 2}]).map_out_mtd(self, "_get_x").val == [2, 2])

	# map_out_mtd with ctx
	assert(G([{x = 2}]).map_out_mtd(self, "_get_x_and_add", 10).val == [12])

	# map_in_mtd
	assert(G([]).map_in_mtd("get_x").val == [])
	assert(G([T0.new(3)]).map_in_mtd("get_x").val == [3])
	assert(G([T0.new(3), T0.new(4), T0.new(5)]).map_in_mtd("get_x").val == [3, 4, 5])

	# map_in_mtd with ctx
	assert(G([T0.new(3)]).map_in_mtd("get_x_and_add", 10).val == [13])

func _get_x(x): return x.x

func _get_x_and_add(x, y): return x.x + y

class T0:
	var _x: int
	var b: bool
	func _init(x: int, new_b: bool = false):
		_x = x
		b = new_b
	func get_x(): return _x
	func get_x_and_add(a): return _x + a
	func x_is_gte_2(): return _x >= 2
	func x_sub_is_gte_2(a): return _x - a >= 2

# ----------------------------------------------------------------------------------------------------------------------

func _test_join() -> void:
	assert(G([]).join(" ") == "")
	assert(G([]).join() == "")
	assert(G(["GG"]).join(" ") == "GG")
	assert(G([""]).join("", "G", "G") == "GG")
	assert(G(["Golden", "Gadget"]).join(" ") == "Golden Gadget")
	assert(G(["a", "b"]).join(" ", "<", ">") == "<a b>")
	assert(G([1, 2, 3]).join(", ", "<", ">") == "<1, 2, 3>")

# ----------------------------------------------------------------------------------------------------------------------

func _test_filter() -> void:
	# filter_fn
	assert(G([]).filter_fn(funcref(self, "_is_2")).val == [])
	assert(G([1]).filter_fn(funcref(self, "_is_2")).val == [])
	assert(G([2]).filter_fn(funcref(self, "_is_2")).val == [2])
	assert(G(range(-4, 4)).filter_fn(funcref(self, "_gte_2")).val == [2, 3])

	# filter_fn with ctx
	_assert(G([1, 2, 3]).filter_fn(funcref(self, "_sub_gte_2"), 1).val, [3])

	# filter
	_assert(G(range(-4, 4)).filter(funcref(self, "_gte_2")).val, [2, 3])
	_assert(G(range(-4, 4)).filter("x => x >= 2").val, [2, 3])

	# filter with ctx
	_assert(G([1, 2, 3]).filter(funcref(self, "_sub_gte_2"), 1).val, [3])
	_assert(G([1, 2, 3]).filter("x, ctx => (x - ctx) >= 2", 1).val, [3])

	# filter_in_mtd
	assert(G([]).filter_in_mtd("x_is_gte_2").val == [])
	assert(G([T0.new(1)]).filter_in_mtd("x_is_gte_2").size == 0)
	assert(G([T0.new(2)]).filter_in_mtd("x_is_gte_2").size == 1)
	assert(G([T0.new(1), T0.new(2), T0.new(3)]).filter_in_mtd("x_is_gte_2").size == 2)

	# filter_in_mtd with ctx
	_assert(G([T0.new(1), T0.new(2), T0.new(3)]).filter_in_mtd("x_sub_is_gte_2", 1).size, 1)

	# filter_out_mtd
	assert(G([]).filter_out_mtd(self, "_gte_2").val == [])
	assert(G([1]).filter_out_mtd(self, "_gte_2").val == [])
	assert(G([2]).filter_out_mtd(self, "_gte_2").val == [2])
	assert(G([1, 2, 3]).filter_out_mtd(self, "_gte_2").val == [2, 3])

	# filter_out_mtd with ctx
	_assert(G([1, 2, 3]).filter_out_mtd(self, "_sub_gte_2", 1).val, [3])

	# filter_by_field
	assert(G([]).filter_by_fld("b").size == 0)
	assert(G([T0.new(0)]).filter_by_fld("b").size == 0)
	assert(G([T0.new(0, true)]).filter_by_fld("b").size == 1)
	assert(
	  G([T0.new(0, true), T0.new(1, false), T0.new(2, true)])\
		.filter_by_fld("b")\
		.map_in_mtd("get_x")\
		.val == [0, 2]
	)

	# filter_by_fld_val
	assert(G([]).filter_by_fld_val("_x", 0).size == 0)
	assert(G([{}]).filter_by_fld_val("_x", 0).size == 0)
	assert(G([T0.new(0, false)]).filter_by_fld_val("_x", 0).size == 1)
	assert(G([T0.new(0, false), T0.new(1, false)]).filter_by_fld_val("b", false).size == 2)

	assert(G([T0.new(-1, true), T0.new(0, false), T0.new(1, false)]).find_by_fld_val("b", false).get_x() == 0)

func _is_2(x) -> bool: return x == 2
func _gte_2(x) -> bool: return x >= 2
func _sub_gte_2(x, a) -> bool: return x - a >= 2

# ----------------------------------------------------------------------------------------------------------------------

func _test_fold() -> void:
	# foldl_fn
	assert(G([]).foldl_fn(funcref(self, "add"), 0) == 0)
	assert(G([1]).foldl_fn(funcref(self, "add"), 4) == 5)
	assert(G([1, 2, 3]).foldl_fn(funcref(self, "add"), -6) == 0)

	# foldl_fn with ctx
	# (10 - 1) * -1 -> -9
	# (-9 - 2) * -1 -> 11
	# (11 - 3) * -1 -> -8
	_assert(G([1, 2, 3]).foldl_fn(funcref(self, "sub_mul"), 10, -1), -8)

	# foldl
	_assert(G([1, 2, 3]).foldl(funcref(self, "add"), -6), 0)

	# foldl with ctx
	_assert(G([1, 2, 3]).foldl("x, y, z => (x - y) * z", 10, -1), -8)

	# foldl_mtd
	assert(G([]).foldl_mtd(self, "add", 0) == 0)
	assert(G([1]).foldl_mtd(self, "add", 4) == 5)
	assert(G([1, 2, 3]).foldl_mtd(self, "add", -6) == 0)

	# foldl_mtd with ctx
	_assert(G([1, 2, 3]).foldl_mtd(self, "sub_mul", 10, -1), -8)

func add(x, y): return x + y
func sub_mul(x, y, z): return (x - y) * z

# ----------------------------------------------------------------------------------------------------------------------

func _append_0(arr: Array) -> Array:
	var r = arr.duplicate()
	r.push_back(0)
	return r

func _test_pipe() -> void:
	assert(G([1, 2]).to(funcref(self, "_append_0")) == [1, 2, 0])
	assert(G([1, 2]).to_w(funcref(self, "_append_0")).val == [1, 2, 0])

# ----------------------------------------------------------------------------------------------------------------------

func _test_utils() -> void:
	# eq_field
	var eq_field_cases = [
		[{a = 1}, {name = "a", value = 1}, true],
		[{a = 1}, {name = "a", value = 2}, false],
		[{a = 1}, {name = "b", value = 1}, false],
		[{a = 1, b = 2, c = 3}, {name = "b", value = 1}, false],
	]
	_test_func_a(eq_field_cases, GG.eq_field)
	_test_func_a(eq_field_cases, funcref(GG, "eq_field_"))

	# eqd
	var eqd_cases = [
		[1, 1, true],
		[null, null, true],
		[{}, {}, true],
		[{a = 1}, {}, false],
		[{a = 1}, {a = 1}, true],
		[{b = 2, a = 1}, {a = 1, b = 2}, true],
	]
	_test_func_a(eqd_cases, GG.eqd)
	_test_func_a(eqd_cases, funcref(GG, "eqd_"))

	# size
	var size_cases = [
		[[], 0],
		[[1, 2], 2],
		["", 0],
		["aa", 2]
	]
	_test_func_a(size_cases, GG.size)
	_test_func_a(size_cases, funcref(GG, "size_"))

func _test_array() -> void:
	# head
	var head_cases = [
		[[], null],
		[[1], 1],
		[[1, 2], 1],
	]
	_test_func_a(head_cases, GG.head)
	_test_func_a(head_cases, funcref(GG, "head_"))
	_test_arr_func_a(head_cases, "head")

	# last
	var last_cases = [
		[[], null],
		[[1], 1],
		[[1, 2], 2],
	]
	_test_func_a(last_cases, GG.last)
	_test_func_a(last_cases, funcref(GG, "last_"))
	_test_arr_func_a(last_cases, "last")

	# init
	var init_input = [1, 2, 3]
	assert(GG.init_(init_input) == [1, 2])
	assert(init_input.size() == 3)
	var init_cases = [
		[[], null],
		[[1], []],
		[[1, 2], [1]],
		[[1, 2, 3], [1, 2]],
	]
	_test_func_a(init_cases, GG.init)
	_test_func_a(init_cases, funcref(GG, "init_"))
	init_cases.pop_front()
	_test_arr_wrapped_func_a(init_cases, "init")

	# tail
	var tail_input = [1, 2, 3]
	assert(GG.tail_(tail_input) == [2, 3])
	assert(tail_input.size() == 3)
	var tail_cases = [
		[[], null],
		[[1], []],
		[[1, 2], [2]],
		[[1, 2, 3], [2, 3]],
	]
	_test_func_a(tail_cases, GG.tail)
	_test_func_a(tail_cases, funcref(GG, "tail_"))
	tail_cases.pop_front()
	_test_arr_wrapped_func_a(tail_cases, "tail")

	# zip
	var zip_cases = [
		[[], [], []],
		[[1], ["a"], [[1, "a"]]],
		[[1, 2], ["a", "b"], [[1, "a"], [2, "b"]]],
		[[1], ["a", "b"], [[1, "a"]]],
	]
	_test_func_a(zip_cases, GG.zip)
	_test_func_a(zip_cases, funcref(GG, "zip_"))
	_test_arr_wrapped_func_a(zip_cases, "zip")

func _test_call_spreaded():
	# call_spreaded
	assert(GG.call_spreaded.call_func(funcref(self, "_sum0"), []) == 0)
	assert(GG.call_spreaded_(funcref(self, "_sum0"), []) == 0)
	assert(GG.call_spreaded_(funcref(self, "_sum1"), [1]) == 1)
	assert(GG.call_spreaded_(funcref(self, "_sum2"), [1, 2]) == 3)
	assert(GG.call_spreaded_(funcref(self, "_sum3"), [1, 2, 3]) == 6)
	assert(GG.call_spreaded_(funcref(self, "_sum4"), [1, 2, 3, 4]) == 10)
	assert(GG.call_spreaded_(funcref(self, "_sum5"), [1, 2, 3, 4, 5]) == 15)
	assert(GG.call_spreaded_(funcref(self, "_sum6"), [1, 2, 3, 4, 5, 6]) == 21)
	assert(GG.call_spreaded_(funcref(self, "_sum7"), [1, 2, 3, 4, 5, 6, 7]) == 28)
	assert(GG.call_spreaded_(funcref(self, "_sum8"), [1, 2, 3, 4, 5, 6, 7, 8]) == 36)
	assert(GG.call_spreaded_(funcref(self, "_sum9"), [1, 2, 3, 4, 5, 6, 7, 8, 9]) == 45)
	assert(GG.call_spreaded_(funcref(self, "_sum10"), [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]) == 55)

func _sum0(): return 0
func _sum1(a): return a
func _sum2(a, b): return a + b
func _sum3(a, b, c): return a + b + c
func _sum4(a, b, c, d): return a + b + c + d
func _sum5(a, b, c, d, e): return a + b + c + d + e
func _sum6(a, b, c, d, e,  f): return a + b + c + d + e + f
func _sum7(a, b, c, d, e,  f, g): return a + b + c + d + e + f + g
func _sum8(a, b, c, d, e,  f, g, h): return a + b + c + d + e + f + g + h
func _sum9(a, b, c, d, e,  f, g, h, i): return a + b + c + d + e + f + g + h + i
func _sum10(a, b, c, d, e,  f, g, h, i, j): return a + b + c + d + e + f + g + h + i + j

# ----------------------------------------------------------------------------------------------------------------------

func _test_strings() -> void:
	_assert(GG.capitalize_("sigma"), "Sigma")
	_assert(GG.capitalize.call_func("sigma"), "Sigma")

	_assert(GG.snake_to_pascal_case_(""), "")
	_assert(GG.snake_to_pascal_case_("ahoy!"), "Ahoy!")
	_assert(GG.snake_to_pascal_case_("from_snake_case"), "FromSnakeCase")
	_assert(GG.snake_to_pascal_case_("test_a_num_1"), "TestANum1")

# ----------------------------------------------------------------------------------------------------------------------

func _test_math() -> void:
	# add
	var add_cases = [
		[1, 2, 3],
		[-5, 10, 5]
	]
	_test_func_a(add_cases, GG.add)
	_test_func_a(add_cases, funcref(GG, "add_"))

	# subtract
	var subtract_cases = [
		[1, 2, -1],
		[-5, 10, -15]
	]
	_test_func_a(subtract_cases, GG.subtract)
	_test_func_a(subtract_cases, funcref(GG, "subtract_"))

	_assert(GG.multiply.call_func(2, 3), 6)
	_assert(GG.multiply_(2, 3), 6)
	_assert(GG.multiply_(2.0, 3.0), 6)
	_assert(GG.multiply_(2, 3.0), 6)
	_assert(GG.multiply_(2.0, 3), 6)

	_assert(GG.modulo.call_func(7, 3), 1)
	_assert(GG.modulo_(7, 3), 1)
	_assert(GG.modulo_(7.0, 3.0), 1)

	_assert(GG.inc.call_func(1), 2)
	_assert(GG.inc_(1), 2)
	_assert(GG.inc_(1.0), 2.0)

	_assert(GG.dec.call_func(1), 0)
	_assert(GG.dec_(1), 0)
	_assert(GG.dec_(1.0), 0.0)

	_assert(GG.negate_num.call_func(1), -1)
	_assert(GG.negate_num_(1), -1)
	_assert(GG.negate_num_(-1.0), 1.0)

# ----------------------------------------------------------------------------------------------------------------------

func _test_bool() -> void:
	_assert(GG.negate.call_func(true), false)
	_assert(GG.negate_(false), true)

	# l_and
	var and_cases = [
		[t, t, t],
		[t, f, f],
		[f, t, f],
		[f, f, f],
	]
	_test_func_a(and_cases, GG.l_and)
	_test_func_a(and_cases, funcref(GG, "l_and_"))

	# l_or
	var or_cases = [
		[t, t, t],
		[t, f, t],
		[f, t, t],
		[f, f, f],
	]
	_test_func_a(or_cases, GG.l_or)
	_test_func_a(or_cases, funcref(GG, "l_or_"))

# ----------------------------------------------------------------------------------------------------------------------

func _gt_(a, b): return a > b
var _gt = funcref(self, "_gt_")

func _test_sort() -> void:
	var sort_cases = [
		[[], []],
		[[1], [1]],
		[[1, 2], [1, 2]],
		[[2, 1], [1, 2]],
		[["a", "c", "b"], ["a", "b", "c"]]
	]
	_test_func_a(sort_cases, GG.sort)
	_test_func_a(sort_cases, funcref(GG, "sort_"))
	_test_arr_wrapped_func_a(sort_cases, "sort")

	var sort_by_cases = [
		[[], _gt, []],
		[[1, 2, 3], _gt, [3, 2, 1]],
	]
	_test_func_a(sort_by_cases, GG.sort_by)
	_test_func_a(sort_by_cases, funcref(GG, "sort_by_"))
	_test_arr_wrapped_func_a(sort_by_cases, "sort_by")

	var sort_by_fld_cases = [
		[[], "x", []],
		[[{x = 3, y = 2}, {x = 1, y = 4}], "x", [{x = 1, y = 4}, {x = 3, y = 2}]],
	]
	_test_func_a(sort_by_fld_cases, GG.sort_by_fld)
	_test_func_a(sort_by_fld_cases, funcref(GG, "sort_by_fld_"))
	_test_arr_wrapped_func_a(sort_by_fld_cases, "sort_by_fld")

	var sort_with_cases = [
		[[], GG.size, []],
		[["aaa", "aa", "a"], GG.size, ["a", "aa", "aaa"]],
	]
	_test_func_a(sort_with_cases, GG.sort_with)
	_test_func_a(sort_with_cases, funcref(GG, "sort_with_"))
	_test_arr_wrapped_func_a(sort_with_cases, "sort_with")

# ----------------------------------------------------------------------------------------------------------------------

func _test_object() -> void:
	var get_fld_cases = [
		[{x = 1}, "x", 1],
		[T0.new(2, false), "b", false]
	]
	_test_func_a(get_fld_cases, GG.get_fld)
	_test_func_a(get_fld_cases, funcref(GG, "get_fld_"))

# ----------------------------------------------------------------------------------------------------------------------

func _test_pairs() -> void:
	var fst_cases = [
		[[0, 1], 0],
		[["a", "b"], "a"]
	]
	_test_func_a(fst_cases, GG.fst)
	_test_func_a(fst_cases, funcref(GG, "fst_"))

	var snd_cases = [
		[[0, 1], 1],
		[["a", "b"], "b"]
	]
	_test_func_a(snd_cases, GG.snd)
	_test_func_a(snd_cases, funcref(GG, "snd_"))

# ----------------------------------------------------------------------------------------------------------------------

func _test_compile_script() -> void:
	var src = """
func f(x): return x + 1

func g(): return funcref(self, "f")
	"""
	var scr = GG.compile_script_(src)
	var scr2 = GG.compile_script.call_func(src)
	_assert(scr.f(1), 2)
	_assert(scr2.f(1), 2)
	_assert(scr.g().call_func(1), 2)
	_assert(funcref(scr, "f").call_func(1), 2)

# ----------------------------------------------------------------------------------------------------------------------

func _test_lambdas() -> void:
	var parse_fn_cases = [
		["x => 1", ["x", "1"]],
		["x=>x", ["x", "x"]],
		["DoggO:Object,Action:String=>Conan", ["DoggO:Object,Action:String", "Conan"]],
		["x, y => x + y", ["x, y", "x + y"]],
		["a, b, c => a.a * b.b - c.c()", ["a, b, c", "a.a * b.b - c.c()"]],
		["a: float, b: int,c:string=>a+b+c", ["a: float, b: int,c:string", "a+b+c"]],
		["a: float => a", ["a: float", "a"]]
	]
	_test_func_a(parse_fn_cases, funcref(GG.GGI, "parse_fn"))

	_assert(GG.GGI.function_expr_to_script_("x => x"), "func f(x):return x")
	_assert(GG.GGI.function_expr_to_script_("a: int, b: float => float(a) * b"), "func f(a: int, b: float):return float(a) * b")

	_assert(GG.GGI.function_("x => x").call_func(1), 1)
	_assert(GG.GGI.function_("a,b=>a*b").call_func(2, 3), 6)

	_assert(F("x => x.b").call_func({b = true}), true)
	_assert(F("x => x.b").call_func(T0.new(0, true)), true)

# ----------------------------------------------------------------------------------------------------------------------

func _test_short_example() -> void:
	var monsters = [
		Monster.new(0, "Orc"),
		Monster.new(5, "Demon"),
		Monster.new(12, "Amus"),
		Monster.new(0, "Borg"),
	]

	# Names of Weak and Alive monsters example

	# imperative solution
	var weak_alive_monsters_imperative = []
	for monster in monsters:
		if monster.is_alive && monster.hp < 10:
			weak_alive_monsters_imperative.push_back(monster.name)

	# functional approach, uses lambdas (anonymous functions)
	var weak_alive_monsters = G(monsters).filter("x => x.is_alive && x.hp < 10").map("x => x.name").val

	assert(weak_alive_monsters_imperative == ["Demon"])
	assert(weak_alive_monsters == ["Demon"])

# ----------------------------------------------------------------------------------------------------------------------
# Nice Examples

class Monster:
	var name: String setget , get_name
	var hp: int setget , get_hp
	var is_alive: bool setget , get_is_alive
	var _name: String

	func _init(init_hp: int, init_name: String) -> void:
		hp = init_hp
		_name = init_name

	func get_is_alive() -> bool: return hp > 0

	func get_name() -> String: return _name

	func get_hp() -> int: return hp

func _test_examples() -> void:
	var monsters = [
		Monster.new(0, "Orc"),
		Monster.new(5, "Demon"),
		Monster.new(12, "Amus"),
		Monster.new(0, "Borg"),
	]

	# Names of Alive Monsters example

	var names_of_alive_monsters = G(monsters).filter_by_fld("is_alive").map_fld("name").val
	assert(names_of_alive_monsters == ["Demon", "Amus"])
	assert(monsters.size() == 4) # original monster list is not mutated (changed)

	# ------------------------------------------------------------------------------------------------------------------

	# Names of Weak and Alive monsters example

	# imperative solution
	var weak_alive_monsters_imperative = []
	for monster in monsters:
		if monster.is_alive && monster.hp < 10:
			weak_alive_monsters_imperative.push_back(monster.name)
	assert(weak_alive_monsters_imperative == ["Demon"])
	assert(monsters.size() == 4)

	# functional approach, uses lambdas (anonymous functions)
	var weak_alive_monsters = G(monsters).filter("x => x.is_alive && x.hp < 10").map("x => x.name").val
	assert(weak_alive_monsters == ["Demon"])
	assert(monsters.size() == 4)

	# ------------------------------------------------------------------------------------------------------------------

	# an older approach of a similar problem
	var names_of_spongy_monsters = G(monsters).filter_fn(F("x => x.hp >= 10")).map_fn(F("x => x.name")).val
	assert(names_of_spongy_monsters == ["Amus"])
	assert(monsters.size() == 4)

# For less nice examples of concrete functions and results see the tests above these nicer examples.
#
# `_assert` is simple assertion where first parameter is a result from a tested function
# and a second parameter is an expected result.
#
# Variables with suffix "cases" are for bulk assertions.
#	var sort_by_cases = [
#		[[], _gt, []],
#		[[1, 2, 3], _gt, [3, 2, 1]],
#	]
# Each item in an array is one test case (e.g. `[[1, 2, 3], _gt, [3, 2, 1]]`).
# A test case (an array) comprises of arguements passed to a function being tested
# (everything except last item, e.g. `[1, 2, 3], _gt`)
# and an expected result (last item in a "case" array, e.g. `[3, 2, 1]`).
