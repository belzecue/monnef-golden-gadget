extends Node

class_name GGTests

func G(arr) -> GGArray: return GG.arr(arr)
func F_raw(f: String) -> FuncRef: return GG.compile_function_(f)
func F(f): return GG.F_(f)

const t = true
const f = false

var _skip_tests_triggering_godots_spam_bug = false

func _init(options: Dictionary = {}) -> void:
	_skip_tests_triggering_godots_spam_bug = GG.get_fld_or_else_(options, "skip_tests_triggering_godots_spam_bug", false)

func run() -> void:
	print("[GG] Golden Gadget Tests: START")
	var start = OS.get_ticks_msec()
	randomize()
	_test_wrap()
	_test_map()
	_test_map_with_index()
	_test_for_each()
	_test_join()
	_test_filter()
	_test_partition()
	_test_fold()
	_test_arr_pipe()
	_test_utils()
	_test_array()
	_test_call_spreaded()
	_test_strings()
	_test_math()
	_test_bool()
	_test_sort()
	_test_rand()
	_test_object()
	_test_merge()
	_test_pairs()
	_test_function_utils()
	_test_compile_script()
	_test_lambdas()
	_test_examples()
	_test_short_example()
	_test_date()
	_test_flatten()
	_test_func_compostition_utils()
	_test_tap()
	_test_min_max()
	_test_average()
	_test_sum_product()
	_test_insertion_concatenation()
	_test_array_generators()
	_test_batch_field_access()
	_test_grouping()
	_test_uniq()
	_test_elem()
	_test_not_elem()
	_test_valid_index()
	_test_transpose()
	_test_set_operations()
	_test_format()
	_test_cmd_args()
	_test_json_reading()
	_test_vector_utils()
	_test_input_event_dict()
	_test_color()
	_test_debug()
	var stop = OS.get_ticks_msec()
	print("[GG] Golden Gadget Tests: SUCCESS in %.3fs (%s - %s)" % [(stop - start)/1000.0, start, stop])

func _assert(actual, expected) -> void:
	if !GG.eqd_(actual, expected):
		GG.assert_(false, "Expected: %s, Actual: %s" % [expected, actual])

# args - arguments for function, last item is expected result
func _test_func(args, op) -> void:
	var actual = GG.call_spread_(op, GG.init_(args))
	var expected = GG.last_(args)
	_assert(actual, expected)

func _test_func_a(cases: Array, op: FuncRef) -> void:
	G(cases).map_out_mtd(self, "_test_func", op).noop()

func _test_arr_func(args, func_name) -> void:
	var input_arr = GG.head_(args)
	var f_args = GG.tail_(GG.init_(args))
	var expected = GG.last_(args)
	var g_arr = G(input_arr)
	var actual = GG.call_spread_(funcref(g_arr, func_name), f_args)
	_assert(actual, expected)

func _test_arr_func_a(cases: Array, func_name) -> void:
	G(cases).map_out_mtd(self, "_test_arr_func", func_name).noop()

func _test_arr_wrapped_func(args, func_name) -> void:
	var input_arr = GG.head_(args)
	var orig_arr = input_arr.duplicate()
	var f_args = GG.tail_(GG.init_(args))
	var expected = GG.last_(args)
	var g_arr = G(input_arr)
	var actual = GG.call_spread_(funcref(g_arr, func_name), f_args).val
	_assert(actual, expected)
	_assert(input_arr, orig_arr)

func _test_arr_wrapped_func_a(cases: Array, func_name) -> void:
	G(cases).map_out_mtd(self, "_test_arr_wrapped_func", func_name).noop()

# ----------------------------------------------------------------------------------------------------------------------

func _test_wrap() -> void:
	_assert(G([]).val, [])
	_assert(G([1, 2]).val, [1, 2])
	_assert(G([1, 2]).size, 2)

# ----------------------------------------------------------------------------------------------------------------------

func _test_map() -> void:
	# map
	_assert(G([{x = 1}]).map(funcref(self, "_get_x")).val, [1])
	_assert(G([{x = 1}]).map("x => x.x").val, [1])
	_assert(GG.map_([{x = 1}], funcref(self, "_get_x")), [1])
	_assert(GG.map_([{x = 1}], "x => x.x"), [1])
	_assert(G([1, 2]).map("x => x + 1").val, [2, 3])

	# map with ctx
	_assert(G([{x = 1}, {a = 4, x = 2}]).map(funcref(self, "_get_x_and_add"), 10).val, [11, 12])
	_assert(G([{x = 1}, {a = 4, x = 2}]).map("x, ctx => x.x + ctx", 10).val, [11, 12])
	_assert(GG.map_([{x = 1}, {a = 4, x = 2}], funcref(self, "_get_x_and_add"), 10), [11, 12])
	_assert(GG.map_([{x = 1}, {a = 4, x = 2}], "x, ctx => x.x + ctx", 10), [11, 12])

	# map_out_mtd
	_assert(G([]).map_out_mtd(self, "_get_x").val, [])
	_assert(G([{x = 2}]).map_out_mtd(self, "_get_x").val, [2])
	_assert(G([{x = 2}, {a = 4, x = 2}]).map_out_mtd(self, "_get_x").val, [2, 2])

	# map_out_mtd with ctx
	_assert(G([{x = 2}]).map_out_mtd(self, "_get_x_and_add", 10).val, [12])

	# map_in_mtd
	_assert(G([]).map_in_mtd("get_x").val, [])
	_assert(G([T0.new(3)]).map_in_mtd("get_x").val, [3])
	_assert(G([T0.new(3), T0.new(4), T0.new(5)]).map_in_mtd("get_x").val, [3, 4, 5])

	# map_in_mtd with ctx
	_assert(G([T0.new(3)]).map_in_mtd("get_x_and_add", 10).val, [13])

	# map_fld
	_assert(G([{name = "Spock"}, {name = "Scotty"}]).map_fld("name").val, ["Spock", "Scotty"])

func _test_map_with_index() -> void:
	_assert(GG.map_with_index_([], "x, i => x * i"), [])
	_assert(GG.map_with_index_([10, 20, 30], "x, i => x * i"), [0, 20, 60])
	_assert(G([10, 20, 30]).map_with_index("x, i => x * i").val, [0, 20, 60])

# ----------------------------------------------------------------------------------------------------------------------

func _test_for_each() -> void:
	var a1 = [{ x = 0 }, { x = 1 }, { x = 2 }]
	GG.for_each_(a1, "x -> x.x *= 10")
	_assert(a1, [{ x = 0 }, { x = 10 }, { x = 20 }])

	var a2 = [{ x = 0 }, { x = 1 }, { x = 2 }]
	GG.for_each_(a2, funcref(self, "_set_x_to_69"))
	_assert(a2, [{ x = 69 }, { x = 69 }, { x = 69 }])

	var a3 = [{ x = 0 }, { x = 1 }, { x = 2 }]
	GG.for_each_(a3, funcref(self, "_set_x"), 72)
	_assert(a3, [{ x = 72 }, { x = 72 }, { x = 72 }])

	var a4 = [{ x = 0 }, { x = 1 }, { x = 2 }]
	G(a4).for_each("x->x.x*=8")
	_assert(a4, [{ x = 0 }, { x = 8 }, { x = 16 }])

	var a5 = [{ x = 0 }, { x = 1 }, { x = 2 }]
	G(a5).for_each(funcref(self, "_mult_x_and_set"), 16)
	_assert(a5, [{ x = 0 }, { x = 16 }, { x = 32 }])

	# G(["Firefly", "Daedalus"]).for_each("x -> print(x)")

# ----------------------------------------------------------------------------------------------------------------------

func _get_x(x): return x.x

func _get_x_and_add(x, y): return x.x + y

func _set_x(obj, val): obj.x = val

func _set_x_to_69(obj): obj.x = 69

func _mult_x_and_set(obj, x): obj.x *= x

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
	# join
	_assert(G([]).join(" "), "")
	_assert(G([]).join(), "")
	_assert(G(["GG"]).join(" "), "GG")
	_assert(G([""]).join("", "G", "G"), "GG")
	_assert(G(["Golden", "Gadget"]).join(" "), "Golden Gadget")
	_assert(G(["a", "b"]).join(" ", "<", ">"), "<a b>")
	_assert(G([1, 2, 3]).join(", ", "<", ">"), "<1, 2, 3>")
	_assert(GG.join_([1, 2, 3], ", ", "<", ">"), "<1, 2, 3>")
	_assert(GG.join.call_func([1, 2, 3], ", ", "<", ">"), "<1, 2, 3>")
	_assert(G(["Dog", "Cat", "Frog"]).join(", "), "Dog, Cat, Frog")

	# join_w
	_assert(G([1, 2, 3]).join_w(", ", "<", ">").val, ["<1, 2, 3>"])

# ----------------------------------------------------------------------------------------------------------------------

