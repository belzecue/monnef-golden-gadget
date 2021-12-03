# Golden Gadget


## GoldenGadget.gd<span id="GoldenGadget"></span>

If some function is undocumented here (e.g. [size_](#size_--GoldenGadget)), please see documentation of [GGArray](#GGArray).  
  
`FuncLike<A, B>` means function-like value which represents a function taking one argument of type `A` and returns value of type `B`.  

---

### func <span id="arr--GoldenGadget"></span>`arr`(`array`) -> `GGArray`
Wraps `Array` into [GGArray](#GGArray).  
Recommended "import" (code at a start of a file we want to use the `arr` in):  
`func G(arr) -> GGArray: return GG.arr(arr)`  

**Parameters**: \
`arr`: `Array<T>` array to wrap

**Returns**: `GGArray<T>` wrapped array

---

### func <span id="quit_--GoldenGadget"></span>`quit_`(`error_code`: `int` = `0`) -> `void`
Terminate/halt/quit program.  

**Parameters**: \
`error_code`: `int` Exit code returned from the Godot process (0 means normal exit, >0 means an error)

---

### func <span id="assert_--GoldenGadget"></span>`assert_`(`cond`: `bool`, `msg`: `String`) -> `void`
Assert condition is `true`, terminate program with error message otherwise.  

---

### func <span id="assert_eq_--GoldenGadget"></span>`assert_eq_`(`actual`, `expected`, `note`: `String` = `""`) -> `void`
Assert two values are equal (using [eqd](#eqd--GoldenGadget)).  

---

### func <span id="crash_--GoldenGadget"></span>`crash_`(`msg`: `String`) -> `void`
Terminate program with error message.  

---

### func <span id="l_and_--GoldenGadget"></span>`l_and_`(`x`: `bool`, `y`: `bool`) -> `bool`
logical and  

---

### func <span id="l_or_--GoldenGadget"></span>`l_or_`(`x`: `bool`, `y`: `bool`) -> `bool`
logical or  

---

### func <span id="add_--GoldenGadget"></span>`add_`(`x`: `int`, `y`: `int`) -> `int`
adds two values  

---

### func <span id="subtract_--GoldenGadget"></span>`subtract_`(`x`: `int`, `y`: `int`) -> `int`
subtracts second argument from first  

---

### func <span id="a_and_--GoldenGadget"></span>`a_and_`(`x`: `Array`) -> `bool`
`and` operation performed on array of bools  

**Parameters**: \
`x`: `Array<bool>` 

**Returns**: `bool` 

---

### func <span id="a_or_--GoldenGadget"></span>`a_or_`(`x`: `Array`) -> `bool`
`or` operation performed on array of `bool`s  

**Parameters**: \
`x`: `Array<bool>` 

**Returns**: `bool` 

---

### func <span id="eq_--GoldenGadget"></span>`eq_`(`a`, `b`) -> `bool`
shallow equality check  

---

### func <span id="neq_--GoldenGadget"></span>`neq_`(`a`, `b`) -> `bool`
shallow not-equality check  

---

### func <span id="eqd_--GoldenGadget"></span>`eqd_`(`a`, `b`) -> `bool`
deep equality check  

---

### func <span id="eq_field_--GoldenGadget"></span>`eq_field_`(`object`, `args`) -> `bool`
determines equality (==) of a field (given name and value in args parameter) in object (first parameter)  

---

### func <span id="call_spread_--GoldenGadget"></span>`call_spread_`(`f`: `FuncRef`, `arr`: `Array`)
Invoke a function with parameters given in array.  

---

### func <span id="snake_to_pascal_case_--GoldenGadget"></span>`snake_to_pascal_case_`(`x`: `String`) -> `String`
Convert string from snake to pascal case  

---

### func <span id="snake_to_camel_case_--GoldenGadget"></span>`snake_to_camel_case_`(`x`: `String`) -> `String`
Convert string from snake to camel case.  

---

### func <span id="camel_to_snake_case_--GoldenGadget"></span>`camel_to_snake_case_`(`x`: `String`) -> `String`
Convert string from camel to snake case.  

---

### func <span id="capitalize_--GoldenGadget"></span>`capitalize_`(`x`: `String`) -> `String`
Capitalize string - convert first character to upper case and all other to lower case.  

---

### func <span id="capitalize_first_--GoldenGadget"></span>`capitalize_first_`(`x`: `String`) -> `String`
Capitalize first character of string (doesn't touch other characters).  

---

### func <span id="capitalize_all_--GoldenGadget"></span>`capitalize_all_`(`x`: `String`) -> `String`
Capitalize all characters.  

---

### func <span id="decapitalize_first_--GoldenGadget"></span>`decapitalize_first_`(`x`: `String`) -> `String`
Decapitalize first character of string (doesn't touch other characters).  

---

### func <span id="noop1_--GoldenGadget"></span>`noop1_`(`x`) -> `void`
Do nothing.  

**Parameters**: \
`x`: `any` 

---

### func <span id="noop2_--GoldenGadget"></span>`noop2_`(`x`, `y`) -> `void`
Do nothing.  

**Parameters**: \
`x`: `any` \
`y`: `any` 

---

### func <span id="noop3_--GoldenGadget"></span>`noop3_`(`x`, `y`, `z`) -> `void`
Do nothing.  

**Parameters**: \
`x`: `any` \
`y`: `any` \
`z`: `any` 

---

### func <span id="noop4_--GoldenGadget"></span>`noop4_`(`x`, `y`, `z`, `a`) -> `void`
Do nothing.  

**Parameters**: \
`x`: `any` \
`y`: `any` \
`z`: `any` \
`a`: `any` 

---

### func <span id="multiply_--GoldenGadget"></span>`multiply_`(`x`, `y`)
Multiple two numbers.  

---

### func <span id="modulo_--GoldenGadget"></span>`modulo_`(`x`, `y`)
Calculate modulo of two numbers (of same type).  

**Parameters**: \
`x`: `int | float` First number\
`y`: `int | float` Second number

**Returns**: `int | float` Modulo of input numbers, has same type.

---

### func <span id="inc_--GoldenGadget"></span>`inc_`(`x`)
Add one to a given number.  

---

### func <span id="dec_--GoldenGadget"></span>`dec_`(`x`)
Subtract one from a given number.  

---

### func <span id="negate_num_--GoldenGadget"></span>`negate_num_`(`x`)
Negate given number.  

---

### func <span id="negate_--GoldenGadget"></span>`negate_`(`x`: `bool`) -> `bool`
Logic not.  

---

### func <span id="get_fld_--GoldenGadget"></span>`get_fld_`(`obj`, `field_name`)
Get a value in a given field.  
Crashes on a missing field.  

**Parameters**: \
`obj`: `Object | Dictionary` \
`field_name`: `String` 

**Returns**: `any` 

---

### func <span id="get_fld_or_else_--GoldenGadget"></span>`get_fld_or_else_`(`obj`, `field_name`, `default`)
Get a value in a given field. If the field is missing, return a given default value.  

**Parameters**: \
`obj`: `Object | Dictionary` \
`field_name`: `String` \
`default`: `any` 

**Returns**: `any` 

---

### func <span id="get_fld_or_null_--GoldenGadget"></span>`get_fld_or_null_`(`obj`, `field_name`)
Get a value in a given field. If the field is missing, return `null`.  

**Parameters**: \
`obj`: `Object | Dictionary` \
`field_name`: `String` \
`default`: `any` 

**Returns**: `any` 

---

### func <span id="merge_--GoldenGadget"></span>`merge_`(`default`: `Dictionary`, `donor`: `Dictionary`) -> `Dictionary`
Merge two dictionaries.  

**Parameters**: \
`default`: `Dictionary` Base dictionary\
`donor`: `Dictionary` Dictionary to be merged into base (overrides same fields)

**Returns**: `Dictionary` New merged dictionary

---

### func <span id="fst_--GoldenGadget"></span>`fst_`(`pair`: `Array`)
Get a first item in a pair.  

---

### func <span id="snd_--GoldenGadget"></span>`snd_`(`pair`: `Array`)
Get a second item in a pair.  

---

### func <span id="compile_script_--GoldenGadget"></span>`compile_script_`(`src`: `String`)
Compile script and return new instance of it.  

---

### func <span id="compile_function_--GoldenGadget"></span>`compile_function_`(`expr`: `String`) -> `FuncRef`
Compile a script with one function, instantiate the script and return a `funcref` of the function.  

---

### func <span id="F_--GoldenGadget"></span>`F_`(`f`)
Create function-like object depending on type of `f`.  
* `FuncRef` - pass same value  
* `String` - compiles function and returns its `FuncRef`  
`"x => x + 1"` ~ get `FuncRef` of `func f(x): return x + 1`  
* `Array` - partial application (creates `CtxFRef1`)  
`["x, y => x + y", 1]` which is functionally equivalent to `"x => x + 1"`  

**Parameters**: \
`f`: `FuncRef | String | Array<any>` 

**Returns**: `FuncRef | CtxFRef1` 

---

### func <span id="flip_--GoldenGadget"></span>`flip_`(`f`)
Flip arguments of given two-argument function.  

**Parameters**: \
`f`: `FuncLike<A, B, R>` 

**Returns**: `FuncLike<B, A, R>` 

**Examples**: \
`GG.flip_("x, y => x - y")` has same meaning in GG as `"y, x => x - y"`\
`G([0, 1, 2]).map("x, y => x - y", 10).val` return `[-10, -9, -8]`, in the map call the function with context is equivalent to `x => x - 10`\
`G([0, 1, 2]).map(GG.flip_("x, y => x - y"), 10).val` return `[10, 9, 8]`, in the map call the function with context is equivalent to `x => 10 - x`\
`G([0, 1, 2]).map(GG.flip_(GG.subtract), 10).val` returns `[10, 9, 8]`

---

### func <span id="keys_--GoldenGadget"></span>`keys_`(`obj`)
Get keys of `Dictionary` or `Object`.  

**Parameters**: \
`obj`: `Dictionary | Object` 

**Returns**: `Array<String>` 

**Examples**: \
`GG.keys_({a = 1, b = 2})` returns `["a", "b"]`

---

### func <span id="key_from_val_--GoldenGadget"></span>`key_from_val_`(`obj`, `val`)
Get key by given value. Supports `Dictionary` and `Object` (custom classes).  
Useful for finding a name of an enum item from an item value.  

**Parameters**: \
`obj`: `Dictionary | Object` \
`val`: `any` 

**Returns**: `any | null` Returns `null` if value is not found.

**Examples**: \
`GG.key_from_val_({a = 1, b = 2}, 1)` returns `"a"`.

---

### func <span id="ap_if_defined_--GoldenGadget"></span>`ap_if_defined_`(`obj`, `method_name`: `String`, `args`: `Array`)
Call a method when the method exists and return its result, otherwise return `null`.  

**Parameters**: \
`obj`: `Object` Object owning the method\
`method_name`: `String` Object owning the method\
`args`: `Array<any>` Arguments to pass to the method

**Returns**: `any` What method returned, or `null` when `obj` is `null` or `obj` has no such method

**Examples**: \
`GG.ap_if_defined_(GG, "add_", [2, 5])` returns `7`\
`GG.ap_if_defined_(GG, "_non_existing_method", [2, 5])` returns `null`

---

### func <span id="sample_--GoldenGadget"></span>`sample_`(`arr`: `Array`)
Get a random item from an array.  
Crashes on an empty array.  

**Type parameters**: \
`T`: `any` type of items in the array

**Parameters**: \
`arr`: `Array<T>` the input array

**Returns**: `T` a randomly picked item

**Examples**: \
`sample_([1, 2])` returns `1` or `2` with equal chance\
`sample_([])` crashes

---

### func <span id="sample_or_null_--GoldenGadget"></span>`sample_or_null_`(`arr`: `Array`)
Get a random item from an array.  

**Type parameters**: \
`T`: `any` type of items in the array

**Parameters**: \
`arr`: `Array<T>` the input array

**Returns**: `T | null` a random item, or null for an empty array

**Examples**: \
`sample_or_null_([1, 2])` returns `1` or `2` with equal chance\
`sample_or_null_([])` returns always `null`

---

### func <span id="format_datetime_--GoldenGadget"></span>`format_datetime_`(`date` = `null`) -> `String`
Format `DateTime` (if no provided, current will be used) in following format: `YYYY-MM-DD--HH-MM-SS`  

**Parameters**: \
`date`: `DateTime | null` 

**Returns**: `String` 

**Examples**: \
Possible output: `"2019-12-19--13-03-18"`

---

### func <span id="format_time_--GoldenGadget"></span>`format_time_`(`time`: `float`, `options`: `Dictionary` = `<<TODO: ELit (LDictionary [])>>`) -> `String`
Format time.  
Options:  
* `format`           - default `TimeFormat.DEFAULT` (hours + minutes + seconds)  
* `delim`            - delimiter, default `":"`  
* `digit_format`     - default `"%02d"`  
* `hours_format`     - default is `digit_format`  
* `minutes_format`   - default is `digit_format`  
* `seconds_format`   - default is `digit_format` (or `"%05.2f"` when TimeFormat.MILISECONDS is in `format`)  

**Parameters**: \
`time`: `float` Time in seconds\
`options`: `Dictionary` 

**Examples**: \
`GG.format_time_(0)` returns `"00:00:00"`\
`GG.format_time_(45296)` returns `"12:34:56"`\
`GG.format_time_(81, {format = GG.TimeFormat.MINSEC})` returns `"01:21"`\
`GG.format_time_(62.1, {format = GG.TimeFormat.MINSECMILI})` returns `"01:02.10"`\
`GG.format_time_(81, {format = GG.TimeFormat.MINUTES | GG.TimeFormat.SECONDS})` returns `"01:21"`\
`GG.format_time_(62, {digit_format = "%d"})` returns `"0:1:2"`\
`GG.format_time_(0, {delim = "•"})` returns `"00•00•00"`\
`GG.format_time_(45296.7, {hours_format = "H = %d", minutes_format = "M = %d", seconds_format = "S = %.1f", delim = " | "})` returns `"H = 12 | M = 34 | S = 56.7"`

---

### func <span id="floats_are_equal_--GoldenGadget"></span>`floats_are_equal_`(`x`: `float`, `y`: `float`, `eps` = `1.0e-4`) -> `bool`
Test if two `float` values are same (within margin of `eps`).  

**Parameters**: \
`x`: `float` first value\
`y`: `float` second value\
`eps`: `float` accepted margin

**Returns**: `bool` 

---

### func <span id="format_float_2_--GoldenGadget"></span>`format_float_2_`(`x`) -> `String`
Format `float` to 2 decimal places.  

**Parameters**: \
`x`: `float | null` 

**Returns**: `String` 

**Examples**: \
`format_float_2_(1.23456)` returns `"1.23"`

---

### func <span id="format_vec2_2_--GoldenGadget"></span>`format_vec2_2_`(`x`) -> `String`
Format `Vector2` to 2 decimal places.  

**Parameters**: \
`x`: `Vector2 | null` 

**Returns**: `String` 

**Examples**: \
`format_vec2_2_(Vector2(1.2345, 0))` returns `"1.23, 0.00"`

---

### func <span id="format_vec3_2_--GoldenGadget"></span>`format_vec3_2_`(`x`) -> `String`
Format `Vector3` to 2 decimal places.  

**Parameters**: \
`x`: `Vector3 | null` 

**Returns**: `String` 

**Examples**: \
`format_vec3_2_(Vector3(1.2345, 0, 7))` returns `"1.23, 0.00, 7.00"`

---

### func <span id="take_screenshot_--GoldenGadget"></span>`take_screenshot_`(`options`: `Dictionary` = `<<TODO: ELit (LDictionary [])>>`) -> `Dictionary`
Save a screenshot.  
Optionally takes an options dictionary:  
* `quiet`          - when true silence all console output  
* `dir`            - overrides screenshot directory (default is `"user://screenshots"`, expanded for example like this: `"/home/user/.local/share/godot/app_userdata/project/screenshots"`)  
Returns dictionary with following fields:  
* `dir`            - screenshot directory. Example: `"/home/user/.local/share/godot/app_userdata/project/screenshots"`  
* `result`         - Error code, use OK constant to test if taking screenshot was successful. Example: `12`  
* `stage`          - last reached stage, either `"create_dir"` or `"save"`. Example: `"save"`  
* `file_name`      - image file name (without directory). Example: `"2019-12-19--13-20-35.png"`  
* `full_file_name` - full path to screenshot file. Example: `"/home/user/.local/share/godot/app_userdata/project/screenshots/2019-12-19--13-20-35.png"`  

---

### func <span id="delete_children_--GoldenGadget"></span>`delete_children_`(`parent`: `Node`) -> `void`
Delete all children of a given parent (calls `queue_free` on children).  

---

### func <span id="get_children_rec_--GoldenGadget"></span>`get_children_rec_`(`parent`: `Node`) -> `Array`
Get recursively all children.  

**Parameters**: \
`parent`: `Node` 

**Returns**: `Array<Node>` 

---

### func <span id="set_node_parent_--GoldenGadget"></span>`set_node_parent_`(`child`: `Node`, `new_parent`: `Node`) -> `Node`
Set a parent of a node. Similar to `add_child`, but allows adding nodes which already have a parent (aka reparent).  

**Parameters**: \
`child`: `Node` Node of which parent will be set\
`new_parent`: `Node` New parent node

**Returns**: `Node` Child node

---

### func <span id="get_node_or_crash_--GoldenGadget"></span>`get_node_or_crash_`(`parent`, `path`) -> `Node`
Safer `get_node` alternative which will crash when a parent, a path or a node are `null`/empty.  

**Parameters**: \
`parent`: `Node | null` Of which node we want to retrieve a child\
`path`: `NodePath | null` Path to a child

**Returns**: `Node | null` Child node or `null` on failure

---

### func <span id="get_node_or_null_--GoldenGadget"></span>`get_node_or_null_`(`parent`, `path`)
Get a child node. If there is any problem, return `null`.  

**Parameters**: \
`parent`: `Node | null` Of which node we want to retrieve a child\
`path`: `NodePath | String | null` Path to a child

**Returns**: `Node | null` Child node or `null` on failure

---

### func <span id="get_nth_parent_--GoldenGadget"></span>`get_nth_parent_`(`start`: `Node`, `level`: `int`)
Get nth parent from a node.  

---

### func <span id="create_timer_and_start_--GoldenGadget"></span>`create_timer_and_start_`(`on`: `Node`, `method_name`: `String`, `time`: `float`, `one_shot` = `true`) -> `Timer`
Create a `Timer` node, connect timeout signal to the method and start.  

**Parameters**: \
`on`: `Node` Parent node for `Timer`, contains callback method\
`method_name`: `String` Name of a method which is called after timer finishes\
`time`: `float` Amount of time in seconds before callback method is called\
`one_shot`: `bool` Should the new `Timer` run in one-shot mode? If it does, `Timer` is destroyed after time elapses, otherwise `Timer` remains.

**Returns**: `Timer` New `Timer` node

---

### func <span id="words_raw_--GoldenGadget"></span>`words_raw_`(`x`: `String`) -> `Array`
Split a string to an array of words.  

**Parameters**: \
`x`: `String` Input string

**Returns**: `Array<String>` words

**Examples**: \
`words_raw_("a  b")` will return `["a", "b"]`.

---

### func <span id="words_--GoldenGadget"></span>`words_`(`x`: `String`) -> `GGArray`
Split a string to an array of words.  

**Parameters**: \
`x`: `String` Input string

**Returns**: `GGArray<String>` words

**Examples**: \
`words_("a  b")` will return `arr(["a", "b"])`.

---

### func <span id="unwords_--GoldenGadget"></span>`unwords_`(`xs`: `Array`) -> `String`
Join words array to one string  

**Parameters**: \
`xs`: `Array<String>` Input array of words

**Returns**: `String` Joined words

**Examples**: \
`unwords_(["a", "b"])` returns `"a b"`

---

### func <span id="lines_raw_--GoldenGadget"></span>`lines_raw_`(`x`: `String`) -> `Array`
Split string with new line sequences to an array of lines  
Same as [lines_](#lines_--GoldenGadget), but returns `Array<String>` instead of `GGArray<String>`.  

---

### func <span id="lines_--GoldenGadget"></span>`lines_`(`x`: `String`) -> `GGArray`
Split string with new line sequences to an array of lines  

**Parameters**: \
`x`: `String` Input text

**Returns**: `GGArray<String>` Array containing lines as items (without new line sequences)

**Examples**: \
`lines_("a\n\nb")` returns `arr(["a", "b"])`

---

### func <span id="unlines_--GoldenGadget"></span>`unlines_`(`xs`: `Array`) -> `String`
Join an array of lines to a string.  

**Examples**: \
`unlines_(["a", "b"])` returns `"a\nb"`

---

### func <span id="pipe_--GoldenGadget"></span>`pipe_`(`input`, `functions`: `Array`, `options` = `null`)
Calls first function with given input then sequentially takes a result from a previous function and passes it to a next one.  
Supports lambdas (string, e.g. `"x => x + 1"`) and partial application of 2 argument functions (e.g. `[GG.take, 2]`)  
Options dictionary fields:  
* print - if `true` then input, middle values and result is printed  

**Examples**: \
`pipe_(0, [inc_, inc_])` returns `2`, it is equivalent to `inc_(inc_(0))`.\
`pipe_([1, 2], [[GG.take, 1], "xs => xs[0] * 10"])` returns `10`, it is equivalent to `take_([1, 2], 1)[0] * 10`.

---

### func <span id="flow_--GoldenGadget"></span>`flow_`(`functions`: `Array`)
Similar to [pipe_](#pipe_--GoldenGadget), but returns "piped" function composed from all passed functions.  
If you intend to call the resulting function immediately, use rather [pipe_](#pipe_--GoldenGadget) for better performance.  

---

### func <span id="id_--GoldenGadget"></span>`id_`(`x`)
Identity function - returns same value it got in an argument.  

**Type parameters**: \
`T`: `any` 

**Parameters**: \
`x`: `T` Input value

**Returns**: `T` Same value as on input

---

### func <span id="const_--GoldenGadget"></span>`const_`(`x`)
Construct a function accepting one argument.  
This new function ignores passed argument and always returns `x` (an argument it was created with).  

**Type parameters**: \
`T`: `any` 

**Parameters**: \
`x`: `T` Value to be returned from constructed function

**Returns**: `FuncLike<any, T>` 

**Examples**: \
`const_(1).call_func("Gorn")` returns `1`\
`const_("Resistance is futile!").call_func("Resist!")` returns `"Resistance is futile!"`

---

### func <span id="tap_--GoldenGadget"></span>`tap_`(`x`, `f`)
Call function-like `f` with `x`, return `x` (ignore return value of `f`).  

**Type parameters**: \
`T`: `any` 

**Parameters**: \
`x`: `T` Input value\
`f`: `FuncLike<T, any>` Function accepting input value

**Returns**: `T` Input value `x`

---

### func <span id="fmt_bool_--GoldenGadget"></span>`fmt_bool_`(`x`: `bool`) -> `String`
Format bool (default formatting uses upper-case, this function uses lower-case).  

**Parameters**: \
`x`: `bool` Input value

**Returns**: `String` Formatted value

---

### func <span id="replicate_--GoldenGadget"></span>`replicate_`(`x`, `n`: `int`) -> `Array`
Create an array of length `n` where all items are `x`.  

**Type parameters**: \
`T`: `any` 

**Parameters**: \
`x`: `T` Item used for filling the array\
`n`: `int` Number of items

**Returns**: `Array<T>` 

**Examples**: \
`replicate_("a", 3)` returns `["a", "a", "a"]`

---

### func <span id="new_array_--GoldenGadget"></span>`new_array_`(`zero`, `dimensions`: `Array`) -> `Array`
Create an n-dimensional array and fill its every cell with given `zero` value  

**Type parameters**: \
`T`: `any` 

**Parameters**: \
`zero`: `T` Value to assign to all cells\
`dimensions`: `Array<int>` Dimensions (lengths) of new nested array.

**Returns**: `Array<any>` Nested (n-dimensional) array

**Examples**: \
`new_array_(0, [1])` returns `[0]`\
`new_array_(0, [3])` returns `[0, 0, 0]`\
`new_array_(0, [1, 2])` returns `[[0, 0]]`\
`new_array_("x", [2, 3])` returns `[["x", "x", "x"], ["x", "x", "x"]]`

---

### func <span id="generate_array_--GoldenGadget"></span>`generate_array_`(`cell_value_getter`, `dimensions`: `Array`) -> `Array`
Create an n-dimensional array and fill its every cell with a value returned by `cell_value_getter`.  

**Type parameters**: \
`T`: `any` 

**Parameters**: \
`cell_value_getter`: `FuncLike<Array<int>, T>` Function which accepts coordinates (array of numbers) and returns a value for a cell on those coordinates\
`dimensions`: `Array<int>` Dimensions (lengths) of new nested array.

**Returns**: `Array<any>` Nested (n-dimensional) array

**Examples**: \
`generate_array_(GG.id, [3])` returns `[[0], [1], [2]]`\
`generate_array_("x => x[0] * 10 + x[1]", [2, 3])` returns `[ [0, 1, 2], [10, 11, 12] ]`

---

### func <span id="float_arr_to_int_arr_--GoldenGadget"></span>`float_arr_to_int_arr_`(`arr`: `Array`) -> `Array`
Convert array of floats to array of integers. Useful for correcting parsed JSONs.  

**Parameters**: \
`arr`: `Array<float>` 

**Returns**: `Array<int>` 

**Examples**: \
`float_arr_to_int_arr_([1.0, 2.0])` returns `[1, 2]`

---

### func <span id="get_fields_--GoldenGadget"></span>`get_fields_`(`obj`, `field_names`: `Array`) -> `Array`
Get field values from given object/dictionary as an array (indices of output array matches those of input array)  

**Parameters**: \
`obj`: `Object | Dictionary` Input value\
`field_names`: `Array<String>` Names of fields to read values from

**Returns**: `Array<any>` Read values of given fields

**Examples**: \
`get_fields_({x = 2, y = true}, ["x", "y"])` returns `[2, true]`

---

### func <span id="set_fields_--GoldenGadget"></span>`set_fields_`(`obj`, `values`: `Array`, `field_names`: `Array`) -> `void`
Set field values of object/dictionary according to arrays of values and field names (indices of arrays match).  

**Parameters**: \
`obj`: `Object | Dictionary` Target for setting values on\
`values`: `Array<any>` List of values\
`field_names`: `Array<string>` List of corresponding field names

**Returns**: `void` 

**Examples**: \
`var dict = {x = 2, y = true}; GG.set_fields_(dict, [69, false], ["x", "y"])` results in `dict` to be equal to `{x = 69, y = false}`

---

### func <span id="bool_--GoldenGadget"></span>`bool_`(`cond`: `bool`, `on_false`, `on_true`)
Return `on_false`/`on_true` depending on value of `cond`  

**Type parameters**: \
`T`: `any` Return type

**Parameters**: \
`cond`: `bool` Condition\
`on_false`: `T` Value to return when `cond` is `false`\
`on_true`: `T` Value to return when `cond` is `true`

**Returns**: `T` 

**Examples**: \
`bool_(true, 0, 1)` returns `1`\
`bool_(x == 0, "not zero", "is zero")` returns `"is zero"` when `x` is `0`, otherwise returns `"not zero"`

---

### func <span id="bool_lazy_--GoldenGadget"></span>`bool_lazy_`(`cond`: `bool`, `on_false`, `on_true`)
Same as [bool_](#bool_--GoldenGadget), but `on_false`/`on_true` are functions.  
Only selected function will be called and its return value will be returned from `bool_lazy`.  

**Type parameters**: \
`T`: `any` Return type

**Parameters**: \
`cond`: `bool` Condition\
`on_false`: `FuncLike<T>` Function to call and return its result when `cond` is `false`\
`on_true`: `FuncLike<T>` Function to call and return its result when `cond` is `true`

**Returns**: `T` 

---

### func <span id="pause_one_--GoldenGadget"></span>`pause_one_`(`node`: `Node`, `value`: `bool`) -> `void`
Pause specific node. Disables all processing by a given node.  

**Parameters**: \
`node`: `Node` Branch to pause.\
`value`: `bool` True means pause, false means resume (unpause)

---

### func <span id="pause_--GoldenGadget"></span>`pause_`(`node`: `Node`, `value`: `bool`) -> `void`
Pause a branch starting with given node (recursive variant of [pause_one_](#pause_one_--GoldenGadget)).  

**Parameters**: \
`node`: `Node` Branch to pause.\
`value`: `bool` True means pause, false means resume (unpause)

---

### func <span id="rand_dir2_--GoldenGadget"></span>`rand_dir2_`() -> `Vector2`
Get random direction 2D vector.  

---

### func <span id="rand_dir3_--GoldenGadget"></span>`rand_dir3_`() -> `Vector3`
Get random direction 3D vector.  

---

### func <span id="rand_vec2_--GoldenGadget"></span>`rand_vec2_`(`from` = `<<TODO: EFuncCall (EVarRef "Vector2") [EANeg (ELit (LInt 1)),EANeg (ELit (LInt 1))]>>`, `to` = `<<TODO: EFuncCall (EVarRef "Vector2") [ELit (LInt 1),ELit (LInt 1)]>>`) -> `Vector2`
Get random 2D vector.  

---

### func <span id="rand_sign_--GoldenGadget"></span>`rand_sign_`()
Get randomly `1` or `-1`.  

---

### func <span id="rand_bool_--GoldenGadget"></span>`rand_bool_`()
Get random `bool`.  

---

### func <span id="rand_float_--GoldenGadget"></span>`rand_float_`(`from`: `float`, `to`: `float`) -> `float`
Get random `float` from range [`from`, `to`].  

**Examples**: \
`rand_float_(1, 2)` may return `1.7324`

---

### func <span id="rand_float_r_--GoldenGadget"></span>`rand_float_r_`(`radius`: `float`, `center`: `float` = `0.0`) -> `float`
Get random `float` from `center` and maximum difference of `radius`.  

**Examples**: \
`rand_float_r_(5)` may return `-2.4271` (random number from -5 to 5)

---

### func <span id="rand_int_--GoldenGadget"></span>`rand_int_`(`from`: `int`, `to`: `int`) -> `int`
Get random `int` from range [`from`, `to`] (including both endpoints).  

**Examples**: \
`rand_int_(1, 5)` may return `5`

---

### func <span id="randc_--GoldenGadget"></span>`randc_`() -> `Color`
Get random opaque color (alpha set to 1).  

**Returns**: `Color` 

---

### func <span id="randca_--GoldenGadget"></span>`randca_`() -> `Color`
Get random color (alpha is random).  

**Returns**: `Color` 

---

### func <span id="dir_to2_--GoldenGadget"></span>`dir_to2_`(`from`: `Node2D`, `to`: `Node2D`) -> `Vector2`
Get direction between two `Node2D`s.  

---

### func <span id="dir_to3_--GoldenGadget"></span>`dir_to3_`(`from`: `Spatial`, `to`: `Spatial`) -> `Vector3`
Get direction between two `Spatial`s.  

---

### func <span id="vec2_--GoldenGadget"></span>`vec2_`(`x`: `int`, `y` = `null`) -> `Vector2`
Construct [Vector2](#Vector2). If second parametr is not given, use first parametr twice.  

**Parameters**: \
`x`: `int` \
`y`: `int | null` 

**Examples**: \
`vec2_(2)` returns `Vector2(2, 2)`

---

### func <span id="vec3_--GoldenGadget"></span>`vec3_`(`x`: `int`, `y` = `null`, `z` = `null`) -> `Vector3`
Construct [Vector3](#Vector3). If second and third parametr is omitted, use first parametr thrice.  
Only allowed combinations of filled (non-null) arguments are x and x+y+z, otherwise crash ensues.  

**Parameters**: \
`x`: `int` \
`y`: `int | null` \
`z`: `int | null` 

**Examples**: \
`vec3_(2)` returns `Vector3(2, 2, 2)`

---

### func <span id="clampi_--GoldenGadget"></span>`clampi_`(`value`: `int`, `min_val`: `int`, `max_val`: `int`) -> `int`
Limit given integer number to specified range.  

---

### func <span id="absi_--GoldenGadget"></span>`absi_`(`value`: `int`) -> `int`
Get absolute value of an integer (distance from zero).  

---

### func <span id="is_empty_--GoldenGadget"></span>`is_empty_`(`arr`: `Array`) -> `bool`
Is given array empty?  

---

### func <span id="read_json_file_or_crash_--GoldenGadget"></span>`read_json_file_or_crash_`(`path`: `String`, `error_tag` = `""`)
Read JSON from file. Crash on error.  

**Parameters**: \
`path`: `String` Path to JSON file

**Returns**: `Dictionary` Parsed JSON

---

### func <span id="read_json_file_or_null_--GoldenGadget"></span>`read_json_file_or_null_`(`path`: `String`)
Read JSON from file.  

**Parameters**: \
`path`: `String` Path to JSON file

**Returns**: `Dictionary | null` Parsed JSON

---

### func <span id="read_json_file_or_error_--GoldenGadget"></span>`read_json_file_or_error_`(`path`: `String`) -> `Dictionary`
Read JSON from file. Return object describing result.  
Returns dictionary with following fields:  
* `result`             - parsed JSON from file (a `Dictionary`), or `null` on error. Example: `{field = "value"}`  
* `message`            - error message. Example: `"TODO"`  
* `error`              - error number from `file.open` or `JSON.parse`  
* `error_line`         - error line from `JSON.parse` error  
* `error_string`       - error string from `JSON.parse` error  

**Parameters**: \
`path`: `String` Path to JSON file

**Returns**: `Dictionary` 

---

### <span id="in_editor--GoldenGadget"></span>var `in_editor`: `bool`
Is code running inside editor (in `tool` mode)?  

---

### func <span id="load_relative_--GoldenGadget"></span>`load_relative_`(`script`: `Node`, `path`: `String`)
Load resource relative to directory of given script  

---

### func <span id="anim_get_progress_--GoldenGadget"></span>`anim_get_progress_`(`anim`: `AnimatedSprite`) -> `float`
Get progress of current animation in AnimatedSprite  

**Returns**: `float` Progress of animation, interval [0, 1)

---

### func <span id="pick_--GoldenGadget"></span>`pick_`(`obj`, `fields`: `Array`) -> `Dictionary`
Contruct a new dictionary from given list of fields of a given object/dictionary.  

**Parameters**: \
`obj`: `Object | Dictionary` \
`fields`: `Array<String>` 

**Returns**: `Dictionary` 

---

### func <span id="assign_fields_--GoldenGadget"></span>`assign_fields_`(`target`, `source`) -> `void`
Assign all fields from `source` to `target`.  

**Parameters**: \
`target`: `Object | Dictionary` 

**Returns**: `void` 

---

### func <span id="omit_--GoldenGadget"></span>`omit_`(`obj`, `fields`: `Array`) -> `Dictionary`
Create a new dictionary by copying all fields except those in given `fields` parameter.  

**Parameters**: \
`obj`: `Object | Dictionary` \
`fields`: `Array<String>` 

**Returns**: `Dictionary` 

---

### func <span id="input_event_to_dict_--GoldenGadget"></span>`input_event_to_dict_`(`e`: `InputEvent`)
Convert InputEvent to Dictionary.  
Supports: InputEventKey, InputEventJoypadButton, InputEventJoypadMotion and InputEventMouseButton  

**Parameters**: \
`e`: `InputEvent | null` 

**Returns**: `Dictionary | null` 

---

### func <span id="dict_to_input_event_--GoldenGadget"></span>`dict_to_input_event_`(`x`)
Convert Dictionary to InputEvent (see `input_event_to_dict_`).  

**Parameters**: \
`x`: `Dictionary | null` 

**Returns**: `InputEvent | null` 

---

### func <span id="fmt_input_event_--GoldenGadget"></span>`fmt_input_event_`(`e`: `InputEvent`, `options` = `<<TODO: ELit (LDictionary [])>>`) -> `String`
Format `InputEvent`. Formatting strings and translation function can be customized.  
Optional options:  
* `translate_func` {FuncLike<String, String>} - translation function  
* `fmt_str_key` {String}                      - formatting string for keyboard keys  
* `fmt_str_joypad_button` {String}            - formatting string for gamepad buttons  
* `fmt_str_joypad_motion` {String}            - formatting string for gamepad axis  

**Parameters**: \
`e`: `InputEvent` \
`options`: `Dictionary` 

---

### func <span id="shift_hue_--GoldenGadget"></span>`shift_hue_`(`c`: `Color`, `n`: `float`) -> `Color`
Shift given color by specified amount.  

**Parameters**: \
`c`: `Color` \
`n`: `float` In range of [-1 .. 1]. If you have degrees then divide it by 360, e.g. `60.0 / 360`.

**Examples**: \
`GG.shift_hue_(Color.red, 0.5)` returns equivalent of `Color.cyan`

---

### func <span id="debug_--GoldenGadget"></span>`debug_`(`x`, `tag` = `""`)
Print given data, optionally with a tag. Returns given data.  
Useful for debuging purposes, e.g. in pipe.  


<br>

---

Generated by [GodoDoc](https://gitlab.com/monnef/gododoc) at  3. 12. 2021 16:37.