const std = @import("std");

const GLsizei = isize;
const GLsizeiptr = isize;
const GLchar = u8;
const GLint = i32;
const GLuint = u32;
const GLfloat = f32;

const GLenum = i32;
const GLbitfield = u32;

const GLProc = fn () callconv(.C) void;

const GLClear = fn (mask: GLbitfield) callconv(.C) void;
const GLClearColor = fn (red: GLfloat, green: GLfloat, blue: GLfloat, alpha: GLfloat) callconv(.C) void;
const GLViewport = fn (x: GLint, y: GLint, width: GLsizei, height: GLsizei) callconv(.C) void;
const GLBindBuffer = fn (target: GLenum, buffer: GLuint) callconv(.C) void;
const GLGenBuffers = fn (n: GLsizei, buffers: [*]GLuint) callconv(.C) void;
const GLBufferData = fn (target: GLenum, size: GLsizeiptr, data: *const c_void, usage: GLenum) callconv(.C) void;
const GLAttachShader = fn (program: GLuint, shader: GLuint) callconv(.C) void;
const GLCompileShader = fn (shader: GLuint) callconv(.C) void;
const GLCreateProgram = fn () callconv(.C) GLuint;
const GLCreateShader = fn (tpe: GLenum) callconv(.C) GLuint;
const GLLinkProgram = fn (program: GLuint) callconv(.C) void;
const GLShaderSource = fn (shader: GLuint, count: GLsizei, string: [*]const [*:0]const GLchar, length: ?*const GLint) callconv(.C) void;
const GLUseProgram = fn (program: GLuint) callconv(.C) void;

pub fn Loader(comptime errors: type) type {
    return struct {
        loader: fn ([*:0]const u8) errors!GLProc,
        clear: GLClear = undefined,
        clearColor: GLClearColor = undefined,
        viewport: GLViewport = undefined,
        bindBuffer: GLBindBuffer = undefined,
        genBuffers: GLGenBuffers = undefined,
        bufferData: GLBufferData = undefined,
        attachShader: GLAttachShader = undefined,
        compileShader: GLCompileShader = undefined,
        createProgram: GLCreateProgram = undefined,
        createShader: GLCreateShader = undefined,
        linkProgram: GLLinkProgram = undefined,
        shaderSource: GLShaderSource = undefined,
        useProgram: GLUseProgram = undefined,

        const Self = @This();

        pub fn init(loader: fn ([*:0]const u8) errors!GLProc) errors!Self {
            var me: Self = Self {
                .loader = loader,
            };
            try loadVersion10(&me);
            try loadVersion15(&me);
            try loadVersion20(&me);
            return me;
        }

        fn loadVersion10(self: *Self) errors!void {
            self.clear = @ptrCast(GLClear, try self.loader("glClear"));
            self.clearColor = @ptrCast(GLClearColor, try self.loader("glClearColor"));
            self.viewport = @ptrCast(GLViewport, try self.loader("glViewport"));
        }

        fn loadVersion15(self: *Self) errors!void {
            self.bindBuffer = @ptrCast(GLBindBuffer, try self.loader("glBindBuffer"));
            self.genBuffers = @ptrCast(GLGenBuffers, try self.loader("glGenBuffers"));
            self.bufferData = @ptrCast(GLBufferData, try self.loader("glBufferData"));
        }

        fn loadVersion20(self: *Self) errors!void {
            self.attachShader = @ptrCast(GLAttachShader, try self.loader("glAttachShader"));
            self.compileShader = @ptrCast(GLCompileShader, try self.loader("glCompileShader"));
            self.createProgram = @ptrCast(GLCreateProgram, try self.loader("glCreateProgram"));
            self.createShader = @ptrCast(GLCreateShader, try self.loader("glCreateShader"));
            self.linkProgram = @ptrCast(GLLinkProgram, try self.loader("glLinkProgram"));
            self.shaderSource = @ptrCast(GLShaderSource, try self.loader("glShaderSource"));
            self.useProgram = @ptrCast(GLUseProgram, try self.loader("glUseProgram"));
        }
    };
}

pub const ColorBufferBit: GLbitfield = 1 << 14;

pub const ArrayBuffer: GLenum = 0x8892;
pub const StaticDraw: GLenum = 0x88E4;

pub const FragmentShader: GLenum = 0x8B30;
pub const VertexShader: GLenum = 0x8B31;