func _test_filter() -> void:
	# filter_fn
	_assert(G([]).filter_fn(funcref(self, "_is_2")).val, [])
	_assert(G([1]).filter_fn(funcref(self, "_is_2")).val, [])
	_assert(G([2]).filter_fn(funcref(self, "_is_2")).val, [2])
	_assert(G(range(-4, 4)).filter_fn(funcref(self, "_gte_2")).val, [2, 3])

	# filter_fn with ctx
	_assert(G([1, 2, 3]).filter_fn(funcref(self, "_sub_gte_2"), 1).val, [3])

	# filter
	_assert(G(range(-4, 4)).filter(funcref(self, "_gte_2")).val, [2, 3])
	_assert(G(range(-4, 4)).filter("x => x >= 2").val, [2, 3])
	_assert(GG.filter_(range(-4, 4), funcref(self, "_gte_2")), [2, 3])
	_assert(GG.filter_(range(-4, 4), "x => x >= 2"), [2, 3])
	_assert(GG.filter_(range(-4, 4), ["x, y => x >= y", 2]), [2, 3])

	# filter with ctx
	_assert(G([1, 2, 3]).filter(funcref(self, "_sub_gte_2"), 1).val, [3])
	_assert(G([1, 2, 3]).filter("x, ctx => (x - ctx) >= 2", 1).val, [3])
	_assert(GG.filter_(range(-4, 4), "x, y => x >= y", 2), [2, 3])

	# filter_in_mtd
	_assert(G([]).filter_in_mtd("x_is_gte_2").val, [])
	_assert(G([T0.new(1)]).filter_in_mtd("x_is_gte_2").size, 0)
	_assert(G([T0.new(2)]).filter_in_mtd("x_is_gte_2").size, 1)
	_assert(G([T0.new(1), T0.new(2), T0.new(3)]).filter_in_mtd("x_is_gte_2").size, 2)

	# filter_in_mtd with ctx
	_assert(G([T0.new(1), T0.new(2), T0.new(3)]).filter_in_mtd("x_sub_is_gte_2", 1).size, 1)

	# filter_out_mtd
	_assert(G([]).filter_out_mtd(self, "_gte_2").val, [])
	_assert(G([1]).filter_out_mtd(self, "_gte_2").val, [])
	_assert(G([2]).filter_out_mtd(self, "_gte_2").val, [2])
	_assert(G([1, 2, 3]).filter_out_mtd(self, "_gte_2").val, [2, 3])

	# filter_out_mtd with ctx
	_assert(G([1, 2, 3]).filter_out_mtd(self, "_sub_gte_2", 1).val, [3])

	# filter_by_field
	_assert(G([]).filter_by_fld("b").size, 0)
	_assert(G([T0.new(0)]).filter_by_fld("b").size, 0)
	_assert(G([T0.new(0, true)]).filter_by_fld("b").size, 1)
	assert(
	  G([T0.new(0, true), T0.new(1, false), T0.new(2, true)])\
		.filter_by_fld("b")\
		.map_in_mtd("get_x")\
		.val == [0, 2]
	)
	_assert(G([{enabled = true, id = 0}, {enabled = false, id = 1}, {enabled = true, id = 2}]).filter_by_fld("enabled").map_fld("id").val, [0, 2])

	# filter_by_fld_val
	_assert(G([]).filter_by_fld_val("_x", 0).size, 0)
	_assert(G([{}]).filter_by_fld_val("_x", 0).size, 0)
	_assert(G([T0.new(0, false)]).filter_by_fld_val("_x", 0).size, 1)
	_assert(G([T0.new(0, false), T0.new(1, false)]).filter_by_fld_val("b", false).size, 2)
	_assert(G([{id = 0, name = "Zero"}, {id = 1, name = "One"}]).filter_by_fld_val("id", 1).map_fld("name").val, ["One"])

	# find_by_fld_val
	_assert(G([T0.new(-1, true), T0.new(0, false), T0.new(1, false)]).find_by_fld_val("b", false).get_x(), 0)
	_assert(G([{id = 0, name = "Zero"}, {id = 1, name = "One"}]).find_by_fld_val("id", 1).name, "One")

	# find_by_fld_val
	_assert(G([T0.new(-1, true), T0.new(0, false), T0.new(1, false)]).find_by_fld_val_or_null("b", false).get_x(), 0)
	_assert(G([{id = 0, name = "Zero"}, {id = 1, name = "One"}]).find_by_fld_val_or_null("id", 1).name, "One")
	_assert(G([T0.new(-1, true), T0.new(0, false), T0.new(1, false)]).find_by_fld_val_or_null("id", 0), null)
	_assert(G([{id = 0, name = "Zero"}, {id = 1, name = "One"}]).find_by_fld_val_or_null("id", -1), null)

	# find_or_null
	var find_or_null_cases = [
		[[], "x => x == 1", null],
		[[1], "x => x == 1", 1],
		[[1, 2], "x => x == 1", 1],
		[[1, 2], "x, ctx => x == ctx", 2, 2],
		[[1, 2, 3], "x => x > 1", 2],
	]
	_test_func_a(find_or_null_cases, GG.find_or_null)
	_test_func_a(find_or_null_cases, funcref(GG, "find_or_null_"))
	_test_arr_func_a(find_or_null_cases, "find_or_null")
	_assert(GG.find_or_null_([{id = 4, name = "Alice"}, {id = 7, name = "Bob"}], "x => x.name.length() == 3").id, 7)
	_assert(G([{id = 4, name = "Alice"}, {id = 7, name = "Bob"}]).find_or_null("x => x.name.length() == 3").id, 7)

	# find_index_or_null
	var find_index_or_null_cases = [
		[[], "x => x == 1", null],
		[[1], "x => x == 1", 0],
		[[1, 2], "x => x == 2", 1],
		[[1, 2], "x, ctx => x == ctx", 2, 1],
		[[1, 2, 3], "x => x > 2", 2],
	]
	_test_func_a(find_index_or_null_cases, GG.find_index_or_null)
	_test_func_a(find_index_or_null_cases, funcref(GG, "find_index_or_null_"))
	_test_arr_func_a(find_index_or_null_cases, "find_index_or_null")

# ----------------------------------------------------------------------------------------------------------------------

func _test_partition() -> void:
	var partition_cases = [
		[[], "x => true", [[], []]],
		[[-1, 0, 1], "x => x>= 0", [[0, 1], [-1]]]
	]
	_test_func_a(partition_cases, GG.partition)
	_test_func_a(partition_cases, funcref(GG, "partition_"))
	var res = G([-1, 0, 1]).partition("x => x >= 0")
	_assert(res.to_array_deep(), [[0, 1], [-1]])
	_assert(GGArray.is_GGArray(res.val[0]),true)
	# with ctx
	_assert(GG.partition_([0, 1, 2], "x, ctx => x >= ctx", 1), [[1, 2], [0]])
	_assert(G([0, 1, 2]).partition("x, ctx => x >= ctx", 1).to_array_deep(), [[1, 2], [0]])

# ----------------------------------------------------------------------------------------------------------------------

func _is_2(x) -> bool: return x == 2
func _gte_2(x) -> bool: return x >= 2
func _sub_gte_2(x, a) -> bool: return x - a >= 2

# ----------------------------------------------------------------------------------------------------------------------

func _test_fold() -> void:
	# foldl_fn
	_assert(G([]).foldl_fn(funcref(self, "add"), 0), 0)
	_assert(G([1]).foldl_fn(funcref(self, "add"), 4), 5)
	_assert(G([1, 2, 3]).foldl_fn(funcref(self, "add"), -6), 0)

	# foldl_fn with ctx
	# (10 - 1) * -1 -> -9
	# (-9 - 2) * -1 -> 11
	# (11 - 3) * -1 -> -8
	_assert(G([1, 2, 3]).foldl_fn(funcref(self, "sub_mul"), 10, -1), -8)

	# foldl
	_assert(G([1, 2, 3]).foldl(funcref(self, "add"), -6), 0)
	_assert(G([1, 2, 3]).foldl("a, x => a + x", -6), 0)
	_assert(GG.foldl_([1, 2, 3], funcref(self, "add"), -6), 0)
	_assert(GG.foldl_([1, 2, 3], "x , y => x + y", -6), 0)

	# foldl with ctx
	_assert(G([1, 2, 3]).foldl("x, y, z => (x - y) * z", 10, -1), -8)
	_assert(GG.foldl_([1, 2, 3], "x, y, z => (x - y) * z", 10, -1), -8)

	# foldl_mtd
	_assert(G([]).foldl_mtd(self, "add", 0), 0)
	_assert(G([1]).foldl_mtd(self, "add", 4), 5)
	_assert(G([1, 2, 3]).foldl_mtd(self, "add", -6), 0)

	# foldl_mtd with ctx
	_assert(G([1, 2, 3]).foldl_mtd(self, "sub_mul", 10, -1), -8)

func add(x, y): return x + y
func sub_mul(x, y, z): return (x - y) * z

# ----------------------------------------------------------------------------------------------------------------------

func _append_0(arr: Array) -> Array:
	var r = arr.duplicate()
	r.push_back(0)
	return r

func _test_arr_pipe() -> void:
	_assert(G([1, 2]).to(funcref(self, "_append_0")), [1, 2, 0])
	_assert(G([1, 2]).to_w(funcref(self, "_append_0")).val, [1, 2, 0])
	_assert(G([1, 2]).to("x => x.size() * 10"), 20)
	_assert(G([1, 2]).to(["x, y => x.size() * y", 10]), 20)

# ----------------------------------------------------------------------------------------------------------------------

