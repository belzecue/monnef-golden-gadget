[![pipeline status](https://gitlab.com/monnef/golden-gadget/badges/master/pipeline.svg)](https://gitlab.com/monnef/golden-gadget/-/commits/master)


🧰 Golden Gadget 🌟
===================

GDScript utility library focused on functional programming (FP)

Status: ⚗️ **beta** (main functionality is implemented, API changes should be minimal)

🤖️️ All pure functions are covered by [tests](goldenGadget/GGTests.gd).

📑 Documentation
---------------
Please see the **[website](https://monnef.gitlab.io/golden-gadget)**.

Old docs are available there: [docs/md/api/index.md](docs/md/api/index.md)

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

- - -

<div align="center">
	<sub>
		👨🏻 • 🐧 • 🍍 • 🇨🇿
	</sub>
</div>
