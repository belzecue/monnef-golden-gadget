🌱 Change log
=============

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