func _test_utils() -> void:
	var obj_a = {}
	var obj_b = {}

	# eq
	var eq_cases = \
	  [ [null, null, true]
	  , [1, 1, true]
	  , [1, 0, false]
	  , ["a", "a", true]
	  , ["a", "b", false]
	  , [obj_a, obj_a, true]
	  , [obj_a, obj_b, false]
	  ]
	_test_func_a(eq_cases, GG.eq)
	_test_func_a(eq_cases, funcref(GG, "eq_"))

	# neq
	var neq_cases = \
	  [ [null, null, false]
	  , [1, 1, false]
	  , [1, 0, true]
	  , ["a", "a", false]
	  , ["a", "b", true]
	  , [obj_a, obj_a, false]
	  , [obj_a, obj_b, true]
	  ]
	_test_func_a(neq_cases, GG.neq)
	_test_func_a(neq_cases, funcref(GG, "neq_"))

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

	# floats_are_equal
	var floats_are_equal_cases = \
	[ [1.00001, 1, true]
	, [-1.1, -1, false]
	]
	_test_func_a(floats_are_equal_cases, GG.floats_are_equal)
	_test_func_a(floats_are_equal_cases, funcref(GG, "floats_are_equal_"))

	# size
	var size_cases = [
		[[], 0],
		[[1, 2], 2],
		["", 0],
		["aa", 2]
	]
	_test_func_a(size_cases, GG.size)
	_test_func_a(size_cases, funcref(GG, "size_"))

	var fmt_bool_cases = \
	[ [true, "true"]
	, [false, "false"]
	]
	_test_func_a(fmt_bool_cases, GG.fmt_bool)
	_test_func_a(fmt_bool_cases, funcref(GG, "fmt_bool_"))

func _test_array() -> void:
	# is_empty
	var is_empty_cases = \
	[ [[], true]
	, [[0], false]
	, [[null], false]
	, [[[]], false]
	, [[0, 1], false]
	]
	_test_arr_func_a(is_empty_cases, "_get_is_empty")
	_assert(G([]).is_empty, true)
	_assert(G([1]).is_empty, false)
	_assert(GG.is_empty_([]), true)
	_assert(GG.is_empty_([1]), false)

	# size
	var size_cases = \
	[ [[], 0]
	, [[0], 1]
	, [[null], 1]
	, [[[]], 1]
	, [[0, 1], 2]
	]
	_test_arr_func_a(size_cases, "_get_size")
	_assert(G([]).size, 0)
	_assert(G([null, []]).size, 2)

	# head_or_null
	var head_or_null_cases = [
		[[], null],
		[[1], 1],
		[[1, 2], 1],
	]
	_test_func_a(head_or_null_cases, GG.head_or_null)
	_test_func_a(head_or_null_cases, funcref(GG, "head_or_null_"))
	_test_arr_func_a(head_or_null_cases, "head_or_null")

	# last_or_null
	var last_or_null_cases = [
		[[], null],
		[[1], 1],
		[[1, 2], 2],
	]
	_test_func_a(last_or_null_cases, GG.last_or_null)
	_test_func_a(last_or_null_cases, funcref(GG, "last_or_null_"))
	_test_arr_func_a(last_or_null_cases, "last_or_null")

	# init
	var init_input = [1, 2, 3]
	_assert(GG.init_(init_input), [1, 2])
	_assert(init_input.size(), 3)
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
	_assert(GG.tail_(tail_input), [2, 3])
	_assert(tail_input.size(), 3)
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
		[[1, 2], ["a"], [[1, "a"]]],
	]
	_test_func_a(zip_cases, GG.zip)
	_test_func_a(zip_cases, funcref(GG, "zip_"))
	_test_arr_wrapped_func_a(zip_cases, "zip")

	# zip_with_index
	var zip_with_index_cases = [
		[[], []],
		[[5], [[5, 0]]],
		[[5, 6, 7], [[5, 0], [6, 1], [7, 2]]],
		[[true, false], [[true, 0], [false, 1]]]
	]
	_test_func_a(zip_with_index_cases, GG.zip_with_index)
	_test_func_a(zip_with_index_cases, funcref(GG, "zip_with_index_"))
	_test_arr_wrapped_func_a(zip_with_index_cases, "zip_with_index")

	# sample
	var sample_cases = [
		[[1], 1],
	]
	_test_func_a(sample_cases, GG.sample)
	_test_func_a(sample_cases, funcref(GG, "sample_"))
	_test_arr_func_a(sample_cases, "sample")
	var sample_input1 = [10,20]
	var sample_res1 = G(sample_input1).sample()
	assert(sample_input1.has(sample_res1))

	# sample_or_null
	var sample_or_null_cases = [
		[[], null],
		[[1], 1],
	]
	_test_func_a(sample_or_null_cases, GG.sample_or_null)
	_test_func_a(sample_or_null_cases, funcref(GG, "sample_or_null_"))
	_test_arr_func_a(sample_or_null_cases, "sample_or_null")
	var sample_or_null_input1 = [10,20]
	var sample_or_null_res1 = G(sample_or_null_input1).sample_or_null()
	assert(sample_or_null_input1.has(sample_or_null_res1))

	# take
	var take_cases = \
	  [ [[], 0, []]
	  , [[], 10, []]
	  , [[], -10, []]
	  , [[1, 2, 3], 0, []]
	  , [[1, 2, 3], 1, [1]]
	  , [[1, 2, 3], 2, [1, 2]]
	  , [[1, 2, 3], 3, [1, 2, 3]]
	  , [[1, 2, 3], 4, [1, 2, 3]]
	  ]
	_test_func_a(take_cases, GG.take)
	_test_func_a(take_cases, funcref(GG, "take_"))
	_test_arr_wrapped_func_a(take_cases, "take")

	# take_right
	var take_right_cases = \
	  [ [[], 0, []]
	  , [[], 10, []]
	  , [[], -10, []]
	  , [[1, 2, 3], 0, []]
	  , [[1, 2, 3], 1, [3]]
	  , [[1, 2, 3], 2, [2, 3]]
	  , [[1, 2, 3], 3, [1, 2, 3]]
	  , [[1, 2, 3], 4, [1, 2, 3]]
	  ]
	_test_func_a(take_right_cases, GG.take_right)
	_test_func_a(take_right_cases, funcref(GG, "take_right_"))
	_test_arr_wrapped_func_a(take_right_cases, "take_right")

	# take_while
	var take_while_cases = \
	  [ [[], "x => true", []]
	  , [[], "x => false", []]
	  , [[1], "x => x > 10", []]
	  , [[1], "x => x < 10", [1]]
	  , [[0, 1, 2, 3, 4], "x => x < 2", [0, 1]]
	  ]
	_test_func_a(take_while_cases, GG.take_while)
	_test_func_a(take_while_cases, funcref(GG, "take_while_"))
	_test_arr_wrapped_func_a(take_while_cases, "take_while")

	# drop
	var drop_cases = \
	  [ [[], 0, []]
	  , [[], 10, []]
	  , [[], -10, []]
	  , [[1, 2, 3], 0, [1, 2, 3]]
	  , [[1, 2, 3], 1, [2, 3]]
	  , [[1, 2, 3], 2, [3]]
	  , [[1, 2, 3], 3, []]
	  , [[1, 2, 3], 4, []]
	  ]
	_test_func_a(drop_cases, GG.drop)
	_test_func_a(drop_cases, funcref(GG, "drop_"))
	_test_arr_wrapped_func_a(drop_cases, "drop")

	# drop_right
	var drop_right_cases = \
	  [ [[], 0, []]
	  , [[], 10, []]
	  , [[], -10, []]
	  , [[1, 2, 3], 0, [1, 2, 3]]
	  , [[1, 2, 3], 1, [1, 2]]
	  , [[1, 2, 3], 2, [1]]
	  , [[1, 2, 3], 3, []]
	  , [[1, 2, 3], 4, []]
	  ]
	_test_func_a(drop_right_cases, GG.drop_right)
	_test_func_a(drop_right_cases, funcref(GG, "drop_right_"))
	_test_arr_wrapped_func_a(drop_right_cases, "drop_right")

	# drop_while
	var drop_while_cases = \
	  [ [[], "x => x > 0", []]
	  , [[1], "x => x > 0", []]
	  , [[0], "x => x > 0", [0]]
	  , [[1, 0], "x => x > 0", [0]]
	  , [[1, 0, 2], "x => x > 0", [0, 2]]
	  , [[0, 1, -1], "x => x > 0", [0, 1, -1]]
	  ]
	_test_func_a(drop_while_cases, GG.drop_while)
	_test_func_a(drop_while_cases, funcref(GG, "drop_while_"))
	_test_arr_wrapped_func_a(drop_while_cases, "drop_while")

	# drop_while_right
	var drop_while_right_cases = \
	  [ [[], "x => x > 0", []]
	  , [[1], "x => x > 0", []]
	  , [[0], "x => x > 0", [0]]
	  , [[1, 0], "x => x > 0", [1, 0]]
	  , [[0, 1], "x => x > 0", [0]]
	  , [[1, 0, 2], "x => x > 0", [1, 0]]
	  , [[0, 1, -1], "x => x > 0", [0, 1, -1]]
	  ]
	_test_func_a(drop_while_right_cases, GG.drop_while_right)
	_test_func_a(drop_while_right_cases, funcref(GG, "drop_while_right_"))
	_test_arr_wrapped_func_a(drop_while_right_cases, "drop_while_right")

	# reverse
	var reverse_cases = \
	  [ [[], []]
	  , [[1], [1]]
	  , [[1, 2, 3], [3, 2, 1]]
	  ]
	_test_func_a(reverse_cases, GG.reverse)
	_test_func_a(reverse_cases, funcref(GG, "reverse_"))
	_test_arr_wrapped_func_a(reverse_cases, "reverse")

	# without
	var without_cases = \
	  [ [[1], 0, [1]]
	  , [[], 0, []]
	  , [[1, 2, 3], 2, [1, 3]]
	  , [[1, 2, 1], 1, [2]]
	  ]
	_test_func_a(without_cases, GG.without)
	_test_func_a(without_cases, funcref(GG, "without_"))
	_test_arr_wrapped_func_a(without_cases, "without")

	# compact
	var compact_cases = \
	  [ [[1], [1]]
	  , [[], []]
	  , [[1, null, 3], [1, 3]]
	  , [[null, 2, null], [2]]
	  , [[null, 2, null, null], [2]]
	  , [[null, null, null], []]
	  ]
	_test_func_a(compact_cases, GG.compact)
	_test_func_a(compact_cases, funcref(GG, "compact_"))
	_test_arr_wrapped_func_a(compact_cases, "compact")

	# float_arr_to_int_arr
	var float_arr_to_int_arr_cases = \
	[ [[], []]
	, [[1.1], [1]]
	, [[1.0, 2.0], [1, 2]]
	]
	_test_func_a(float_arr_to_int_arr_cases, GG.float_arr_to_int_arr)
	_test_func_a(float_arr_to_int_arr_cases, funcref(GG, "float_arr_to_int_arr_"))
	_test_arr_wrapped_func_a(float_arr_to_int_arr_cases, "float_arr_to_int_arr")

