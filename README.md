# zglt

Proof-of-concept GL loader for zglfw for Zig.

Probably only builds on Windows out-of-the-box but if you add `glfw3.a` to
`lib` and modify the `linkSystemLibrary`s in `build.zig` to remove
Windows-specific things it should work elsewhere.
