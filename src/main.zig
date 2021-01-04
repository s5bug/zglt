const std = @import("std");
const glt = @import("zglt.zig");
const glfw = @import("glfw.zig");

pub fn main() anyerror!void {
    try glfw.init();
    defer glfw.terminate() catch unreachable;

    try glfw.windowHint(glfw.WindowHint.ContextVersionMajor, 3);
    try glfw.windowHint(glfw.WindowHint.ContextVersionMinor, 3);
    try glfw.windowHint(glfw.WindowHint.OpenGLProfile, @enumToInt(glfw.GLProfileAttribute.OpenglCoreProfile));

    const window = try glfw.createWindow(800, 600, "zglt", null, null);
    try glfw.makeContextCurrent(window);

    var gl = try glt.Loader(glfw.GLFWError).init(glfw.getProcAddress);
    try glfw.setWindowUserPointer(window, &gl);

    _ = try glfw.setFramebufferSizeCallback(window, framebufferSizeCallback);

    const vertices: [9]f32 = [_]f32 {
        -0.5, -0.5, 0.0,
        0.5, -0.5, 0.0,
        0.0, 0.5, 0.0
    };

    var vbo: u32 = undefined;
    gl.genBuffers(1, @ptrCast([*]u32, &vbo));

    gl.bindBuffer(glt.ArrayBuffer, vbo);

    const vertexBytes: []const u8 = std.mem.sliceAsBytes(&vertices);
    gl.bufferData(glt.ArrayBuffer, @intCast(isize, vertexBytes.len), vertexBytes.ptr, glt.StaticDraw);

    const vertexShaderSources: [*:0]const u8 = @embedFile("vertex.glsl");
    const vertexShader: u32 = gl.createShader(glt.VertexShader);
    gl.shaderSource(vertexShader, 1, @ptrCast([*]const [*:0]const u8, &vertexShaderSources), null);
    gl.compileShader(vertexShader);

    const fragmentShaderSources: [*:0]const u8 = @embedFile("fragment.glsl");
    const fragmentShader: u32 = gl.createShader(glt.FragmentShader);
    gl.shaderSource(fragmentShader, 1, @ptrCast([*]const [*:0]const u8, &fragmentShaderSources), null);
    gl.compileShader(fragmentShader);

    const shaderProgram: u32 = gl.createProgram();
    gl.attachShader(shaderProgram, vertexShader);
    gl.attachShader(shaderProgram, fragmentShader);
    gl.linkProgram(shaderProgram);

    gl.useProgram(shaderProgram);

    while(!try glfw.windowShouldClose(window)) {
        gl.clearColor(0.2, 0.3, 0.3, 1.0);
        gl.clear(glt.ColorBufferBit);

        try glfw.swapBuffers(window);
        try glfw.pollEvents();
    }
}

fn framebufferSizeCallback(window: *glfw.Window, width: i32, height: i32) callconv(.C) void {
    const gl = @ptrCast(*glt.Loader(glfw.GLFWError), @alignCast(8, glfw.getWindowUserPointer(window) catch unreachable));
    std.debug.print("window size changed: {} {}\n", .{width, height});
    gl.viewport(0, 0, 800, 600);
}