func _test_call_spreaded():
	# call_spreaded
	_assert(GG.call_spread.call_func(funcref(self, "_sum0"), []), 0)
	_assert(GG.call_spread_(funcref(self, "_sum0"), []), 0)
	_assert(GG.call_spread_(funcref(self, "_sum1"), [1]), 1)
	_assert(GG.call_spread_(funcref(self, "_sum2"), [1, 2]), 3)
	_assert(GG.call_spread_(funcref(self, "_sum3"), [1, 2, 3]), 6)
	_assert(GG.call_spread_(funcref(self, "_sum4"), [1, 2, 3, 4]), 10)
	_assert(GG.call_spread_(funcref(self, "_sum5"), [1, 2, 3, 4, 5]), 15)
	_assert(GG.call_spread_(funcref(self, "_sum6"), [1, 2, 3, 4, 5, 6]), 21)
	_assert(GG.call_spread_(funcref(self, "_sum7"), [1, 2, 3, 4, 5, 6, 7]), 28)
	_assert(GG.call_spread_(funcref(self, "_sum8"), [1, 2, 3, 4, 5, 6, 7, 8]), 36)
	_assert(GG.call_spread_(funcref(self, "_sum9"), [1, 2, 3, 4, 5, 6, 7, 8, 9]), 45)
	_assert(GG.call_spread_(funcref(self, "_sum10"), [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]), 55)

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
	_assert(GG.capitalize_("flying1"), "Flying1")

	_assert(GG.snake_to_pascal_case_(""), "")
	_assert(GG.snake_to_pascal_case_("ahoy!"), "Ahoy!")
	_assert(GG.snake_to_pascal_case_("from_snake_case"), "FromSnakeCase")
	_assert(GG.snake_to_pascal_case_("test_a_num_1"), "TestANum1")
	_assert(GG.snake_to_pascal_case_("DETONATE_ON_TOUCH"), "DetonateOnTouch")

	_assert(GG.decapitalize_first_(""), "")
	_assert(GG.decapitalize_first_("ABC"), "aBC")
	_assert(GG.decapitalize_first_("a"), "a")

	_assert(GG.snake_to_camel_case_(""), "")
	_assert(GG.snake_to_camel_case_("from_snake_case"), "fromSnakeCase")
	_assert(GG.snake_to_camel_case_("DETONATE_ON_TOUCH"), "detonateOnTouch")

	_assert(GG.capitalize_all_(""), "")
	_assert(GG.capitalize_all_("abc"), "ABC")
	_assert(GG.capitalize_all_("XoYo"), "XOYO")
	_assert(GG.capitalize_all_("žluťoučký kůň"), "ŽLUŤOUČKÝ KŮŇ")

	_assert(GG.camel_to_snake_case_(""), "")
	_assert(GG.camel_to_snake_case_("pep"), "PEP")
	_assert(GG.camel_to_snake_case_("detonateOnTouch"), "DETONATE_ON_TOUCH")
	_assert(GG.camel_to_snake_case_("camelToSnakeCase"), "CAMEL_TO_SNAKE_CASE")

	# words
	var words_raw_cases = \
	  [ ["", []]
	  , ["a", ["a"]]
	  , ["a b", ["a", "b"]]
	  , ["a  b", ["a", "b"]]
	  , ["a\tb", ["a", "b"]]
	  , ["aaa  bb\nc", ["aaa", "bb", "c"]]
	  ]
	_test_func_a(words_raw_cases, GG.words_raw)
	_test_func_a(words_raw_cases, funcref(GG, "words_raw_"))

	_assert(GG.words_("a\tb   c 44  .").val, ["a", "b", "c", "44", "."])
	_assert(GG.words.call_func("a\tb   c 44  .").val, ["a", "b", "c", "44", "."])

	# unwords
	var unwords_raw_cases = \
	  [ [[], ""]
	  , [[""], ""]
	  , [["a"], "a"]
	  , [["a", "bb"], "a bb"]
	  , [["a", "b", "c", "44", "."], "a b c 44 ."]
	  ]
	_test_func_a(unwords_raw_cases, GG.unwords)
	_test_func_a(unwords_raw_cases, funcref(GG, "unwords_"))

	# lines
	var lines_raw_cases = \
	  [ ["", []]
	  , ["a", ["a"]]
	  , ["a\nb", ["a", "b"]]
	  , ["a\n\nb", ["a", "b"]]
	  , ["aaa\n\nbb\nc", ["aaa", "bb", "c"]]
	  , ["a a a\n\nb\tb\nč 4", ["a a a", "b\tb", "č 4"]]
	  ]
	_test_func_a(lines_raw_cases, GG.lines_raw)
	_test_func_a(lines_raw_cases, funcref(GG, "lines_raw_"))

	_assert(GG.lines_("aaa\n\nbb\nc").val, ["aaa", "bb", "c"])
	_assert(GG.lines.call_func("aaa\n\nbb\nc").val, ["aaa", "bb", "c"])

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

	# clampi
	var clampi_cases =\
	[ [5, 0, 10, 5]
	, [-1, 0, 10, 0]
	, [12, 0, 10, 10]
	]
	_test_func_a(clampi_cases, GG.clampi)
	_test_func_a(clampi_cases, funcref(GG, "clampi_"))

# ----------------------------------------------------------------------------------------------------------------------

func _const_1_(): return 1
var _const_1 = funcref(self, "_const_1_")
func _const_0_(): return 0
var _const_0 = funcref(self, "_const_0_")

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

	var bool_cases = \
	[ [t, 0, 1, 1]
	, [f, 0, 1, 0]
	]
	_test_func_a(bool_cases, GG.bool__)
	_test_func_a(bool_cases, funcref(GG, "bool_"))

	var bool_lazy_cases = \
	[ [t, "invalid_arg => 0", "=> 1", 1]
	, [f, _const_0, _const_1, 0]
	]
	_test_func_a(bool_lazy_cases, GG.bool_lazy)
	_test_func_a(bool_lazy_cases, funcref(GG, "bool_lazy_"))

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

