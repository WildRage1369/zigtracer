const std = @import("std");
const zm = @import("zmath");

pub const Color = @Vector(4, f32);

pub fn x(pixel_color: Color) f32 {
    return pixel_color[0];
}

pub fn y(pixel_color: Color) f32 {
    return pixel_color[1];
}

pub fn z(pixel_color: Color) f32 {
    return pixel_color[2];
}

pub fn writeColor(pixel_color: Color, writer: anytype) !void {
    const r = x(pixel_color);
    const g = y(pixel_color);
    const b = z(pixel_color);

    const ir: u32 = @intFromFloat(255.999 * r);
    const ig: u32 = @intFromFloat(255.999 * g);
    const ib: u32 = @intFromFloat(255.999 * b);

    try std.fmt.format(writer, "{d} {d} {d}\n", .{ ir, ig, ib });
}

pub fn splat(value: f32) Color {
    return @splat(value);
}
