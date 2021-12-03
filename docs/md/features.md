# Features

On this page are only some features listed, for a complete overview please see the [API documentation](/api/index).

## Data and mutability

All functions are handling `Array`s and other types as immutable (unless explicitly specified).

```gdscript
var inputArray = [6, 9]
var outputArray = G(inputArray).map(GG.id).val # new array equal to [6, 9]
```

## Functions

Most functions/methods should support following types when expecting a function (referred to as function-like/`FunctionLike`):
* `FuncRef` - obtained by calling `funcref`
```gdscript
# following expressions are same
G([1, 2]).map(GG.inc).val # [2, 3]
G([1, 2]).map(funcref(GG, "inc_")).val # [2, 3]
```
* `String` - compiled to an anonymous function
```gdscript
G([1, 2]).map("x => x + 1").val # [2, 3]
#
# the in-line function is similar to:
func f(x): return x + 1
G([1, 2]).map(funcref(self, f)).val
#
# "->" marks non-returning function (return type is void)
G(["Firefly", "Daedalus"]).for_each("x -> print(x)") # prints Firefly and Daedalus (two calls)
```
* partially applied functions written as `Array` - a tuple where first item is function-like, second item is value to apply (from right)
```gdscript
# y parameter is partially applied (is passed as 10 to the anonymous function)
G([1, 2]).to(["x, y => x.size() * y", 10]) # returns 20
```
* `with_ctx`/`with_ctx2` - older form, mimics `FuncRef`

## Composition

### Pipe
A pipe accepts an input value and a pipeline (`Array` of function-like). An input value is passed to the first function, result of the first function is passed to the second function and so on, until the last function which result is returned from the `pipe` function as a final result.

```gdscript
# Take 3 first words and capitalize them

var text_input = "Morbi id mauris pep erisus. Aenean."

var three_words_capitalized = GG.pipe_(text_input, [\
    GG.words_raw, # ["Morbi", "id", "mauris", "pep", "erisus.", "Aenean."]
    [GG.take, 3], # ["Morbi", "id", "mauris"]
    [GG.map, GG.capitalize], # ["Morbi", "Id", "Mauris"]
    GG.unwords # "Morbi Id Mauris"
])
assert(three_words_capitalized == "Morbi Id Mauris")
```

### Flow
Similar to a `pipe` function, but instead of immediately doing computation, `flow` returns a "function" (callable object instance with a similar interface as `FuncRef`) which behaves as it would be composed of all functions in a passed pipeline. `flow` is commonly known as a *reverse composition* operator (e.g. `>>>` in Haskell).

## Function utilities

* `call_spread`: invokes a function with given arguments in a form of an array - it "spreads" the arguments (not easily doable in Godot 3.1)
* `flip`: accepts function of two arguments, returns a new function with flipped order of arguments

## Object and dictionary utilities

* `key_from_val`: finding a key from value
* `keys`: unified way of getting array of keys for `Dictionary` and custom classes
* `ap_if_defined`: call method when method exists and pass result, otherwise `null`
* `get_fields`/`set_fields`: batch access to fields
* `merge`: merging two dictionaries
* `pick`: construct a new dictionary from a given list of fields of a given object/dictionary
* `assign_fields`, `omit`

## Array utilities