func _test_rand() -> void:
	# rand_dir2
	for i in range(1000):
		var r = GG.rand_dir2_()
		var len_ = r.length()
		_assert(len_ <= 1.001, true)
		_assert(r.x >= -1 && r.x <= 1 && r.y >= -1 && r.y <= 1, true)

	# rand_dir3
	for i in range(1000):
		var r = GG.rand_dir3_()
		var len_ = r.length()
		_assert(len_ <= 1.001, true)
		_assert(r.x >= -1 && r.x <= 1 && r.y >= -1 && r.y <= 1 && r.z >= -1 && r.z <= 1, true)

	# rand_sign
	for i in range(100):
		var r = GG.rand_sign_()
		_assert([-1, 1].has(r), true)

	# rand_bool
	for i in range(100):
		var r = GG.rand_bool_()
		_assert([true, false].has(r), true)

	# rand_float
	var rand_float_min = false
	var rand_float_max = false
	var rand_float_iterations = 0
	for i in range(10000):
		rand_float_iterations = i
		var x = GG.rand_float_(5, 10)
		GG.assert_(x <= 10, "x <= 10")
		GG.assert_(x >= 5, "x >= 5")
		if x <= 5.01: rand_float_min = true
		if x >= 9.99: rand_float_max = true
		if rand_float_min && rand_float_max && i > 100: break
	# print(rand_float_iterations)
	GG.assert_(rand_float_min, "rand_float min")
	GG.assert_(rand_float_max, "rand_float max")
	_assert(GG.rand_float_(-10, -5) <= -5, true)

	# rand_int
	var rand_int_min = false
	var rand_int_max = false
	var rand_int_iterations = 0
	for i in range(100):
		rand_int_iterations = i
		var x = GG.rand_int_(5, 10)
		GG.assert_(x <= 10, "x <= 10")
		GG.assert_(x >= 5, "x >= 5")
		if x == 5: rand_int_min = true
		if x == 10: rand_int_max = true
		if rand_int_min && rand_int_max && i > 10: break
	# print(rand_int_iterations)
	GG.assert_(rand_int_min, "rand_int min")
	GG.assert_(rand_int_max, "rand_int max")
	_assert(GG.rand_int_(-10, -5) <= -5, true)

	# rand_float_r
	for i in range(10000):
		var v0:= GG.rand_float_r_(5)
		GG.assert_(v0 >= -5, "v0 >= -5")
		GG.assert_(v0 <= 5, "v0 <= 5")
		var v1:= GG.rand_float_r_(5, 10)
		GG.assert_(v1 >= 5, "v1 >= 5")
		GG.assert_(v1 <= 15, "v1 <= 15")

# ----------------------------------------------------------------------------------------------------------------------

func _test_object() -> void:
	# get_fld
	var get_fld_cases = [
		[{x = 1}, "x", 1],
		[T0.new(2, false), "b", false]
	]
	_test_func_a(get_fld_cases, GG.get_fld)
	_test_func_a(get_fld_cases, funcref(GG, "get_fld_"))

	# get_fld_or_else
	var get_fld_or_else_cases = [
		[null, "x", 1, 1],
		[{x = 1}, "x", 5, 1],
		[{x = 1}, "y", 5, 5],
		[T0.new(2, false), "b", true, false],
		[T0.new(2, false), "__b__", true, true],
	]
	_test_func_a(get_fld_or_else_cases, GG.get_fld_or_else)
	_test_func_a(get_fld_or_else_cases, funcref(GG, "get_fld_or_else_"))

	# get_fld_or_null
	var get_fld_or_null_cases = [
		[null, "x", null],
		[{x = 10}, "x", 10],
		[{x = 10}, "y", null],
		[T0.new(2, false), "b", false],
		[T0.new(2, false), "__b__", null],
	]
	_test_func_a(get_fld_or_null_cases, GG.get_fld_or_null)
	_test_func_a(get_fld_or_null_cases, funcref(GG, "get_fld_or_null_"))

	# keys
	var keys_cases = [ # keys in Objects and Dictionaries seem to retain order
		[null, null],
		[{}, []],
		[{a = 1, b = 2}, ["a", "b"]],
		[T0.new(2, false), ["Reference", "script", "Script Variables", "_x", "b"]]
	]
	_test_func_a(keys_cases, GG.keys)
	_test_func_a(keys_cases, funcref(GG, "keys_"))

	# key_from_val
	var key_from_val_cases = [
		[{}, 1, null],
		[{a = 1, b = 2}, 1, "a"],
		[T0.new(2, false), false, "b"],
		[T0.new(2, false), null, null],
	]
	_test_func_a(key_from_val_cases, GG.key_from_val)
	_test_func_a(key_from_val_cases, funcref(GG, "key_from_val_"))

	# pick
	var pick_cases = [
		[{}, [], {}],
		[{a = 1, b = false, c = "x"}, ["a", "c"], {a = 1, c = "x"}],
		[T0.new(2, false), ["b"], {b = false}]
	]
	_test_func_a(pick_cases, GG.pick)
	_test_func_a(pick_cases, funcref(GG, "pick_"))

	# omit
	var omit_cases = [
		[{}, [], {}],
		[{a = 1, b = false, c = "x"}, ["a", "c"], {b = false}],
	]
	_test_func_a(omit_cases, GG.omit)
	_test_func_a(omit_cases, funcref(GG, "omit_"))

	# assign_fields
	var assign_fields_case1_io1:= { a = 1, b = "x" }
	GG.assign_fields_(assign_fields_case1_io1, { a = 3 })
	_assert(assign_fields_case1_io1, { a = 3, b = "x" })

	var assign_fields_case2:= T0.new(4, false)
	GG.assign_fields.call_func(assign_fields_case2, { b = true })
	_assert(assign_fields_case2.b, true)

# ----------------------------------------------------------------------------------------------------------------------

func _test_merge() -> void:
	var merge_cases = [
		[{}, {}, {}],
		[{a = 1}, {}, {a = 1}],
		[{}, {a = 1}, {a = 1}],
		[{a = 1}, {b = true}, {a = 1, b = true}],
		[{a = 1}, {a = true}, {a = true}],
		[{a = 1}, {a = true, b = 7}, {a = true, b = 7}],
		[{a = 1, b = false, c = "c"}, {b = true, d = 9}, {a = 1, b = true, c = "c", d = 9}],
	]
	_test_func_a(merge_cases, GG.merge)
	_test_func_a(merge_cases, funcref(GG, "merge_"))

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

func _test_function_utils() -> void:
	_assert(GG.ap_if_defined_({}, "get_x_and_add", []), null)
	_assert(GG.ap_if_defined_(T0.new(3), "get_x_and_add", [2]), 5)
	_assert(GG.ap_if_defined_(GG, "add_", [2, 5]), 7)

	_assert(GG.const_(1).call_func("Gorn"), 1)
	_assert(GG.const__.call_func(1).call_func("Gorn"), 1)
	_assert(GG.const_("Resistance is futile!").call_func("Resist!"), "Resistance is futile!")

	var test_object:= { a = 1 }
	_assert(GG.key_from_val_(test_object, 1), "a")
	_assert(GG.flip_(GG.key_from_val).call_func(1, test_object), "a")
	_assert(G([0, 1, 2]).map(GG.subtract, 10).val, [-10, -9, -8])
	_assert(G([0, 1, 2]).map(GG.flip_(GG.subtract), 10).val, [10, 9, 8])
	_assert(G([0, 1, 2]).map("x, y => x - y", 10).val, [-10, -9, -8])
	_assert(G([0, 1, 2]).map(GG.flip_("x, y => x - y"), 10).val, [10, 9, 8])

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
		["x => 1", ["x", "=>", "1"]],
		["x=>x", ["x", "=>", "x"]],
		["DoggO:Object,Action:String=>Conan", ["DoggO:Object,Action:String", "=>", "Conan"]],
		["x, y => x + y", ["x, y", "=>", "x + y"]],
		["a, b, c => a.a * b.b - c.c()", ["a, b, c", "=>", "a.a * b.b - c.c()"]],
		["a: float, b: int,c:string=>a+b+c", ["a: float, b: int,c:string", "=>", "a+b+c"]],
		["a: float => a", ["a: float", "=>", "a"]],
		["a -> a.x = 0", ["a", "->", "a.x = 0"]],
		["=> 0", ["", "=>", "0"]]
	]
	_test_func_a(parse_fn_cases, funcref(GG.GGI, "parse_fn"))

	_assert(GG.GGI.function_expr_to_script_("x => x"), "tool\nfunc f(x):return x")
	_assert(GG.GGI.function_expr_to_script_("a: int, b: float => float(a) * b"), "tool\nfunc f(a: int, b: float):return float(a) * b")

	_assert(GG.GGI.function_("x => x").call_func(1), 1)
	_assert(GG.GGI.function_("a,b=>a*b").call_func(2, 3), 6)

	_assert(F_raw("x => x.b").call_func({b = true}), true)
	_assert(F_raw("x => x.b").call_func(T0.new(0, true)), true)

	var o1 = { x = 0 }
	_assert(o1, { x = 0 })
	GG.GGI.function_("a -> a.x = 72").call_func(o1)
	_assert(o1, { x = 72 })
	GG.GGI.function_("a:   Dictionary  ->  a.x  =  42  ").call_func(o1)
	_assert(o1, { x = 42 })
	GG.GGI.function_("a:Dictionary->a.x=69").call_func(o1)
	_assert(o1, { x = 69 })

# ----------------------------------------------------------------------------------------------------------------------

func _test_date() -> void:
	var date = {day = 1, dst = false, hour = 3, minute = 9, month = 9, second = 6, weekday = 4, year = 2010}
	var date_str = "2010-09-01--03-09-06"
	_assert(GG.format_datetime_(date), date_str)
	_assert(GG.format_datetime.call_func(date), date_str)

# ----------------------------------------------------------------------------------------------------------------------

func _test_flatten() -> void:
	var flatten_raw_cases = \
	  [ [ [], [] ]
	  , [ [[], []] , []]
	  , [ [[1, 2], [3]], [1, 2, 3] ]
	  ]
	_test_func_a(flatten_raw_cases, GG.flatten)
	_test_func_a(flatten_raw_cases, funcref(GG, "flatten_"))
	_test_arr_wrapped_func_a(flatten_raw_cases, "flatten_raw")

	var flatten_cases = \
	  [ [ [], [] ]
	  , [ [G([]), G([])] , []]
	  , [ [G([1, 2]), G([3])], [1, 2, 3] ]
	  ]
	_test_arr_wrapped_func_a(flatten_cases, "flatten")

