const std = @import("std");
const gl = @import("gl.zig");
const glfw = @import("glfw.zig");

pub fn main() anyerror!void {
    try glfw.init();
    defer glfw.terminate() catch unreachable;

    try glfw.windowHint(glfw.WindowHint.ContextVersionMajor, 3);
    try glfw.windowHint(glfw.WindowHint.ContextVersionMinor, 3);
    try glfw.windowHint(glfw.WindowHint.OpenGLProfile, @enumToInt(glfw.GLProfileAttribute.OpenglCoreProfile));

    const window = try glfw.createWindow(800, 600, "zglt", null, null);
    try glfw.makeContextCurrent(window);

    try gl.Loader(glfw.GLFWError).init(glfw.getProcAddress);

    _ = try glfw.setFramebufferSizeCallback(window, framebufferSizeCallback);

    while(!try glfw.windowShouldClose(window)) {
        gl.clearColor(0.2, 0.3, 0.3, 1.0);
        gl.clear(gl.ColorBufferBit);

        try glfw.swapBuffers(window);
        try glfw.pollEvents();
    }
}

fn framebufferSizeCallback(window: *glfw.Window, width: i32, height: i32) callconv(.C) void {
    std.debug.print("hi {} {}\n", .{width, height});
    gl.viewport(0, 0, 800, 600);
}
