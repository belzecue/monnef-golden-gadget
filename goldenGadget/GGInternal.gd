extends Resource

class_name GGInternal

func crash_(msg: String) -> void:
	print("crash:", msg)
	assert(false)

func assert_(cond: bool, msg: String) -> void: if !cond: crash_(msg)

func head_(arr: Array): return arr[0] if arr.size() > 0 else null

func last_(arr: Array): return arr[arr.size() - 1] if arr.size() > 0 else null

func tail_(arr: Array):
	if arr.size() == 0: return null
	var r = arr.duplicate()
	r.pop_front()
	return r

func init_(arr: Array):
	if arr.size() == 0: return null
	var r = arr.duplicate()
	r.pop_back()
	return r

func get_fld_(obj, field_name: String): return obj[field_name]

func size_(x):
	if x is Array: return x.size()
	if x is String: return x.length()
	crash_("size is allowed only for Array and String")

func sort_(arr: Array) -> Array:
	var res = arr.duplicate()
	res.sort()
	return res

func _sort_by_workaround(a, b, f: FuncRef): return f.call_func(a, b)

func sort_by_(arr: Array, f: FuncRef) -> Array:
	var res = arr.duplicate()
	var wrapped_f = CtxFRef2.new(funcref(self, "_sort_by_workaround"), f)
	res.sort_custom(wrapped_f, "call_func")
	return res

func _sort_by_fld_helper(a, b, field_name: String) -> bool: return a[field_name] < b[field_name]

func sort_by_fld_(arr: Array, field_name: String) -> Array:
	var sort_f = CtxFRef2.new(funcref(self, "_sort_by_fld_helper"), field_name)
	return sort_by_(arr, sort_f.ref)

func _cmp_snd(a: Array, b: Array) -> bool: return a[1] < b[1]

func sort_with_(arr: Array, map_f: FuncRef) -> Array:
	var with_vals = []
	for x in arr: with_vals.push_back([x, map_f.call_func(x)])
	var sorted = sort_by_(with_vals, funcref(self, "_cmp_snd"))
	var res = []
	for x in sorted: res.push_back(x[0])
	return res

func zip_(a: Array, b: Array) -> Array:
	var r = []
	for i in range(0, min(a.size(), b.size())): r.push_back([a[i], b[i]])
	return r

func fst_(pair: Array): return pair[0]

func snd_(pair: Array): return pair[1]

func eqd_(a, b) -> bool:
	# TODO: better?
	return to_json(a) == to_json(b)

func compile_script_(src: String):
	var script = GDScript.new()
	script.set_source_code(src)
	script.reload()
	var obj = Reference.new()
	obj.set_script(script)
	return obj

var lambda_regex

func parse_fn(expr: String) -> Array:
	if lambda_regex == null:
		lambda_regex = RegEx.new()
		lambda_regex.compile("^((?:[a-zA-Z_]+(?:\\s*:\\s*)?(?:\\s*,\\s*)?)*)\\s*=>\\s*(.*)$")
	var found = lambda_regex.search(expr)
	if found == null: crash_("Failed to parse lambda expression: %s" % expr)
	return [found.get_string(1), found.get_string(2)]

func function_expr_to_script_(expr: String) -> String:
	var parsed = parse_fn(expr); var args = parsed[0]; var body = parsed[1] # how I miss destructioning...
	var src = "func f(%s):return %s" % [args, body]
	return src

var _function_cache = {}

# context?

func function_(expr: String) -> FuncRef:
	var scr
	if expr in _function_cache:
		scr = _function_cache[expr]
	else:
		var src = function_expr_to_script_(expr)
		scr = compile_script_(src)
		_function_cache[expr] = scr
	return funcref(scr, "f")