# ----------------------------------------------------------------------------------------------------------------------

func _test_func_compostition_utils() -> void:
	# pipe
	var pipe_cases = \
	  [ [null, [], null]
	  , [true, [GG.id], true]
	  , ["spock", [GG.capitalize], "Spock"]
	  , [[1, 2], [[GG.take, 1], "xs => xs[0] * 10"], 10]
	  , [-1, ["x => x + 4", GG.with_ctx(GG.multiply, 2), GG.id, funcref(GG, "id_")], 6]
	  , [0, [GG.inc, GG.inc], 2]
	  ]
	_test_func_a(pipe_cases, GG.pipe)
	_test_func_a(pipe_cases, funcref(GG, "pipe_"))

	# flow
	_assert(GG.flow_([]).call_func(null), null)
	_assert(GG.flow_([GG.id]).call_func("Dante"), "Dante")
	_assert(GG.flow_([GG.capitalize]).call_func("dante"), "Dante")
	_assert(GG.flow_([[GG.take, 1], "x => x[0] * 10"]).call_func([1, 2]), 10)
	var flow_complex = GG.flow_(["x => x + 4", GG.with_ctx(GG.multiply, 2), GG.id, funcref(GG, "id_")])
	_assert(flow_complex.call_func(-1), 6)
	_assert(flow_complex.call_func(-3), 2)
	_assert(GG.flow_([flow_complex, flow_complex]).call_func(10), 64)

# ----------------------------------------------------------------------------------------------------------------------

var tap_test = 0

func _set_tap_test(x): tap_test = x

func _test_tap() -> void:
	_assert(_set_tap_test(0), null)
	_assert(tap_test, 0)
	_assert(GG.tap_(7, funcref(self, "_set_tap_test")), 7)
	# GG.tap_(7, "x => print(x)")
	_assert(tap_test, 7)

	_assert(_set_tap_test(0), null)
	_assert(tap_test, 0)
	_assert(G([1]).tap(funcref(self, "_set_tap_test")).map("x => x + 1").val, [2])
	_assert(tap_test, [1])

# ----------------------------------------------------------------------------------------------------------------------

func _test_min_max() -> void:
	var min_cases = \
	[ [[], null]
	, [[1], 1]
	, [[1, 0, 2], 0]
	]
	_test_func_a(min_cases, GG.min__)
	_test_func_a(min_cases, funcref(GG, "min_"))
	_test_arr_func_a(min_cases, "min")

	var max_cases = \
	[ [[], null]
	, [[1], 1]
	, [[1, 0, 2], 2]
	]
	_test_func_a(max_cases, GG.max__)
	_test_func_a(max_cases, funcref(GG, "max_"))
	_test_arr_func_a(max_cases, "max")

# ----------------------------------------------------------------------------------------------------------------------

func _test_average() -> void:
	var average_cases = \
	[ [[], null]
	, [[1], 1]
	, [[1, 0, 2], 1]
	, [[4.0, 6.0, 5.0], 5.0]
	, [[0.0, 1.0], 0.5]
	]
	_test_func_a(average_cases, GG.average)
	_test_func_a(average_cases, funcref(GG, "average_"))
	_test_arr_func_a(average_cases, "average")

# ----------------------------------------------------------------------------------------------------------------------

func _test_sum_product() -> void:
	var sum_cases = \
	  [ [[], 0]
	  , [[1], 1]
	  , [[3, 4], 7]
	  , [[2, 3, 5], 10]
	  ]
	_test_func_a(sum_cases, GG.sum)
	_test_func_a(sum_cases, funcref(GG, "sum_"))
	_test_arr_func_a(sum_cases, "sum")

	var product_cases = \
	  [ [[], 1]
	  , [[1], 1]
	  , [[3, 4], 12]
	  , [[2, 3, 5], 30]
	  ]
	_test_func_a(product_cases, GG.product)
	_test_func_a(product_cases, funcref(GG, "product_"))
	_test_arr_func_a(product_cases, "product")

	var all_cases = \
	  [ [[], GG.id, true]
	  , [[true], GG.id, true]
	  , [[true, false], GG.id, false]
	  , [[1, 2], "x => x > 0", true]
	  , [[1, 0], "x => x > 0", false]
	  ]
	_test_func_a(all_cases, GG.all)
	_test_func_a(all_cases, funcref(GG, "all_"))
	_test_arr_func_a(all_cases, "all")

	var any_cases = \
	  [ [[], GG.id, false]
	  , [[true], GG.id, true]
	  , [[true, false], GG.id, true]
	  , [[1, 2], "x => x > 0", true]
	  , [[1, 0], "x => x > 0", true]
	  , [[-1, 0], "x => x > 0", false]
	  ]
	_test_func_a(any_cases, GG.any)
	_test_func_a(any_cases, funcref(GG, "any_"))
	_test_arr_func_a(any_cases, "any")

# ----------------------------------------------------------------------------------------------------------------------

func _test_insertion_concatenation() -> void:
	var append_cases = \
	  [ [ [], null, [null] ]
	  , [ [1], 2, [1, 2] ]
	  , [ [false, false], true, [false, false, true] ]
	  ]
	_test_func_a(append_cases, GG.append)
	_test_func_a(append_cases, funcref(GG, "append_"))
	_test_arr_wrapped_func_a(append_cases, "append")
	var append_mut_test = [1]
	G(append_mut_test).append(2)
	_assert(append_mut_test, [1])

	var prepend_cases = \
	  [ [ [], null, [null] ]
	  , [ [1], 2, [2, 1] ]
	  , [ [false, false], true, [true, false, false] ]
	  ]
	_test_func_a(prepend_cases, GG.prepend)
	_test_func_a(prepend_cases, funcref(GG, "prepend_"))
	_test_arr_wrapped_func_a(prepend_cases, "prepend")
	var prepend_mut_test = [1]
	G(prepend_mut_test).prepend(2)
	_assert(prepend_mut_test, [1])

	var concat_cases = \
	  [ [ [], [], [] ]
	  , [ [1], [2], [1, 2] ]
	  , [ [], [2], [2] ]
	  , [ [1], [], [1] ]
	  , [ [false, false], [true, true], [false, false, true, true] ]
	  ]
	_test_func_a(concat_cases, GG.concat)
	_test_func_a(concat_cases, funcref(GG, "concat_"))
	_test_arr_wrapped_func_a(concat_cases, "concat")
	var concat_mut_test = [1]
	G(concat_mut_test).concat([2])
	_assert(concat_mut_test, [1])

	var concat_left_cases = \
	  [ [ [], [], [] ]
	  , [ [1], [2], [2, 1] ]
	  , [ [], [2], [2] ]
	  , [ [1], [], [1] ]
	  , [ [false, false], [true, true], [true, true, false, false] ]
	  ]
	_test_func_a(concat_left_cases, GG.concat_left)
	_test_func_a(concat_left_cases, funcref(GG, "concat_left_"))
	_test_arr_wrapped_func_a(concat_left_cases, "concat_left")
	var concat_left_mut_test = [1]
	G(concat_left_mut_test).concat_left([2])
	_assert(concat_left_mut_test, [1])

# ----------------------------------------------------------------------------------------------------------------------

func _test_array_generators() -> void:
	var replicate_cases = \
	[ [0, 0, []]
	, [1, 2, [1, 1]]
	, ["a", 1, ["a"]]
	, ["a", -4, []]
	]
	_test_func_a(replicate_cases, GG.replicate)
	_test_func_a(replicate_cases, funcref(GG, "replicate_"))

	var new_array_cases = \
	[ [0, [], []]
	, [0, [1], [0]]
	, [0, [3], [0, 0, 0]]
	, [0, [1, 1], [[0]]]
	, [ 0, [1, 2], [[0, 0]] ]
	, [ 0, [3, 2, 3], [  [[0,0,0],[0,0,0]], [[0,0,0],[0,0,0]], [[0,0,0],[0,0,0]]  ] ]
	, [ "x", [2, 3], [["x", "x", "x"], ["x", "x", "x"]] ]
	, [2, [4, 3, 2], [[[2,2],[2,2],[2,2]],[[2,2],[2,2],[2,2]],[[2,2],[2,2],[2,2]],[[2,2],[2,2],[2,2]]] ]
	, [ 2, [4, 3, 2, 1], [[[[2],[2]],[[2],[2]],[[2],[2]]],[[[2],[2]],[[2],[2]],[[2],[2]]],[[[2],[2]],[[2],[2]],[[2],[2]]],[[[2],[2]],[[2],[2]],[[2],[2]]]] ]
	]
	_test_func_a(new_array_cases, GG.new_array)
	_test_func_a(new_array_cases, funcref(GG, "new_array_"))
	var na_1:= GG.new_array_(0, [2, 1])
	_assert(na_1, [[0], [0]])
	na_1[0][0] = 1
	_assert(na_1, [[1], [0]])

	var generate_array_cases = \
	[ [GG.id, [], []]
	, [GG.id, [1], [[0]] ]
	, ["x => x", [3], [[0], [1], [2]] ]
	, ["x => x[0] * 10 + x[1]", [2, 3], [  [0, 1, 2], [10, 11, 12]  ] ]
	, ["x => str(x[0]) + \"x\" + str(x[1])", [3, 2], [  ["0x0", "0x1"], ["1x0", "1x1"], ["2x0", "2x1"]  ] ]
	]
	_test_func_a(generate_array_cases, GG.generate_array)
	_test_func_a(generate_array_cases, funcref(GG, "generate_array_"))
	var ga_1:= GG.generate_array_("xy => 0", [2, 1])
	_assert(ga_1, [[0], [0]])
	ga_1[0][0] = 1
	_assert(ga_1, [[1], [0]])

