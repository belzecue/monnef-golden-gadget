# Golden Gadget


## GGArray<span id="GGArray"></span>

A wrapper of an `Array` offering a rich selection of general utility functions.  
  
**Note**: Arrays (and other types) passed and returned are considered immutable. It is recommended to not mutate them.  
If you break this rule, it may lead to unexpected consequences.  
  
Type parameter `T` (`any`) is the type items in [GGArray](#GGArray).  

---

### <span id="GGI--GGArray"></span>var `GGI`
@internal  

---

### <span id="val--GGArray"></span>var `val`
Inner [Array](#Array). Usually used to end [GGArray](#GGArray) chains.  

**Type**: `Array<T>` 

**Examples**: \
`G([1, 2]).val` returns `[1, 2]`

---

### <span id="size--GGArray"></span>var `size`
Get length of the wrapped array.  

**Type**: `int` 

**Examples**: \
`G([1, 2]).size` returns `2`

---

### <span id="is_empty--GGArray"></span>var `is_empty`
Is the wrapped array empty?  

**Type**: `bool` 

**Examples**: \
`G([]).is_empty` returns `true`\
`G([1, 2]).is_empty` returns `false`

---

### func <span id="map_fn--GGArray"></span>`map_fn`(`f`, `ctx` = `GGI._EMPTY_CONTEXT`) -> `GGArray`
Map every value in an array using a given function.  

**Type parameters**: \
`U`: `any` Output [GGArray](#GGArray) item type

**Parameters**: \
`f`: `Func<T, U>` Mapping function (`FuncRef` or `CtxFRef1`)\
`ctx`: `any` Context for function

**Returns**: `U` 

**Examples**: \
`G([1, 2]).map_fn(GG.inc_).val` returns `[2, 3]`

---

### func <span id="map--GGArray"></span>`map`(`f`, `ctx` = `GGI._EMPTY_CONTEXT`) -> `GGArray`
Similar to [map_fn](#map_fn--GGArray), but also supports function-like type.  

**Type parameters**: \
`U`: `any` Output [GGArray](#GGArray) item type

**Parameters**: \
`f`: `FuncLike<T, U>` Mapping function\
`ctx`: `any` Context for function

**Returns**: `U` 

**Examples**: \
`G([1, 2]).map("x => x + 1").val` returns `[2, 3]`

---

### func <span id="map_out_mtd--GGArray"></span>`map_out_mtd`(`obj`: `Object`, `method_name`: `String`, `ctx` = `GGI._EMPTY_CONTEXT`) -> `GGArray`
Map an outer method (method of one specific object, usually one from which call originates - `self`)  

---

### func <span id="map_in_mtd--GGArray"></span>`map_in_mtd`(`inner_method_name`: `String`, `ctx` = `GGI._EMPTY_CONTEXT`) -> `GGArray`
Map an inner method (a method on objects in [GGArray](#GGArray) item).  

---

### func <span id="map_fld--GGArray"></span>`map_fld`(`field_name`: `String`) -> `GGArray`
Map a field in `Object` or `Dictionary`.  

**Examples**: \
`G([{name = "Spock"}, {name = "Scotty"}]).map_fld("name").val` returns `["Spock", "Scotty"]`

---

### func <span id="for_each--GGArray"></span>`for_each`(`f`, `ctx` = `GGI._EMPTY_CONTEXT`) -> `void`
Call a function for every value in an array.  

**Examples**: \
`G(["Firefly", "Daedalus"]).for_each("x -> print(x)")` prints `Firefly` and `Daedalus` on separate lines (two calls)

---

### func <span id="join--GGArray"></span>`join`(`delim`: `String` = `""`, `before`: `String` = `""`, `after`: `String` = `""`) -> `String`
Join an array of `String`s.  

**Examples**: \
`G(["Dog", "Cat", "Frog"]).join(", ")` returns `"Dog, Cat, Frog"`\
`G([1, 2, 3]).join(", ", "<", ">")` returns `"<1, 2, 3>"`

---

### func <span id="join_w--GGArray"></span>`join_w`(`delim`: `String` = `""`, `before`: `String` = `""`, `after`: `String` = `""`) -> `GGArray`
Similar as [join](#join--GGArray), but wraps a result in [GGArray](#GGArray).  

---

### func <span id="filter_fn--GGArray"></span>`filter_fn`(`predicate`, `ctx` = `GGI._EMPTY_CONTEXT`) -> `GGArray`
Filter out values from an array for which predicate function returns `false`.  

---

### func <span id="filter--GGArray"></span>`filter`(`predicate`, `ctx` = `GGI._EMPTY_CONTEXT`) -> `GGArray`
Similar to [filter_fn](#filter_fn--GGArray), but supports [FuncLike](#FuncLike).  

**Examples**: \
`G(range(-4, 4)).filter("x => x >= 2").val` returns `[2, 3]`

---

### func <span id="filter_out_mtd--GGArray"></span>`filter_out_mtd`(`obj`: `Object`, `method_name`: `String`, `ctx` = `GGI._EMPTY_CONTEXT`) -> `GGArray`
Filter contents using a method on one specific `Object`.  

---

### func <span id="filter_in_mtd--GGArray"></span>`filter_in_mtd`(`inner_method_name`: `String`, `ctx` = `GGI._EMPTY_CONTEXT`) -> `GGArray`
Filter contents using a method on each item in an array.  

---

### func <span id="filter_by_fld--GGArray"></span>`filter_by_fld`(`field_name`: `String`) -> `GGArray`
Filter an array of objects using `bool` field.  

**Examples**: \
`G([{enabled = true, id = 0}, {enabled = false, id = 1}, {enabled = true, id = 2}]).filter_by_fld("enabled").map_fld("id").val` returns `[0, 2]`

---

### func <span id="filter_by_fld_val--GGArray"></span>`filter_by_fld_val`(`field_name`: `String`, `field_value`) -> `GGArray`
Filter an array of objects using one field and field value.  

**Examples**: \
`G([{id = 0, name = "Zero"}, {id = 1, name = "One"}]).filter_by_fld_val("id", 1).map_fld("name").val` returns `["One"]`

---

### func <span id="without--GGArray"></span>`without`(`value_to_omit`) -> `GGArray`
Return a new [GGArray](#GGArray) omitting given value.  

**Examples**: \
`G([1, 2, 1]).without(1).val` returns `[2]`

---

### func <span id="compact--GGArray"></span>`compact`() -> `GGArray`
Return a new [GGArray](#GGArray) omitting `null` items.  

**Examples**: \
`G([1, null, 3]).compact().val` returns `[1, 3]`

---

### func <span id="find_or_null--GGArray"></span>`find_or_null`(`predicate`, `ctx` = `GGI._EMPTY_CONTEXT`)
Find a first element for which predicate holds. Crash on no match.  

**Examples**: \
`G([1, 2, 3], "x => x > 1")` returns `2`\
`G([1], "x => x > 1")` returns `null`\
`G([{id = 4, name = "Alice"}, {id = 7, name = "Bob"}]).find_or_null("x => x.name.length() == 3").id` returns `7`

---

### func <span id="find--GGArray"></span>`find`(`predicate`, `ctx` = `GGI._EMPTY_CONTEXT`)
Find a first element for which predicate holds. Return `null` when no match is found.  

---

### func <span id="find_by_fld_val--GGArray"></span>`find_by_fld_val`(`field_name`: `String`, `field_value`)
Find an item by a value of a field.  

**Examples**: \
`G([{id = 0, name = "Zero"}, {id = 1, name = "One"}]).find_by_fld_val("id", 1).name` returns `"One"`

---

### func <span id="find_by_fld_val_or_null--GGArray"></span>`find_by_fld_val_or_null`(`field_name`: `String`, `field_value`)
Find an item by a value of a field. Returns `null` on failure.  

---

### func <span id="find_index_or_null--GGArray"></span>`find_index_or_null`(`predicate`, `ctx` = `GGI._EMPTY_CONTEXT`)
Find item in array for which precate holds and return its index.  

**Parameters**: \
`predicate`: `Func<T, bool>` \
`ctx`: `any` 

**Returns**: `int | null` 

---

### func <span id="find_index--GGArray"></span>`find_index`(`predicate`, `ctx` = `GGI._EMPTY_CONTEXT`)
Find item in array for which precate holds and return its index. Crash when valid item isn't found.  

**Parameters**: \
`predicate`: `Func<T, bool>` \
`ctx`: `any` 

**Returns**: `int` 

---

### func <span id="partition--GGArray"></span>`partition`(`predicate`, `ctx` = `GGI._EMPTY_CONTEXT`) -> `GGArray`
Split array into two - first one consists of elements satisfying given predicate, second array of those which don't.  

**Parameters**: \
`predicate`: `Func<T, bool>` 

**Returns**: `GGArray<GGArray<T>>` 

---

### func <span id="foldl_fn--GGArray"></span>`foldl_fn`(`f`: `FuncRef`, `zero`, `ctx` = `GGI._EMPTY_CONTEXT`)
Takes an operator and a zero (initial) value, reduces array to one value by repeatedly applying the operator to items from an array.  

**Parameters**: \
`f`: `Func<R, T, R>` Operator

**Returns**: `R` 

---

### func <span id="foldl--GGArray"></span>`foldl`(`f`, `zero`, `ctx` = `GGI._EMPTY_CONTEXT`)
Similar to [foldl_fn](#foldl_fn--GGArray), but also supports [FuncLike](#FuncLike).  

**Examples**: \
`G([1, 2, 3]).foldl("a, x => a + x", -6)` returns `0` (-6 + 1 + 2 + 3)

---

### func <span id="foldl_mtd--GGArray"></span>`foldl_mtd`(`obj`: `Object`, `method_name`: `String`, `zero`, `ctx` = `GGI._EMPTY_CONTEXT`)
Same as [foldl_fn](#foldl_fn--GGArray), but instead of a `FuncRef` takes an object and a name of its method.  

---

### func <span id="to--GGArray"></span>`to`(`f`)
Calls [FuncLike](#FuncLike) on the inner value.  

---

### func <span id="to_w--GGArray"></span>`to_w`(`f`) -> `GGArray`
Calls [FuncLike](#FuncLike) on the inner value and wraps the result in [GGArray](#GGArray).  

---

### func <span id="head--GGArray"></span>`head`()
Get first item or crash on empty array.  

**Examples**: \
`G([1, 2, 3]).head()` returns `1`

---

### func <span id="head_or_null--GGArray"></span>`head_or_null`()
Get first item or `null` for empty array.  

**Examples**: \
`G([1, 2, 3]).head_or_null()` returns `1`

---

### func <span id="last--GGArray"></span>`last`()
Get last item or crash on empty array.  

**Examples**: \
`G([1, 2, 3]).last()` returns `3`

---

### func <span id="last_or_null--GGArray"></span>`last_or_null`()
Get last item or `null` for empty array.  

**Examples**: \
`G([1, 2, 3]).last()` returns `3`

---

### func <span id="tail--GGArray"></span>`tail`() -> `GGArray`
Get all items except first one.  

**Examples**: \
`G([1, 2, 3]).tail().val` returns `[2, 3]`

---

### func <span id="init--GGArray"></span>`init`() -> `GGArray`
Get all items except last one.  

**Examples**: \
`G([1, 2, 3]).init().val` returns `[1, 2]`

---

### func <span id="sort--GGArray"></span>`sort`() -> `GGArray`
Return a sorted [GGArray](#GGArray).  

---

### func <span id="sort_by--GGArray"></span>`sort_by`(`cmp_f`: `FuncRef`) -> `GGArray`
Sort an array using a supplied compare function.  

---

### func <span id="sort_by_fld--GGArray"></span>`sort_by_fld`(`field_name`: `String`) -> `GGArray`
Sort an array of objects by one given field.  

---

### func <span id="sort_with--GGArray"></span>`sort_with`(`map_f`: `FuncRef`) -> `GGArray`
Sort an array using a mapping function (result is sorted on values obtained from the mapping function).  

---

### func <span id="zip--GGArray"></span>`zip`(`other`: `Array`) -> `GGArray`
Zip together two arrays.  
A length of a result is same length as a length of a shorter array (meaning arrays are **not** padded with `null`s to be of same length, but the larger array is truncated to match the length of the shorter one).  

**Examples**: \
`G([1, 2]).zip(["a", "b"]).val` returns `[[1, "a"], [2, "b"]]`\
`G([1]).zip(["a", "b"]).val` returns `[[1, "a"]]`

---

### func <span id="noop--GGArray"></span>`noop`() -> `void`
Does nothing, used to end a chain. Usually it's better to rather use chain-ending methods like [for_each](#for_each--GGArray) or [to](#to--GGArray).  
Can be used to suppress `The function 'map_out_mtd()' returns a value, but this value is never used.` and similar.  

---

### func <span id="sample--GGArray"></span>`sample`()
Get a random item (crashes on an empty array).  

**Examples**: \
`G([1]).sample()` returns `1`\
`G(["Frog", "Toad"]).sample()` returns `"Frog"` or `"Toad"` with an equal chance\
`G([]).sample()` crashes

---

### func <span id="sample_or_null--GGArray"></span>`sample_or_null`()
Get a random item (`null` on an empty array).  

**Examples**: \
`G([1]).sample_or_null()` returns `1`\
`G(["Frog", "Toad"]).sample_or_null()` returns `"Frog"` or `"Toad"` with an equal chance\
`G([]).sample_or_null()` returns `null`

---

### func <span id="flatten_raw--GGArray"></span>`flatten_raw`() -> `GGArray`
Flattens [GGArray](#GGArray) of `Array`s to [GGArray](#GGArray) (spreads items).  

**Examples**: \
`G([[1, 2], [3]]).flatten_raw().val` returns `[1, 2, 3]`

---

### func <span id="flatten--GGArray"></span>`flatten`() -> `GGArray`
Flattens [GGArray](#GGArray) of [GGArrays](#GGArray) to [GGArray](#GGArray) (spreads items).  

**Examples**: \
`G([G([1, 2]), G([3])]).flatten().val` returns `[1, 2, 3]`

---

### func <span id="take--GGArray"></span>`take`(`n`: `int`) -> `GGArray`
Take `n` items from a start of an array.  

**Examples**: \
`G([1, 2, 3, 4, 5]).take(2).val` returns `[1, 2]`

---

### func <span id="take_right--GGArray"></span>`take_right`(`n`: `int`) -> `GGArray`
Take `n` items from an end of an array.  

**Examples**: \
`G([1, 2, 3, 4, 5]).take_right(2).val` returns `[4, 5]`

---

### func <span id="take_while--GGArray"></span>`take_while`(`p`) -> `GGArray`
Keep taking items from an array (from start) until predicate stops holding.  

**Parameters**: \
`p`: `FuncLike<T, bool>` Predicate

---

### func <span id="drop--GGArray"></span>`drop`(`n`: `int`) -> `GGArray`
Drop (skip) n items from a start of an array.  

**Examples**: \
`G([1, 2, 3, 4, 5]).drop(2).val` returns `[3, 4, 5]`

---

### func <span id="drop_right--GGArray"></span>`drop_right`(`n`: `int`) -> `GGArray`
Drop (skip) n items from an end of an array.  

**Examples**: \
`G([1, 2, 3, 4, 5]).drop_right(2).val` returns `[1, 2, 3]`

---

### func <span id="reverse--GGArray"></span>`reverse`() -> `GGArray`
Reverse order of items in an array.  

**Examples**: \
`G([1, 2, 3]).reverse().val` returns `[3, 2, 1]`

---

### func <span id="tap--GGArray"></span>`tap`(`f`) -> `GGArray`
Call FuncLike with inner value, ignore call result, return same array.  

**Parameters**: \
`f`: `FuncLike<T, any>` 

**Returns**: `GGArray<T>` 

---

### func <span id="max--GGArray"></span>`max`()
Get maximal value.  

**Examples**: \
`G([1, 2, 3]).max()` returns `3`

---

### func <span id="min--GGArray"></span>`min`()
Get minimal value.  

**Examples**: \
`G([1, 2, 3]).min()` returns `1`

---

### func <span id="average--GGArray"></span>`average`()
Calculate average.  

**Examples**: \
`G([0.0, 1.0]).average()` returns `0.5`

---

### func <span id="sum--GGArray"></span>`sum`() -> `int`
Sum all items in an array.  

**Examples**: \
`G([2, 3, 5]).sum()` returns `10`

---

### func <span id="product--GGArray"></span>`product`() -> `int`
Multiply all items in an array.  

**Examples**: \
`G([2, 3, 5]).product()` returns `30`

---

### func <span id="all--GGArray"></span>`all`(`p`) -> `bool`
Does a predicate hold for all items?  

**Parameters**: \
`p`: `FuncLike<T, bool>` 

**Returns**: `bool` 

**Examples**: \
`G([]).all("x => x > 0")` returns `true`\
`G([1, 2, 1]).all("x => x > 0")` returns `true`\
`G([1, 0, 1]).all("x => x > 0")` returns `false`

---

### func <span id="any--GGArray"></span>`any`(`p`) -> `bool`
Does a predicate hold for any item?  

**Parameters**: \
`p`: `FuncLike<T, bool>` 

**Returns**: `bool` 

**Examples**: \
`G([]).any("x => x == 2")` returns `false`\
`G([1, 2, 1]).any("x => x == 2")` returns `true`\
`G([1, -1, 1]).any("x => x == 2")` returns `false`

---

### func <span id="append--GGArray"></span>`append`(`y`) -> `GGArray`
Append an item to an end of the array.  

---

### func <span id="prepend--GGArray"></span>`prepend`(`y`) -> `GGArray`
Prepend an item to a start of the array.  

---

### func <span id="concat--GGArray"></span>`concat`(`other`: `Array`) -> `GGArray`
Concatenate arrays (`other` to end).  

---

### func <span id="concat_left--GGArray"></span>`concat_left`(`other`: `Array`) -> `GGArray`
Concatenate arrays (`other` to start)  

---

### func <span id="group_with--GGArray"></span>`group_with`(`f`) -> `GGArray`
Go through an array in order and group together sequences of items for which `f` returns same value.  

**Type parameters**: \
`U`: `any` Type of values for comparison (usually a type of field of `Object`/`Dictionary`)

**Parameters**: \
`f`: `FuncLike<T, U>` Mapping function used on all items and retuned values are used for comparisons

**Returns**: `GGArray<GGArray<T>>` Grouped items

**Examples**: \
`G([{name = "Walt", rank = 0}, {name = "Muffy", rank = 0}, {name = "Yen", rank = 1}]).group_with("x => x.rank")` returns `GGArray`s equivalent to `[[{name = "Walt", rank = 0}, {name = "Muffy", rank = 0}], [{name = "Yen", rank = 1}]]`

---

### func <span id="transpose--GGArray"></span>`transpose`() -> `GGArray`
Transpose a 2D matrix.  

**Examples**: \
`G([[1, 2], [3, 4]]).transpose()` returns `GGArray`s equivalent to `[[1, 3], [2, 4]]`

---

### func <span id="wrap--GGArray"></span>`wrap`() -> `GGArray`
Wrap inner `Array`s with `GGArray`.  

---

### func <span id="unwrap--GGArray"></span>`unwrap`() -> `GGArray`
Unwrap inner `GGArray`s to `Array`s.  

---

### func <span id="nub--GGArray"></span>`nub`() -> `GGArray`
Cut all sequences of same values to be of length one.  

---

### func <span id="uniq--GGArray"></span>`uniq`() -> `GGArray`
Remove all duplicate items.  

---

### func <span id="float_arr_to_int_arr--GGArray"></span>`float_arr_to_int_arr`() -> `GGArray`
Convert array of floats to array of integers. Useful for correcting parsed JSONs.  


<br>

---

Generated by [GodoDoc](https://gitlab.com/monnef/gododoc) at 15. 11. 2020  6:05.