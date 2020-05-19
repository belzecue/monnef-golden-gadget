🧰 Golden Gadget 🌟
===================

GDScript utility library focused on functional programming (FP)

Status: ⚗️ **beta** (main functionality is implemented, API changes should be minimal)

🤖️️ All pure functions are covered by [tests](goldenGadget/GGTests.gd).

[📑 Documentation](docs/index.md)
---------------------------------

🪀 Examples
-----------

```gdscript
func _test_short_example() -> void:
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
	var weak_alive_monsters = G(monsters).filter("x => x.is_alive && x.hp < 10").map("x => x.name").val

	assert(weak_alive_monsters_imperative == ["Demon"])
	assert(weak_alive_monsters == ["Demon"])
```

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

👉 More info (including installation) at [main library file](goldenGadget/GoldenGadget.gd) and [array wrapper file](goldenGadget/GGArray.gd).

🎁 Notable features
-------------------
* all functions are handling Arrays and other types as immutable (unless explicitly specified)
* lambdas (anonymous functions, see first example)
* most functions/methods should support following types when expecting a function (referred to as function-like):
  * `FuncRef` - obtained by calling `funcref`
  * `String` - compiled to an anonymous function
  * partially applied functions written as
    * `Array` - a tuple where first item is function-like, second item is value to apply (from right)
    * `with_ctx`/`with_ctx2` - older form, mimics `FuncRef`
* `pipe` function which allows easy chaining of functions, also supports partial application for 2-argument functions (see second example)
* object/dictionary utilities, for example:
   * `key_from_val`: finding a key from value
   * `keys`: unified way of getting array of keys for Dictionary and custom classes
   * `ap_if_defined`: call method when method exists and pass result, otherwise null
* array utilities known from other dynamic and/or functional languages. Golden Gagdet also contains an array wrapper with fluent API (see first example) to streamline working with arrays. some examples:
  * FP classics: `map`, `filter`, `foldl` (aka `reduce`)
  * chopping: `head`, `tail`, `last`, `init`, `take`, `take_right`, `drop`, `drop_right`
  * gluing: `append`, `prepend`, `concat`, `concat_left`
  * `sort`, `zip`, `reverse` (aka `inverse`)
  * `flatten`: flattens one level of array of arrays, e.g. `[[1, 2], [3]]` -> `[1, 2, 3]`
  * `without`: remove all occurrences of given value from an array
  * `sample`/`sample_or_null`: get random item from an array
  * `sum`/`product`
  * `all`/`any`: does predicate (given function returns `true`) for all/any items of an array?
* string helpers like `words`, `unwords`, `lines`, `unlines`, `join`
* function utilities:
  * `call_spread`: invokes a function with given arguments in a form of an array - it "spreads" the arguments (not easily doable in Godot 3.1)
* various utility functions, few examples:
  * `take_screenshot`: take a screenshot and save it. convenient defaults - as path is used `<user_data_of_your_project>/screenshots` and name is current date, e.g. `2019-12-19--13-20-35.png`
  * `delete_children`: delete all children of given `Node`
  * `get_node_or_crash`: safer option to `get_node` which returns current `Node` on empty `NodePath` (thus frequently leading to bugs and strange behaviour)
  * `create_timer_and_start`: creates and starts a `Timer` node, connects your timeout handler (method of object). Also supports repeating mode. Useful when `yield(get_tree().create_timer(1), "timeout")` is leading to `Resumed after yield, but class instance is gone` errors.

📜 Notes
--------
All functions should be [documented](docs/index.md) (either in [main file](goldenGadget/GoldenGadget.gd) or [wrapper](goldenGadget/GGArray.gd)). If you want to see what those functions are doing, you can peek at the test file (brief explanation of *test cases* is at the end of the test file).

While I tried to optimize most functions, using this library will probably lead to worse performance compared to native solutions (e.g. using `for`s, mutable variables). It is a price for nice abstractions. But looking at the future - when JIT arrives, differences in performance might not be significant. Generally, I would not recommend building too many wrappers (`arr`, `G`) in `_process` and `_physics_process` especially if you are targeting mobile platforms. (You can use most functions directly from `GG` without an array wrapper.)

 Development
-------------
Open project in Godot and hack away. Run the project to start tests (results will be in output tab).

If you want to run tests from a command line, navigate to the project directory and run:
```sh
$ godot
Godot Engine v3.2.1.stable.official - https://godotengine.org
OpenGL ES 3.0 Renderer: GeForce RTX 2080 Ti/PCIe/SSE2

[GG] Golden Gadget Tests: SUCCESS in 0.026s (279 - 305)
```
or directly reference the test runner scene:
```sh
$ godot goldenGadget/GGTestsRunner.tscn
Godot Engine v3.2.1.stable.official - https://godotengine.org
OpenGL ES 3.0 Renderer: GeForce RTX 2080 Ti/PCIe/SSE2

[GG] Golden Gadget Tests: SUCCESS in 0.026s (279 - 305)
```
assuming you have a `godot` binary in your path. If you don't want any graphical output (window being opened), you can use a headless version of Godot.

 Compatibility
---------------

| Godot        | Golden Gadget |
| ------------ | ------------- |
| 3.1.1, 3.2.1 | 0.3.0         |
| 3.1.1        | 0.2.0         |

It is very likely that the library will be compatible across same main Godot version (e.g. if it's tested with 3.1.1, it most likely will work with 3.2.1 as well).

⚖️ License
---------
Source code is under MIT license.

- - -

<div align="center">
	<sub>
		👨🏻 • 🐧 • 🍍 • 🇨🇿
	</sub>
</div>