# ----------------------------------------------------------------------------------------------------------------------

func _test_batch_field_access() -> void:
	# get_fields

	var dict = {x = 2, y = true}
	var dict_vals = GG.get_fields_(dict, ["x", "y"])
	_assert(dict_vals, [2, true])
	var dict_vals2 = GG.get_fields.call_func(dict, ["x", "y"])
	_assert(dict_vals2, [2, true])

	var obj = T0.new(2, true)
	var obj_vals = GG.get_fields_(obj, ["_x", "b"])
	_assert(obj_vals, [2, true])
	var obj_vals2 = GG.get_fields.call_func(obj, ["_x", "b"])
	_assert(obj_vals2, [2, true])

	# set_fields
	GG.set_fields_(dict, [69, false], ["x", "y"])
	_assert(dict.x, 69)
	_assert(dict.y, false)

	GG.set_fields_(obj, [22, false], ["_x", "b"])
	_assert(dict.x, 69)
	_assert(dict.y, false)

# ----------------------------------------------------------------------------------------------------------------------

func _test_grouping() -> void:
	var group_with_cases:=\
	[ [ [], "x=>x", [] ]
	, [ [0], "x=>x", [[0]] ]
	, [ [0, 0], "x=>x", [[0, 0]] ]
	, [ [0, 0, 1], "x=>x", [[0, 0], [1]] ]
	, [ [1, 0, 1], "x=>x", [[1], [0], [1]] ]
	, [ [1, 0, 0], "x=>x", [[1], [0, 0]] ]
	, [ [t, f, f, t], "x=>x", [[t], [f, f], [t]] ]
	, [ [{name = "Walt", rank = 0}, {name = "Muffy", rank = 0}, {name = "Yen", rank = 1}], "x => x.rank", [[{name = "Walt", rank = 0}, {name = "Muffy", rank = 0}], [{name = "Yen", rank = 1}]] ]
	]
	_test_func_a(group_with_cases, GG.group_with)
	_test_func_a(group_with_cases, funcref(GG, "group_with_"))
	_assert(G([t, f, f, t]).group_with("x => x").map("x=>x.val").val, [[t], [f, f], [t]])

# ----------------------------------------------------------------------------------------------------------------------

func _test_transpose() -> void:
	var transpose_cases:=\
	[  [  [ [1] ], [ [1] ]  ]
	,  [  [ [1, 2] ], [ [1], [2] ]  ]
	,  [  [ [1, 2], [3, 4] ], [ [1, 3], [2, 4] ]  ]
	,  [  [ [1, 2, 3], [4, 5, 6], [7, 8, 9] ], [ [1, 4, 7], [2, 5, 8], [3, 6, 9] ]  ]
	]
	_test_func_a(transpose_cases, GG.transpose)
	_test_func_a(transpose_cases, funcref(GG, "transpose_"))
	_assert(G([[1, 2]]).transpose().map("x=>x.val").val, [[1], [2]])
	_assert(G([[1, 2], [3, 4]]).transpose().map("x=>x.val").val, [[1, 3], [2, 4]])

# ----------------------------------------------------------------------------------------------------------------------

func _test_set_operations() -> void:
	var intersect_cases:=\
	[ [ [], [], [] ]
	, [ [1], [], [] ]
	, [ [], [1], [] ]
	, [ [1], [1], [1] ]
	, [ [true], [false, true], [true] ]
	, [ [true, false], [false, true], [true, false] ]
	, [ [0, 1, 2], [10, 1, 20, 0], [0, 1] ]
	]
	_test_func_a(intersect_cases, GG.intersect)
	_test_func_a(intersect_cases, funcref(GG, "intersect_"))
	_test_arr_wrapped_func_a(intersect_cases, "intersect")
	_assert(G([1]).intersect(G([0, 1])).val, [1])
	_assert(G([1]).intersect([0, 1]).val, [1])

	var union_cases:=\
	[ [ [], [], [] ]
	, [ [1], [], [1] ]
	, [ [], [1], [1] ]
	, [ [1], [1], [1] ]
	, [ [1, 2], [1], [1, 2] ]
	, [ [0, 1], [1, 2], [0, 1, 2] ]
	, [ [0, 1, 2], [10, 1, 20, 0], [0, 1, 2, 10, 20] ]
	]
	_test_func_a(union_cases, GG.union)
	_test_func_a(union_cases, funcref(GG, "union_"))
	_test_arr_wrapped_func_a(union_cases, "union")
	_assert(G([1]).union(G([0, 1])).val, [1, 0])
	_assert(G([1]).union([0, 1]).val, [1, 0])

	var difference_cases:=\
	[ [ [], [], [] ]
	, [ [1], [], [1] ]
	, [ [], [1], [] ]
	, [ [1], [1], [] ]
	, [ [1, 2], [1], [2] ]
	, [ [0, 1], [1, 2], [0] ]
	, [ [0, 1, 2], [10, 1, 20, 0], [2] ]
	]
	_test_func_a(difference_cases, GG.difference)
	_test_func_a(difference_cases, funcref(GG, "difference_"))
	_test_arr_wrapped_func_a(difference_cases, "difference")
	_assert(G([1]).difference(G([0, 1])).val, [])
	_assert(G([1]).difference([0, 1]).val, [])

# ----------------------------------------------------------------------------------------------------------------------

func _test_uniq() -> void:
	var nub_cases:=\
	[ [ [], [] ]
	, [ [1], [1] ]
	, [ [1, 1], [1] ]
	, [ [1, 1, 2], [1, 2] ]
	, [ [1, 1, 2, 2, 2], [1, 2] ]
	, [ ["a", "a", "b", "a"], ["a", "b", "a"] ]
	, [ [t, f, f, f, t, t, f], [t, f, t, f] ]
	]
	_test_func_a(nub_cases, GG.nub)
	_test_func_a(nub_cases, funcref(GG, "nub_"))
	_test_arr_wrapped_func_a(nub_cases, "nub")

	var uniq_cases:=\
	[ [ [], [] ]
	, [ [1], [1] ]
	, [ [1, 1], [1] ]
	, [ [1, 1, 2], [1, 2] ]
	, [ [1, 1, 2, 2, 2], [1, 2] ]
	, [ ["a", "a", "b", "a"], ["a", "b"] ]
	, [ [t, f, f, f, t, t, f], [t, f] ]
	, [ ["x", "a", "a"], ["x", "a"] ]
	]
	_test_func_a(uniq_cases, GG.uniq)
	_test_func_a(uniq_cases, funcref(GG, "uniq_"))
	_test_arr_wrapped_func_a(uniq_cases, "uniq")

func _test_elem() -> void:
	var elem_cases:=\
	[ [[], 0, false]
	, [[0], 0, true]
	, [[0], 1, false]
	, [range(10), 5, true]
	]
	_test_func_a(elem_cases, GG.elem)
	_test_func_a(elem_cases, funcref(GG, "elem_"))
	_test_arr_func_a(elem_cases, "elem")

func _test_not_elem() -> void:
	var not_elem_cases:=\
	[ [[], 0, true]
	, [[0], 0, false]
	, [[0], 1, true]
	, [range(10), 5, false]
	]
	_test_func_a(not_elem_cases, GG.not_elem)
	_test_func_a(not_elem_cases, funcref(GG, "not_elem_"))
	_test_arr_func_a(not_elem_cases, "not_elem")

func _test_valid_index() -> void:
	var valid_index_cases:=\
	[ [[], 0, false]
	, [[], -1, false]
	, [[], 1, false]
	, [[0], 0, true]
	, [[0], 1, false]
	, [[0], -1, false]
	]
	_test_func_a(valid_index_cases, GG.valid_index)
	_test_func_a(valid_index_cases, funcref(GG, "valid_index_"))
	_test_arr_func_a(valid_index_cases, "valid_index")

