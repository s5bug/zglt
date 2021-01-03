const std = @import("std");

const GLsizei = isize;
const GLint = i32;
const GLuint = u32;
const GLfloat = f32;

const GLbitfield = u32;

const GLProc = fn () callconv(.C) void;

const GLClear = fn (mask: GLbitfield) callconv(.C) void;
const GLClearColor = fn (red: GLfloat, green: GLfloat, blue: GLfloat, alpha: GLfloat) callconv(.C) void;
const GLViewport = fn (x: GLint, y: GLint, width: GLsizei, height: GLsizei) callconv(.C) void;
const GLGenBuffers = fn (n: GLsizei, buffers: [*]GLuint) callconv(.C) void;

var glClear: GLClear = undefined;
var glClearColor: GLClearColor = undefined;
var glViewport: GLViewport = undefined;
var glGenBuffers: GLGenBuffers = undefined;

pub fn Loader(comptime errors: type) type {
    return struct {
        loader: fn ([*:0]const u8) errors!GLProc,

        const Self = @This();

        pub fn init(loader: fn ([*:0]const u8) errors!GLProc) errors!void {
            var me: Self = Self {
                .loader = loader,
            };
            try loadVersion10(&me);
            try loadVersion15(&me);
        }

        fn loadVersion10(self: *Self) errors!void {
            glClear = @ptrCast(GLClear, try self.loader("glClear"));
            glClearColor = @ptrCast(GLClearColor, try self.loader("glClearColor"));
            glViewport = @ptrCast(GLViewport, try self.loader("glViewport"));
        }

        fn loadVersion15(self: *Self) errors!void {
            glGenBuffers = @ptrCast(GLGenBuffers, try self.loader("glGenBuffers"));
        }
    };
}

pub const ColorBufferBit: u32 = 1 << 14;

pub fn clear(mask: u32) void {
    glClear(mask);
}

pub fn clearColor(red: f32, green: f32, blue: f32, alpha: f32) void {
    glClearColor(red, green, blue, alpha);
}

pub fn viewport(x: i32, y: i32, width: isize, height: isize) void {
    glViewport(x, y, width, height);
}

pub fn genBuffers(buffers: []GLuint) void {
    glGenBuffers(buffers.len, buffers.ptr);
}
