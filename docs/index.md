# Golden Gadget

## GGArray<a name="GGArray"></a>

A wrapper of an `Array` offering a rich selection of general utility functions.  
.  
GodoDoc doesn't yet support documentation of `var`s, so here are at least copied out examples (a temporary solution):  
* Getter for unpacking [Array](#Array)  
`G([1, 2]).val` returns `[1, 2]`  
* Get length of a wrapped array.  
`G([1, 2]).size` returns `2`  
* Is wrapped array empty?  
`G([]).is_empty` returns `true`  
`G([1, 2]).is_empty` returns `false`  

---

### <a name="map_fn--GGArray"></a>`map_fn`(`f`, `ctx` = `GGI._EMPTY_CONTEXT`) -> `GGArray`
Map every value in an array using a given function.  

**Type parameters**:   
`T`: `any` Input [GGArray](#GGArray) item type  
`U`: `any` Output [GGArray](#GGArray) item type

**Parameters**:   
`f`: `Func<T, U>` Mapping function (`FuncRef` or `CtxFRef1`)  
`ctx`: `any` Context for function

**Returns**: `U` 

**Examples**:   
`G([1, 2]).map_fn(GG.inc_).val` returns `[2, 3]`

---

### <a name="map--GGArray"></a>`map`(`f`, `ctx` = `GGI._EMPTY_CONTEXT`) -> `GGArray`
Similar to [map_fn](#map_fn--GGArray), but also supports function-like type.  

**Type parameters**:   
`T`: `any` Input [GGArray](#GGArray) item type  
`U`: `any` Output [GGArray](#GGArray) item type

**Parameters**:   
`f`: `FuncLike<T, U>` Mapping function  
`ctx`: `any` Context for function

**Returns**: `U` 

**Examples**:   
`G([1, 2]).map("x => x + 1").val` returns `[2, 3]`

---

### <a name="map_out_mtd--GGArray"></a>`map_out_mtd`(`obj`: `Object`, `method_name`: `String`, `ctx` = `GGI._EMPTY_CONTEXT`) -> `GGArray`
Map an outer method (method of one specific object, usually one from which call originates - `self`)  

---

### <a name="map_in_mtd--GGArray"></a>`map_in_mtd`(`inner_method_name`: `String`, `ctx` = `GGI._EMPTY_CONTEXT`) -> `GGArray`
Map an inner method (a method on objects in [GGArray](#GGArray) item).  

---

### <a name="map_fld--GGArray"></a>`map_fld`(`field_name`: `String`) -> `GGArray`
Map a field in `Object` or `Dictionary`.  

**Examples**:   
`G([{name = "Spock"}, {name = "Scotty"}]).map_fld("name").val` returns `["Spock", "Scotty"]`

---

### <a name="for_each--GGArray"></a>`for_each`(`f`, `ctx` = `GGI._EMPTY_CONTEXT`) -> `void`
Call a function for every value in an array.  

**Examples**:   
`G(["Firefly", "Daedalus"]).for_each("x -> print(x)")` prints `Firefly` and `Daedalus` on separate lines (two calls)

---

### <a name="join--GGArray"></a>`join`(`delim`: `String` = `""`, `before`: `String` = `""`, `after`: `String` = `""`) -> `String`
Join an array of `String`s.  

**Examples**:   
`G(["Dog", "Cat", "Frog"]).join(", ")` returns `"Dog, Cat, Frog"`  
`G([1, 2, 3]).join(", ", "<", ">")` returns `"<1, 2, 3>"`

---

### <a name="join_w--GGArray"></a>`join_w`(`delim`: `String` = `""`, `before`: `String` = `""`, `after`: `String` = `""`) -> `GGArray`
Similar as [join](#join--GGArray), but wraps a result in [GGArray](#GGArray).  

---

### <a name="filter_fn--GGArray"></a>`filter_fn`(`predicate`, `ctx` = `GGI._EMPTY_CONTEXT`) -> `GGArray`
Filter out values from an array for which predicate function returns `false`.  

---

### <a name="filter--GGArray"></a>`filter`(`predicate`, `ctx` = `GGI._EMPTY_CONTEXT`) -> `GGArray`
Similar to [filter_fn](#filter_fn--GGArray), but supports [FuncLike](#FuncLike).  

**Examples**:   
`G(range(-4, 4)).filter("x => x >= 2").val` returns `[2, 3]`

---

### <a name="filter_out_mtd--GGArray"></a>`filter_out_mtd`(`obj`: `Object`, `method_name`: `String`, `ctx` = `GGI._EMPTY_CONTEXT`) -> `GGArray`
Filter contents using a method on one specific `Object`.  

---

### <a name="filter_in_mtd--GGArray"></a>`filter_in_mtd`(`inner_method_name`: `String`, `ctx` = `GGI._EMPTY_CONTEXT`) -> `GGArray`
Filter contents using a method on each item in an array.  

---

### <a name="filter_by_fld--GGArray"></a>`filter_by_fld`(`field_name`: `String`) -> `GGArray`
Filter an array of objects using `bool` field.  

**Examples**:   
`G([{enabled = true, id = 0}, {enabled = false, id = 1}, {enabled = true, id = 2}]).filter_by_fld("enabled").map_fld("id").val` returns `[0, 2]`

---

### <a name="filter_by_fld_val--GGArray"></a>`filter_by_fld_val`(`field_name`: `String`, `field_value`) -> `GGArray`
Filter an array of objects using one field and field value.  

**Examples**:   
`G([{id = 0, name = "Zero"}, {id = 1, name = "One"}]).filter_by_fld_val("id", 1).map_fld("name").val` returns `["One"]`

---

### <a name="without--GGArray"></a>`without`(`value_to_omit`) -> `GGArray`
Return a new [GGArray](#GGArray) omitting given value.  

**Examples**:   
`G([1, 2, 1]).without(1).val` returns `[2]`

---

### <a name="compact--GGArray"></a>`compact`() -> `GGArray`
Return a new [GGArray](#GGArray) omitting `null` items.  

**Examples**:   
`G([1, null, 3]).compact().val` returns `[1, 3]`

---

### <a name="find_by_fld_val--GGArray"></a>`find_by_fld_val`(`field_name`: `String`, `field_value`)
Find an item by a value of a field.  

**Examples**:   
`G([{id = 0, name = "Zero"}, {id = 1, name = "One"}]).find_by_fld_val("id", 1).name` returns `"One"`

---

### <a name="foldl_fn--GGArray"></a>`foldl_fn`(`f`: `FuncRef`, `zero`, `ctx` = `GGI._EMPTY_CONTEXT`)
Takes an operator and a zero (initial) value, reduces array to one value by repeatedly applying the operator to items from an array.  

**Parameters**:   
`f`: `Func<R, T, R>` Operator

**Returns**: `R` 

---

### <a name="foldl--GGArray"></a>`foldl`(`f`, `zero`, `ctx` = `GGI._EMPTY_CONTEXT`)
Similar to [foldl_fn](#foldl_fn--GGArray), but also supports [FuncLike](#FuncLike).  

**Examples**:   
`G([1, 2, 3]).foldl("a, x => a + x", -6)` returns `0` (-6 + 1 + 2 + 3)

---

### <a name="foldl_mtd--GGArray"></a>`foldl_mtd`(`obj`: `Object`, `method_name`: `String`, `zero`, `ctx` = `GGI._EMPTY_CONTEXT`)
Same as [foldl_fn](#foldl_fn--GGArray), but instead of a `FuncRef` takes an object and a name of its method.  

---

### <a name="to--GGArray"></a>`to`(`f`)
Calls [FuncLike](#FuncLike) on the inner value.  

---

### <a name="to_w--GGArray"></a>`to_w`(`f`) -> `GGArray`
Calls [FuncLike](#FuncLike) on the inner value and wraps the result in [GGArray](#GGArray).  

---

### <a name="head--GGArray"></a>`head`()
Get first item or `null` for empty array.  

**Examples**:   
`G([1, 2, 3]).head()` returns `1`

---

### <a name="last--GGArray"></a>`last`()
Get last item or `null` for empty array.  

**Examples**:   
`G([1, 2, 3]).last()` returns `3`

---

### <a name="tail--GGArray"></a>`tail`() -> `GGArray`
Get all items except first one.  

**Examples**:   
`G([1, 2, 3]).tail().val` returns `[2, 3]`

---

### <a name="init--GGArray"></a>`init`() -> `GGArray`
Get all items except last one.  

**Examples**:   
`G([1, 2, 3]).init().val` returns `[1, 2]`

---

### <a name="sort--GGArray"></a>`sort`() -> `GGArray`
Return a sorted [GGArray](#GGArray).  

---

### <a name="sort_by--GGArray"></a>`sort_by`(`cmp_f`: `FuncRef`) -> `GGArray`
Sort an array using a supplied compare function.  

---

### <a name="sort_by_fld--GGArray"></a>`sort_by_fld`(`field_name`: `String`) -> `GGArray`
Sort an array of objects by one given field.  

---

### <a name="sort_with--GGArray"></a>`sort_with`(`map_f`: `FuncRef`) -> `GGArray`
Sort an array using a mapping function (result is sorted on values obtained from the mapping function).  

---

### <a name="zip--GGArray"></a>`zip`(`other`: `Array`) -> `GGArray`
Zip together two arrays.  
A length of a result is same length as a length of a shorter array (meaning arrays are **not** padded with `null`s to be of same length, but the larger array is truncated to match the length of the shorter one).  

**Examples**:   
`G([1, 2]).zip(["a", "b"]).val` returns `[[1, "a"], [2, "b"]]`  
`G([1]).zip(["a", "b"]).val` returns `[[1, "a"]]`

---

### <a name="noop--GGArray"></a>`noop`() -> `void`
Does nothing, used to end a chain. Usually it's better to rather use chain-ending methods like [for_each](#for_each--GGArray) or [to](#to--GGArray).  
Can be used to suppress `The function 'map_out_mtd()' returns a value, but this value is never used.` and similar.  

---

### <a name="sample--GGArray"></a>`sample`()
Get a random item (crashes on an empty array).  

**Examples**:   
`G([1]).sample()` returns `1`  
`G(["Frog", "Toad"]).sample()` returns `"Frog"` or `"Toad"` with an equal chance  
`G([]).sample()` crashes

---

### <a name="sample_or_null--GGArray"></a>`sample_or_null`()
Get a random item (`null` on an empty array).  

**Examples**:   
`G([1]).sample_or_null()` returns `1`  
`G(["Frog", "Toad"]).sample_or_null()` returns `"Frog"` or `"Toad"` with an equal chance  
`G([]).sample_or_null()` returns `null`

---

### <a name="flatten--GGArray"></a>`flatten`() -> `GGArray`
Flattens [GGArray](#GGArray) of `Array`s to [GGArray](#GGArray) (spreads items).  

**Examples**:   
`G([[1, 2], [3]]).flatten().val` returns `[1, 2, 3]`

---

### <a name="flatten_unwrapped--GGArray"></a>`flatten_unwrapped`() -> `GGArray`
Flattens [GGArray](#GGArray) of [GGArrays](#GGArray) to [GGArray](#GGArray) (spreads items).  

**Examples**:   
`G([G([1, 2]), G([3])]).flatten_unwrapped().val` returns `[1, 2, 3]`

---

### <a name="take--GGArray"></a>`take`(`n`: `int`) -> `GGArray`
Take `n` items from a start of an array.  

**Examples**:   
`G([1, 2, 3, 4, 5]).take(2).val` returns `[1, 2]`

---

### <a name="take_right--GGArray"></a>`take_right`(`n`: `int`) -> `GGArray`
Take `n` items from an end of an array.  

**Examples**:   
`G([1, 2, 3, 4, 5]).take_right(2).val` returns `[4, 5]`

---

### <a name="drop--GGArray"></a>`drop`(`n`: `int`) -> `GGArray`
Drop (skip) n items from a start of an array.  

**Examples**:   
`G([1, 2, 3, 4, 5]).drop(2).val` returns `[3, 4, 5]`

---

### <a name="drop_right--GGArray"></a>`drop_right`(`n`: `int`) -> `GGArray`
Drop (skip) n items from an end of an array.  

**Examples**:   
`G([1, 2, 3, 4, 5]).drop_right(2).val` returns `[1, 2, 3]`

---

### <a name="reverse--GGArray"></a>`reverse`() -> `GGArray`
Reverse order of items in an array.  

**Examples**:   
`G([1, 2, 3]).reverse().val` returns `[3, 2, 1]`

---

### <a name="tap--GGArray"></a>`tap`(`f`) -> `GGArray`
Call FuncLike with inner value, ignore call result, return same array.  

**Type parameters**:   
`T`: `any` Type of [GGArray](#GGArray) items

**Parameters**:   
`f`: `FuncLike<T, any>` 

**Returns**: `GGArray<T>` 

---

### <a name="sum--GGArray"></a>`sum`() -> `int`
Sum all items in an array.  

**Examples**:   
`G([2, 3, 5]).sum()` returns `10`

---

### <a name="product--GGArray"></a>`product`() -> `int`
Multiply all items in an array.  

**Examples**:   
`G([2, 3, 5]).product()` returns `30`

---

### <a name="all--GGArray"></a>`all`(`p`) -> `bool`
Does a predicate hold for all items?  

**Type parameters**:   
`T`: `any` Type of [GGArray](#GGArray) items

**Parameters**:   
`p`: `FuncLike<T, bool>` 

**Returns**: `bool` 

**Examples**:   
`G([]).all("x => x > 0")` returns `true`  
`G([1, 2, 1]).all("x => x > 0")` returns `true`  
`G([1, 0, 1]).all("x => x > 0")` returns `false`

---

### <a name="any--GGArray"></a>`any`(`p`) -> `bool`
Does a predicate hold for any item?  

**Type parameters**:   
`T`: `any` Type of [GGArray](#GGArray) items

**Parameters**:   
`p`: `FuncLike<T, bool>` 

**Returns**: `bool` 

**Examples**:   
`G([]).any("x => x == 2")` returns `false`  
`G([1, 2, 1]).any("x => x == 2")` returns `true`  
`G([1, -1, 1]).any("x => x == 2")` returns `false`

---

### <a name="append--GGArray"></a>`append`(`y`) -> `GGArray`
Append an item to an end of the array.  

---

### <a name="prepend--GGArray"></a>`prepend`(`y`) -> `GGArray`
Prepend an item to a start of the array.  

---

### <a name="concat--GGArray"></a>`concat`(`other`: `Array`) -> `GGArray`
Concatenate arrays (`other` to end).  

---

### <a name="concat_left--GGArray"></a>`concat_left`(`other`: `Array`) -> `GGArray`
Concatenate arrays (`other` to start)  


## GoldenGadget.gd<a name="GoldenGadget"></a>

If some function is undocumented here (e.g. [size_](#size_--GoldenGadget)), please see documentation of [GGArray](#GGArray).  
.  
`FuncLike<A, B>` means function-like value which represents a function taking one argument of type `A` and returns value of type `B`.  

---

### <a name="arr--GoldenGadget"></a>`arr`(`array`) -> `GGArray`
Wraps `Array` into [GGArray](#GGArray).  
Recommended "import" (code at a start of a file we want to use the `arr` in):  
`func G(arr) -> GGArray: return GG.arr(arr)`  

**Parameters**:   
`arr`: `Array<T>` array to wrap

**Returns**: `GGArray<T>` wrapped array

---

### <a name="quit_--GoldenGadget"></a>`quit_`() -> `void`
Terminate/halt/quit program.  

---

### <a name="assert_--GoldenGadget"></a>`assert_`(`cond`: `bool`, `msg`: `String`) -> `void`
Assert condition is `true`, terminate program with error message otherwise.  

---

### <a name="crash_--GoldenGadget"></a>`crash_`(`msg`: `String`) -> `void`
Terminate program with error message.  

---

### <a name="l_and_--GoldenGadget"></a>`l_and_`(`x`: `bool`, `y`: `bool`) -> `bool`
logical and  

---

### <a name="l_or_--GoldenGadget"></a>`l_or_`(`x`: `bool`, `y`: `bool`) -> `bool`
logical or  

---

### <a name="add_--GoldenGadget"></a>`add_`(`x`: `int`, `y`: `int`) -> `int`
adds two values  

---

### <a name="subtract_--GoldenGadget"></a>`subtract_`(`x`: `int`, `y`: `int`) -> `int`
subtracts second argument from first  

---

### <a name="a_and_--GoldenGadget"></a>`a_and_`(`x`: `Array`) -> `bool`
`and` operation performed on array of bools  

**Parameters**:   
`x`: `Array<bool>` 

**Returns**: `bool` 

---

### <a name="a_or_--GoldenGadget"></a>`a_or_`(`x`: `Array`) -> `bool`
`or` operation performed on array of `bool`s  

**Parameters**:   
`x`: `Array<bool>` 

**Returns**: `bool` 

---

### <a name="eq_--GoldenGadget"></a>`eq_`(`a`, `b`) -> `bool`
shallow equality check  

---

### <a name="neq_--GoldenGadget"></a>`neq_`(`a`, `b`) -> `bool`
shallow not-equality check  

---

### <a name="eqd_--GoldenGadget"></a>`eqd_`(`a`, `b`) -> `bool`
deep equality check  

---

### <a name="eq_field_--GoldenGadget"></a>`eq_field_`(`object`, `args`) -> `bool`
determines equality (==) of a field (given name and value in args parameter) in object (first parameter)  

---

### <a name="call_spread_--GoldenGadget"></a>`call_spread_`(`f`: `FuncRef`, `arr`: `Array`)
Invoke a function with parameters given in array.  

---

### <a name="snake_to_pascal_case_--GoldenGadget"></a>`snake_to_pascal_case_`(`x`: `String`) -> `String`
Convert string from snake to pascal case  

---

### <a name="capitalize_--GoldenGadget"></a>`capitalize_`(`x`: `String`) -> `String`
Capitalize string - convert first character to upper case and all other to lower case.  

---

### <a name="capitalize_first_--GoldenGadget"></a>`capitalize_first_`(`x`: `String`) -> `String`
Capitalize first character of string (doesn't touch other characters).  

---

### <a name="noop1_--GoldenGadget"></a>`noop1_`(`x`) -> `void`
Do nothing.  

**Parameters**:   
`x`: `any` 

---

### <a name="noop2_--GoldenGadget"></a>`noop2_`(`x`, `y`) -> `void`
Do nothing.  

**Parameters**:   
`x`: `any`   
`y`: `any` 

---

### <a name="noop3_--GoldenGadget"></a>`noop3_`(`x`, `y`, `z`) -> `void`
Do nothing.  

**Parameters**:   
`x`: `any`   
`y`: `any`   
`z`: `any` 

---

### <a name="noop4_--GoldenGadget"></a>`noop4_`(`x`, `y`, `z`, `a`) -> `void`
Do nothing.  

**Parameters**:   
`x`: `any`   
`y`: `any`   
`z`: `any`   
`a`: `any` 

---

### <a name="multiply_--GoldenGadget"></a>`multiply_`(`x`, `y`)
Multiple two numbers.  

---

### <a name="modulo_--GoldenGadget"></a>`modulo_`(`x`, `y`)
Calculate modulo of two numbers (of same type).  

**Parameters**:   
`x`: `int | float` First number  
`y`: `int | float` Second number

**Returns**: `int | float` Modulo of input numbers, has same type.

---

### <a name="inc_--GoldenGadget"></a>`inc_`(`x`)
Add one to a given number.  

---

### <a name="dec_--GoldenGadget"></a>`dec_`(`x`)
Subtract one from a given number.  

---

### <a name="negate_num_--GoldenGadget"></a>`negate_num_`(`x`)
Negate given number.  

---

### <a name="negate_--GoldenGadget"></a>`negate_`(`x`: `bool`) -> `bool`
Logic not.  

---

### <a name="get_fld_--GoldenGadget"></a>`get_fld_`(`obj`, `field_name`: `String`)
Get a value in a given field.  
Crashes on a missing field.  

**Parameters**:   
`obj`: `Object | Dictionary`   
`field_name`: `String` 

**Returns**: `any` 

---

### <a name="get_fld_or_else_--GoldenGadget"></a>`get_fld_or_else_`(`obj`, `field_name`: `String`, `default`)
Get a value in a given field. If the field is missing, return a given default value.  

**Parameters**:   
`obj`: `Object | Dictionary`   
`field_name`: `String`   
`default`: `any` 

**Returns**: `any` 

---

### <a name="get_fld_or_null_--GoldenGadget"></a>`get_fld_or_null_`(`obj`, `field_name`: `String`)
Get a value in a given field. If the field is missing, return `null`.  

**Parameters**:   
`obj`: `Object | Dictionary`   
`field_name`: `String`   
`default`: `any` 

**Returns**: `any` 

---

### <a name="fst_--GoldenGadget"></a>`fst_`(`pair`: `Array`)
Get a first item in a pair.  

---

### <a name="snd_--GoldenGadget"></a>`snd_`(`pair`: `Array`)
Get a second item in a pair.  

---

### <a name="compile_script_--GoldenGadget"></a>`compile_script_`(`src`: `String`)
Compile script and return new instance of it.  

---

### <a name="compile_function_--GoldenGadget"></a>`compile_function_`(`expr`: `String`) -> `FuncRef`
Compile a script with one function, instantiate the script and return a `funcref` of the function.  

---

### <a name="F_--GoldenGadget"></a>`F_`(`f`)
Create function-like object depending on type of `f`.  
* `FuncRef` - pass same value  
* `String` - compiles function and returns its `FuncRef`  
`"x => x + 1"` ~ get `FuncRef` of `func f(x): return x + 1`  
* `Array` - partial application (creates `CtxFRef1`)  
`["x, y => x + y", 1]` which is functionally equivalent to `"x => x + 1"`  

**Parameters**:   
`f`: `FuncRef | String | Array<any>` 

**Returns**: `FuncRef | CtxFRef1` 

---

### <a name="keys_--GoldenGadget"></a>`keys_`(`obj`)
Get keys of `Dictionary` or `Object`.  

**Parameters**:   
`obj`: `Dictionary | Object` 

**Returns**: `Array<String>` 

**Examples**:   
`GG.keys_({a = 1, b = 2})` returns `["a", "b"]`

---

### <a name="key_from_val_--GoldenGadget"></a>`key_from_val_`(`obj`, `val`)
Get key by given value. Supports `Dictionary` and `Object` (custom classes).  
Useful for finding a name of an enum item from an item value.  

**Parameters**:   
`obj`: `Dictionary | Object`   
`val`: `any` 

**Returns**: `any | null` Returns `null` if value is not found.

**Examples**:   
`GG.key_from_val_({a = 1, b = 2}, 1)` returns `"a"`.

---

### <a name="ap_if_defined_--GoldenGadget"></a>`ap_if_defined_`(`obj`, `method_name`: `String`, `args`: `Array`)
Call a method when the method exists and return its result, otherwise return `null`.  

**Parameters**:   
`obj`: `Object` Object owning the method  
`method_name`: `String` Object owning the method  
`args`: `Array<any>` Arguments to pass to the method

**Returns**: `any` What method returned, or `null` when `obj` is `null` or `obj` has no such method

**Examples**:   
`GG.ap_if_defined_(GG, "add_", [2, 5])` returns `7`  
`GG.ap_if_defined_(GG, "_non_existing_method", [2, 5])` returns `null`

---

### <a name="sample_--GoldenGadget"></a>`sample_`(`arr`: `Array`)
Get a random item from an array.  
Crashes on an empty array.  

**Type parameters**:   
`T`: `any` type of items in the array

**Parameters**:   
`arr`: `Array<T>` the input array

**Returns**: `T` a randomly picked item

**Examples**:   
`sample_([1, 2])` returns `1` or `2` with equal chance  
`sample_([])` crashes

---

### <a name="sample_or_null_--GoldenGadget"></a>`sample_or_null_`(`arr`: `Array`)
Get a random item from an array.  

**Type parameters**:   
`T`: `any` type of items in the array

**Parameters**:   
`arr`: `Array<T>` the input array

**Returns**: `T | null` a random item, or null for an empty array

**Examples**:   
`sample_or_null_([1, 2])` returns `1` or `2` with equal chance  
`sample_or_null_([])` returns always `null`

---

### <a name="format_datetime_--GoldenGadget"></a>`format_datetime_`(`date` = `null`) -> `String`
Format `DateTime` (if no provided, current will be used) in following format: `YYYY-MM-DD--HH-MM-SS`  

**Parameters**:   
`date`: `DateTime | null` 

**Returns**: `String` 

**Examples**:   
Possible output: `"2019-12-19--13-03-18"`

---

### <a name="take_screenshot_--GoldenGadget"></a>`take_screenshot_`(`options`: `Dictionary` = `<<TODO: ELit (LDictionary [])>>`) -> `Dictionary`
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

### <a name="delete_children_--GoldenGadget"></a>`delete_children_`(`parent`: `Node`) -> `void`
Delete all children of a given parent (calls `queue_free` on children).  

---

### <a name="get_children_rec_--GoldenGadget"></a>`get_children_rec_`(`parent`: `Node`) -> `Array`
Get recursively all children.  

**Parameters**:   
`parent`: `Node` 

**Returns**: `Array<Node>` 

---

### <a name="get_node_or_crash_--GoldenGadget"></a>`get_node_or_crash_`(`parent`, `path`) -> `Node`
Safer `get_node` alternative which will crash when a parent, a path or a node are `null`/empty.  

**Parameters**:   
`parent`: `Node | null` Of which node we want to retrieve a child  
`path`: `NodePath | null` Path to a child

**Returns**: `Node | null` Child node or `null` on failure

---

### <a name="get_node_or_null_--GoldenGadget"></a>`get_node_or_null_`(`parent`, `path`)
Get a child node. If there is any problem, return `null`.  

**Parameters**:   
`parent`: `Node | null` Of which node we want to retrieve a child  
`path`: `NodePath | null` Path to a child

**Returns**: `Node | null` Child node or `null` on failure

---

### <a name="create_timer_and_start_--GoldenGadget"></a>`create_timer_and_start_`(`on`: `Node`, `method_name`: `String`, `time`: `float`, `one_shot` = `true`) -> `Timer`
Create a `Timer` node, connect timeout signal to the method and start.  

**Parameters**:   
`on`: `Node` Parent node for `Timer`, contains callback method  
`method_name`: `String` Name of a method which is called after timer finishes  
`time`: `float` Amount of time in seconds before callback method is called  
`one_shot`: `bool` Should the new `Timer` run in one-shot mode? If it does, `Timer` is destroyed after time elapses, otherwise `Timer` remains.

**Returns**: `Timer` New `Timer` node

---

### <a name="words_raw_--GoldenGadget"></a>`words_raw_`(`x`: `String`) -> `Array`
Split a string to an array of words.  

**Parameters**:   
`x`: `String` Input string

**Returns**: `Array<String>` words

**Examples**:   
`words_raw_("a  b")` will return `["a", "b"]`.

---

### <a name="words_--GoldenGadget"></a>`words_`(`x`: `String`) -> `GGArray`
Split a string to an array of words.  

**Parameters**:   
`x`: `String` Input string

**Returns**: `GGArray<String>` words

**Examples**:   
`words_("a  b")` will return `arr(["a", "b"])`.

---

### <a name="unwords_--GoldenGadget"></a>`unwords_`(`xs`: `Array`) -> `String`
Join words array to one string  

**Parameters**:   
`xs`: `Array<String>` Input array of words

**Returns**: `String` Joined words

**Examples**:   
`unwords_(["a", "b"])` returns `"a b"`

---

### <a name="lines_raw_--GoldenGadget"></a>`lines_raw_`(`x`: `String`) -> `Array`
Split string with new line sequences to an array of lines  
Same as [lines_](#lines_--GoldenGadget), but returns `Array<String>` instead of `GGArray<String>`.  

---

### <a name="lines_--GoldenGadget"></a>`lines_`(`x`: `String`) -> `GGArray`
Split string with new line sequences to an array of lines  

**Parameters**:   
`x`: `String` Input text

**Returns**: `GGArray<String>` Array containing lines as items (without new line sequences)

**Examples**:   
`lines_("a\n\nb")` returns `arr(["a", "b"])`

---

### <a name="unlines_--GoldenGadget"></a>`unlines_`(`xs`: `Array`) -> `String`
Join an array of lines to a string.  

**Examples**:   
`unlines_(["a", "b"])` returns `"a\nb"`

---

### <a name="pipe_--GoldenGadget"></a>`pipe_`(`input`, `functions`: `Array`, `options` = `null`)
Calls first function with given input then sequentially takes a result from a previous function and passes it to a next one.  
Supports lambdas (string, e.g. `"x => x + 1"`) and partial application of 2 argument functions (e.g. `[GG.take, 2]`)  
Options dictionary fields:  
* print - if `true` then input, middle values and result is printed  

**Examples**:   
`pipe_(0, [inc_, inc_])` returns `2`, it is equivalent to `inc_(inc_(0))`.  
`pipe_([1, 2], [[GG.take, 1], "xs => xs[0] * 10"])` returns `10`, it is equivalent to `take_([1, 2], 1)[0] * 10`.

---

### <a name="flow_--GoldenGadget"></a>`flow_`(`functions`: `Array`)
Similar to [pipe_](#pipe_--GoldenGadget), but returns "piped" function composed from all passed functions.  
If you intend to call the resulting function immediately, use rather [pipe_](#pipe_--GoldenGadget) for better performance.  

---

### <a name="id_--GoldenGadget"></a>`id_`(`x`)
Identity function - returns same value it got in an argument.  

**Type parameters**:   
`T`: `any` 

**Parameters**:   
`x`: `T` Input value

**Returns**: `T` Same value as on input

---

### <a name="const_--GoldenGadget"></a>`const_`(`x`)
Construct a function accepting one argument.  
This new function ignores passed argument and always returns `x` (an argument it was created with).  

**Type parameters**:   
`T`: `any` 

**Parameters**:   
`x`: `T` Value to be returned from constructed function

**Returns**: `FuncLike<any, T>` 

**Examples**:   
`const_(1).call_func("Gorn")` returns `1`  
`const_("Resistance is futile!").call_func("Resist!")` returns `"Resistance is futile!"`

---

### <a name="tap_--GoldenGadget"></a>`tap_`(`x`, `f`)
Call function-like `f` with `x`, return `x` (ignore return value of `f`).  

**Type parameters**:   
`T`: `any` 

**Parameters**:   
`x`: `T` Input value  
`f`: `FuncLike<T, any>` Function accepting input value

**Returns**: `T` Input value `x`

---

### <a name="fmt_bool_--GoldenGadget"></a>`fmt_bool_`(`x`: `bool`) -> `String`
Format bool (default formatting uses upper-case, this function uses lower-case).  

**Parameters**:   
`x`: `bool` Input value

**Returns**: `String` Formatted value

---

### <a name="replicate_--GoldenGadget"></a>`replicate_`(`x`, `n`: `int`) -> `Array`
Create an array of length `n` where all items are `x`.  

**Type parameters**:   
`T`: `any` 

**Parameters**:   
`x`: `T` Item used for filling the array  
`n`: `int` Number of items

**Returns**: `Array<T>` 

**Examples**:   
`replicate_("a", 3)` returns `["a", "a", "a"]`

---

### <a name="new_array_--GoldenGadget"></a>`new_array_`(`zero`, `dimensions`: `Array`) -> `Array`
Create an n-dimensional array and fill its every cell with given `zero` value  

**Type parameters**:   
`T`: `any` 

**Parameters**:   
`zero`: `T` Value to assign to all cells  
`dimensions`: `Array<int>` Dimensions (lengths) of new nested array.

**Returns**: `Array<any>` Nested (n-dimensional) array

**Examples**:   
`new_array_(0, [1])` returns `[0]`  
`new_array_(0, [3])` returns `[0, 0, 0]`  
`new_array_(0, [1, 2])` returns `[[0, 0]]`  
`new_array_("x", [2, 3])` returns `[["x", "x", "x"], ["x", "x", "x"]]`

---

### <a name="generate_array_--GoldenGadget"></a>`generate_array_`(`cell_value_getter`, `dimensions`: `Array`) -> `Array`
Create an n-dimensional array and fill its every cell with a value returned by `cell_value_getter`.  

**Type parameters**:   
`T`: `any` 

**Parameters**:   
`cell_value_getter`: `FuncLike<Array<int>, T>` Function which accepts coordinates (array of numbers) and returns a value for a cell on those coordinates  
`dimensions`: `Array<int>` Dimensions (lengths) of new nested array.

**Returns**: `Array<any>` Nested (n-dimensional) array

**Examples**:   
`generate_array_(GG.id, [3])` returns `[[0], [1], [2]]`  
`generate_array_("x => x[0] * 10 + x[1]", [2, 3])` returns `[ [0, 1, 2], [10, 11, 12] ]`

---

### <a name="get_fields_--GoldenGadget"></a>`get_fields_`(`obj`, `field_names`: `Array`) -> `Array`
Get field values from given object/dictionary as an array (indices of output array matches those of input array)  

**Parameters**:   
`obj`: `Object | Dictionary` Input value  
`field_names`: `Array<String>` Names of fields to read values from

**Returns**: `Array<any>` Read values of given fields

**Examples**:   
`get_fields_({x = 2, y = true}, ["x", "y"])` returns `[2, true]`

---

### <a name="set_fields_--GoldenGadget"></a>`set_fields_`(`obj`, `values`: `Array`, `field_names`: `Array`) -> `void`
Set field values of object/dictionary according to arrays of values and field names (indices of arrays match).  

**Parameters**:   
`obj`: `Object | Dictionary` Target for setting values on  
`values`: `Array<any>` List of values  
`field_names`: `Array<string>` List of corresponding field names

**Returns**: `void` 

**Examples**:   
`var dict = {x = 2, y = true}; GG.set_fields_(dict, [69, false], ["x", "y"])` results in `dict` to be equal to `{x = 69, y = false}`

---

### <a name="bool_--GoldenGadget"></a>`bool_`(`cond`: `bool`, `on_false`, `on_true`)
Return `on_false`/`on_true` depending on value of `cond`  

**Type parameters**:   
`T`: `any` Return type

**Parameters**:   
`cond`: `bool` Condition  
`on_false`: `T` Value to return when `cond` is `false`  
`on_true`: `T` Value to return when `cond` is `true`

**Returns**: `T` 

**Examples**:   
`bool_(true, 0, 1)` returns `1`  
`bool_(x == 0, "not zero", "is zero")` returns `"is zero"` when `x` is `0`, otherwise returns `"not zero"`

---

### <a name="bool_lazy_--GoldenGadget"></a>`bool_lazy_`(`cond`: `bool`, `on_false`, `on_true`)
Same as [bool_](#bool_--GoldenGadget), but `on_false`/`on_true` are functions.  
Only selected function will be called and its return value will be returned from `bool_lazy`.  

**Type parameters**:   
`T`: `any` Return type

**Parameters**:   
`cond`: `bool` Condition  
`on_false`: `FuncLike<T>` Function to call and return its result when `cond` is `false`  
`on_true`: `FuncLike<T>` Function to call and return its result when `cond` is `true`

**Returns**: `T` 

---

### <a name="pause_one_--GoldenGadget"></a>`pause_one_`(`node`: `Node`, `value`: `bool`) -> `void`
Pause specific node. Disables all processing by a given node.  

**Parameters**:   
`node`: `Node` Branch to pause.  
`value`: `bool` True means pause, false means resume (unpause)

---

### <a name="pause_--GoldenGadget"></a>`pause_`(`node`: `Node`, `value`: `bool`) -> `void`
Pause a branch starting with given node (recursive variant of [pause_one_](#pause_one_--GoldenGadget)).  

**Parameters**:   
`node`: `Node` Branch to pause.  
`value`: `bool` True means pause, false means resume (unpause)


<br>

---

Generated by [GodoDoc](https://gitlab.com/monnef/gododoc)