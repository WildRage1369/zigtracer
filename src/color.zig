const std = @import("std");
const zm = @import("zmath");

pub const color = @Vector(3, f32);

pub fn x(pixel_color: color) f32 {
    return pixel_color[0];
}

pub fn y(pixel_color: color) f32 {
    return pixel_color[1];
}

pub fn z(pixel_color: color) f32 {
    return pixel_color[2];
}

pub fn writeColor(pixel_color: color, writer: anytype) !void {
    const r = x(pixel_color);
    const g = y(pixel_color);
    const b = z(pixel_color);

    const ir: u32 = @intFromFloat(255.999 * r);
    const ig: u32 = @intFromFloat(255.999 * g);
    const ib: u32 = @intFromFloat(255.999 * b);

    try std.fmt.format(writer, "{d} {d} {d}\n", .{ ir, ig, ib });
}
