🌱 Change log
=============

🔸 0.3.0 🔸
===========

* Changed `head` and `last` to crash on empty arrays.
* Implemented `find`, `find_or_null`, `head_or_null` and `last_or_null`.
* Added `rand_dir2`, `rand_dir3`, `rand_sign`, `rand_bool`, `dir_to2`, `dir_to3` and `clampi`.
* Fixed `new_array` to clone (duplicate) given value.
* Implemented `is_empty` in GG (main file).
* Implemented `group_with`, `transpose`, `nub` and `unique`.
* Renamed `flatten` to `flatten_raw` and `flatten_unwrapped` to `flatten` in GGA.
* Implemented `wrap` and `unwrap` in GGA.
* Updated docs for newer version of Gododoc.
* Implemented `take_while`.
* Implemented `snake_to_camel_case` and `decapitalize_first`.
* Implemented `capitalize_all`, `camel_to_snake_case`.
* Implemented `floats_are_equal`, `format_float_2`, `format_vec2_2` and `format_vec3_2`.
* Implemented `float_arr_to_int_arr`, `find_index_or_null` and `find_index`.
* Tests now exit with an error code on failure.
* Added error code parameter to `quit` function.

🔸 0.2.0 🔸
===========

* Added [real documentation](docs/index.md) in markdown.
  * Documented all functions (but not all types yet).
  * Added many examples.

<br/>

* Implemented `replicate`, `create_array` and `flow`.
* Fixed crash of debug prints in `pipe` when encountered `Array` as `pipe` input.
* Implemented `join_w` (GGA), exposed `join` (GG).
* Implemented `for_each` and non-returning lambdas.
* Implemented `get_fields` and `set_fields`.
* Renamed `f_bool` to `fmt_bool`.
* Implemented `bool` and `lazy_bool`.
* Fixed `is_empty` in GGA, added more tests.
* Implemented `get_children_rec`.
* `crash` and `assert` are now using `quit` instead of `assert`, terminating game when run without editor.
* Implemented `quit`.
* Implemented `pause_one` and `pause`.
* Implemented `get_node_or_null`.
* Implemented `generate_array` (variant of `new_array` with cell getter function).
* Renamed `create_array` to `new_array`.
* Implemented `const`.