func _test_format() -> void:
	var format_float_2_cases = \
	[ [null, "Null"]
	, [1.23456, "1.23"]
	, [1.239, "1.24"]
	, [-1.23456, "-1.23"]
	]
	_test_func_a(format_float_2_cases, GG.format_float_2)
	_test_func_a(format_float_2_cases, funcref(GG, "format_float_2_"))

	var format_vec2_2_cases = \
	[ [null, "Null"]
	, [Vector2(1.2345, 0), "1.23, 0.00"]
	]
	_test_func_a(format_vec2_2_cases, GG.format_vec2_2)
	_test_func_a(format_vec2_2_cases, funcref(GG, "format_vec2_2_"))

	var format_vec3_2_cases = \
	[ [null, "Null"]
	, [Vector3(1.2345, 0, 7), "1.23, 0.00, 7.00"]
	]
	_test_func_a(format_vec3_2_cases, GG.format_vec3_2)
	_test_func_a(format_vec3_2_cases, funcref(GG, "format_vec3_2_"))

	var format_time_cases = \
	[ [0, "00:00:00"]
	, [60, "00:01:00"]
	, [60*60, "01:00:00"]
	, [81, {format = GG.TimeFormat.MINUTES | GG.TimeFormat.SECONDS}, "01:21"]
	, [81, {format = GG.TimeFormat.MINSEC}, "01:21"]
	, [62, {digit_format = "%d"}, "0:1:2"]
	, [0, {delim = "•"}, "00•00•00"]
	, [45296, "12:34:56"]
	, [0.1, "00:00:00"]
	, [62.1, {format = GG.TimeFormat.MINSECMILI}, "01:02.10"]
	, [0.2, {format = GG.TimeFormat.MILISECONDS}, ".20"]
	, [0.3, {seconds_format = "Q%.1fQ"}, "00:00:Q0.3Q"]
	, [45296.7, {hours_format = "H = %d", minutes_format = "M = %d", seconds_format = "S = %.1f", delim = " | "}, "H = 12 | M = 34 | S = 56.7"]
	]
	_test_func_a(format_time_cases, GG.format_time)
	_test_func_a(format_time_cases, funcref(GG, "format_time_"))

# ----------------------------------------------------------------------------------------------------------------------

func _test_cmd_args() -> void:
	var parse_cmd_args_cases = \
	[ [ [], {} ]
	, [ ["scene.tscn"], {} ]
	, [ ["scene.tscn", "--cheats=on"], {cheats = "on"} ]
	, [ ["--debug=true", "--godmode=off"], {debug = "true", godmode = "off"} ]
	, [ ["--debug", "--godmode"], {debug = true, godmode = true} ]
	]
	_test_func_a(parse_cmd_args_cases, GG.parse_cmd_args)
	_test_func_a(parse_cmd_args_cases, funcref(GG, "parse_cmd_args_"))

# ----------------------------------------------------------------------------------------------------------------------

func _test_json_reading() -> void:
	var res1 = GG.read_json_file_or_error_("res://goldenGadget/test_json_1.json")
	_assert(res1, { result = {field = "value"}, error = OK })

	var res2 = GG.read_json_file_or_error_("not_existing_file.json")
	_assert(res2, { result = null, error = ERR_FILE_NOT_FOUND, message = "failed to open JSON file \"not_existing_file.json\": 7" })

	if !_skip_tests_triggering_godots_spam_bug:
		var res3 = GG.read_json_file_or_error_("res://goldenGadget/test_json_2.json")
		_assert(res3, {
			result = null,
			error = ERR_PARSE_ERROR,
			error_string = "Expected 'true','false' or 'null', got 'not'.",
			error_line = 0,
			message = "failed to parse JSON file - 0: Expected 'true','false' or 'null', got 'not'."
		})

	_assert(GG.read_json_file_or_error.call_func("res://goldenGadget/test_json_1.json"), { result = {field = "value"}, error = OK })

	_assert(GG.read_json_file_or_null_("res://goldenGadget/test_json_1.json"), {field = "value"})
	if !_skip_tests_triggering_godots_spam_bug:
		_assert(GG.read_json_file_or_null_("res://goldenGadget/test_json_2.json"), null)
	_assert(GG.read_json_file_or_null_("not_existing_file.json"), null)

# ----------------------------------------------------------------------------------------------------------------------

func _test_vector_utils() -> void:
	var vec2_cases = \
	[ [2, Vector2(2, 2)],
	  [1, 2, Vector2(1, 2)]
	]
	_test_func_a(vec2_cases, GG.vec2)
	_test_func_a(vec2_cases, funcref(GG, "vec2_"))

	var vec3_cases = \
	[ [2, Vector3(2, 2, 2)],
	  [1, 2, 3, Vector3(1, 2, 3)]
	]
	_test_func_a(vec3_cases, GG.vec3)
	_test_func_a(vec3_cases, funcref(GG, "vec3_"))

# ----------------------------------------------------------------------------------------------------------------------

func _test_input_event_dict() -> void:
	# InputEventKey
	var key_evt:= InputEventKey.new()
	key_evt.scancode = 1
	key_evt.physical_scancode = 2
	key_evt.alt = true
	key_evt.shift = true
	key_evt.control = true
	key_evt.meta = true
	key_evt.command = true
	var key_evt_ser = GG.input_event_to_dict_(key_evt)
	_assert(key_evt_ser, {
		type = "key",
		scancode = 1,
		physical_scancode = 2,
		alt = true,
		shift = true,
		control = true,
		meta = true,
		command = true,
	})
	var key_evt_deser = GG.dict_to_input_event_(key_evt_ser)
	_assert(key_evt_deser is InputEventKey, true)
	_assert(key_evt_deser.scancode, 1)
	_assert(key_evt_deser.physical_scancode, 2)
	_assert(key_evt_deser.alt, true)
	_assert(key_evt_deser.shift, true)
	_assert(key_evt_deser.control, true)
	_assert(key_evt_deser.meta, true)
	_assert(key_evt_deser.command, true)

	# InputEventJoypadButton
	var jbut_evt:= InputEventJoypadButton.new()
	jbut_evt.button_index = 1
	var jbut_evt_ser = GG.input_event_to_dict_(jbut_evt)
	_assert(jbut_evt_ser, {
		type = "joypadButton",
		button_index = 1
	})
	var jbut_evt_deser = GG.dict_to_input_event_(jbut_evt_ser)
	_assert(jbut_evt_deser is InputEventJoypadButton, true)
	_assert(jbut_evt_deser.button_index, 1)

	# InputEventJoypadMotion
	var jmot_evt:= InputEventJoypadMotion.new()
	jmot_evt.axis = 1
	jmot_evt.axis_value = 0.5
	var jmot_evt_ser = GG.input_event_to_dict_(jmot_evt)
	_assert(jmot_evt_ser, {
		type = "joypadMotion",
		axis = 1,
		axis_value = 0.5
	})
	var jmot_evt_deser = GG.dict_to_input_event_(jmot_evt_ser)
	_assert(jmot_evt_deser is InputEventJoypadMotion, true)
	_assert(jmot_evt_deser.axis, 1)
	_assert(jmot_evt_deser.axis_value, 0.5)

# ----------------------------------------------------------------------------------------------------------------------

func _test_color() -> void:
	_assert(GG.shift_hue_(Color.magenta, 0), Color.magenta)
	_assert(GG.shift_hue_(Color.magenta, 1), Color.magenta)
	_assert(GG.shift_hue_(Color.magenta, -1), Color.magenta)
	_assert(GG.shift_hue_(Color.red, 0.5), Color.cyan)
	_assert(GG.shift_hue_(Color.red, -0.5), Color.cyan)
	_assert(GG.shift_hue_(Color.red, 60.0/360.0), Color.yellow)
	_assert(GG.shift_hue_(Color.red, 120.0/360.0), Color.green)
	_assert(GG.shift_hue_(Color.red, -60.0/360.0), Color.magenta)
	_assert(GG.shift_hue_(Color.red, -120.0/360.0), Color.blue)

# ----------------------------------------------------------------------------------------------------------------------

func _test_debug() -> void:
	_assert(GG.debug_(1, "_test_debug GG"), 1)
	_assert(G([1]).debug("_test_debug GGA").val, [1])

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

	_assert(weak_alive_monsters_imperative, ["Demon"])
	_assert(weak_alive_monsters, ["Demon"])

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
	_assert(names_of_alive_monsters, ["Demon", "Amus"])
	_assert(monsters.size(), 4) # original monster list is not mutated (changed)

	# ------------------------------------------------------------------------------------------------------------------

	# Names of Weak and Alive monsters example

	# imperative solution
	var weak_alive_monsters_imperative = []
	for monster in monsters:
		if monster.is_alive && monster.hp < 10:
			weak_alive_monsters_imperative.push_back(monster.name)
	_assert(weak_alive_monsters_imperative, ["Demon"])
	_assert(monsters.size(), 4)

	# functional approach, uses lambdas (anonymous functions)
	var weak_alive_monsters = G(monsters).filter("x => x.is_alive && x.hp < 10").map_fld("name").val
	_assert(weak_alive_monsters, ["Demon"])
	_assert(monsters.size(), 4)

	# ------------------------------------------------------------------------------------------------------------------

	# an older approach of a similar problem
	var names_of_spongy_monsters = G(monsters).filter_fn(F_raw("x => x.hp >= 10")).map_fld("name").val
	_assert(names_of_spongy_monsters, ["Amus"])
	_assert(monsters.size(), 4)

	# ------------------------------------------------------------------------------------------------------------------

	# Take 3 first words and capitalize them

	var text_input = "Morbi id mauris pep erisus. Aenean."

	var three_words_capitalized = GG.pipe_(text_input, [\
	  GG.words_raw, # ["Morbi", "id", "mauris", "pep", "erisus.", "Aenean."]
	  [GG.take, 3], # ["Morbi", "id", "mauris"]
	  [GG.map, GG.capitalize], # ["Morbi", "Id", "Mauris"]
	  GG.unwords # "Morbi Id Mauris"
	])
	_assert(three_words_capitalized, "Morbi Id Mauris")

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