Array utilities known from other dynamic and/or functional languages. Golden Gagdet also contains an array wrapper with fluent API - [`GGArray`](#ggarray) - to streamline working with arrays. some examples:
* FP classics: `map`, `filter`, `foldl` (aka `reduce`)
* chopping: `head`, `tail`, `last`, `init`, `take`, `take_right`, `drop`, `drop_right`, `take_while`,  `drop_while`, `drop_while_right`
* gluing: `append`, `prepend`, `concat`, `concat_left`
* `sort`, `zip`, `reverse` (aka `inverse`)
* `flatten`: flattens one level of array of arrays, e.g. `[[1, 2], [3]]` -> `[1, 2, 3]`
* `without`: remove all occurrences of given value from an array
* `sample`/`sample_or_null`: get random item from an array
* `sum`/`product`
* `all`/`any`: does predicate (given function returns `true`) for all/any items of an array?
* `find`/`find_or_null`/`find_index`/`find_index_or_null`: finds a first item/index for which predicate holds
* `group_with`
* `transpose`
* `nub` and `unique`
* `zip_with_index` and `map_with_index`
* "set" operations: `intersect`, `union`, `difference`
* `elem`, `not_elem`: similar to `has` method
* `valid_index`

### `GGArray`

```gdscript
var monsters = [
    Monster.new(0, "Orc"), # hp, name
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
var weak_alive_monsters =
    G(monsters).filter("x => x.is_alive && x.hp < 10").map("x => x.name").val

assert(weak_alive_monsters_imperative == ["Demon"])
assert(weak_alive_monsters == ["Demon"])
```

### Multidimensional arrays

```gdscript
GG.new_array_("x", [2, 3]) # [["x", "x", "x"], ["x", "x", "x"]]
GG.generate_array_("x => x[0] * 10 + x[1]", [2, 3]) # [  [0, 1, 2], [10, 11, 12]  ]
```

## String utilities

String helpers like `words`, `unwords`, `lines`, `unlines`, `join`.

## Number utilities
* `floats_are_equal`: floats comparison (range, not a strict equality check)
* `clampi`: `clamp` for `int`s

## Formatting

```gdscript
GG.format_float_2_(1.23456) # "1.23"
GG.format_vec2_2_(Vector2(1.2345, 0)) # "1.23, 0.00"
GG.format_vec3_2_(Vector3(1.2345, 0, 7)) # "1.23, 0.00, 7.00"
```

* `fmt_input_event`: formatting of `InputEvent` with localization support

## Random data generation
* `rand_dir2`
* `rand_dir3`
* `rand_sign`
* `rand_bool`
* `rand_vec2`
* `rand_float_r`: a given radius (and optionally a center) generates a random `float`
* `randc`: random opaque color
* `randca`: random color with random alpha

## Node utilities
* `delete_children`: delete all children of given `Node`
* `get_node_or_crash`: safer option to `get_node` (which returns current `Node` on empty `NodePath`, thus frequently leading to bugs and strange behaviour)
* `set_node_parent`: like `add_child` with re-parenting support
* `get_nth_parent`

## Drawing

* `draw_cross`, `draw_ellipse`, `draw_arrow`: mainly for use in tool scripts

### debug_draw_2d

Allows drawing of 2D debug shapes which will remain drawn for specific amount of time.

```gdscript
# draw a red dot on global position 300 100 which stays rendered for two seconds
GG.debug_draw_2d.point(Vector2(300, 100), Color.red)
```

Shapes: `point`, `line`, `rect`, `rect_wire`, `string`, `ellipse`, `ellipse_wire`, `arrow`.
See `GGTestsDebugDraw/GGTestsDebugDraw.gd` for more examples.

![](/static/dd2d.png)

## Other
Various utility functions, few examples:
* `take_screenshot`: take a screenshot and save it. convenient defaults - as path is used `<user_data_of_your_project>/screenshots` and name is current date, e.g. `2019-12-19--13-20-35.png`
* `create_timer_and_start`: creates and starts a `Timer` node, connects your timeout handler (method of object). Also supports repeating mode. Useful when `yield(get_tree().create_timer(1), "timeout")` is leading to `Resumed after yield, but class instance is gone` errors.
* `vec2`/`vec3`: construct `Vector2`/`Vector3`, if only one argument is given then use it for all axes
* `load_relative`: load a resource relative to a path (in filesystem) of a given node (typically a script)
* `anim_get_progress`: get progress of current animation in `AnimatedSprite`
* `input_event_to_dict` and `dict_to_input_event`: serialization and deserialization of `InputEvent`s, useful for key binding support

> :ToCPrevNext
