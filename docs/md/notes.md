# Notes

## Documentation and other sources

All functions should be [documented](/api/index) (either in main file or wrapper). If you want to see what those functions are doing, you can peek at the test file (brief explanation of *test cases* is at the end of the test file).

## Compatibility

| Godot        | Golden Gadget   |
| ------------ | --------------- |
| 3.1.1, 3.2.1 | ~ 0.3.0         |
| 3.1.1        | ~ 0.2.0         |

It is very likely that the library will be compatible across same main Godot version (e.g. if it's tested with 3.1.1, it most likely will work with 3.2.1 as well).

## Performance

While I tried to optimize most functions, using this library will probably lead to worse performance compared to native solutions (e.g. using `for`s, mutable variables). It is a price for nice abstractions. But looking at the future - when JIT/AOT arrives, differences in performance might not be significant. Generally, I would not recommend building too many wrappers (`arr`, `G`) in `_process` and `_physics_process` especially if you are targeting mobile platforms. (You can use most functions directly from `GG` without an array wrapper.)
