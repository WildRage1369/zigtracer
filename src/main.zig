const std = @import("std");
const zm = @import("zmath");
const color = @import("color.zig");

pub fn main() !void {
    const image_width = 256;
    const image_height = 256;

    const file = try std.fs.cwd().createFile("render.ppm", .{ .read = true });
    defer file.close();
    const writer = file.writer();
    try std.fmt.format(writer, "P3\n{d} {d}\n255\n", .{ image_width, image_height });

    for (0..image_width) |w| {
        std.log.info("Scanlines remaining: {d} ", .{image_height - w});
        for (0..image_height) |h| {
            const r: f32 = @as(f32, @floatFromInt(h)) / (image_width - 1);
            const g: f32 = @as(f32, @floatFromInt(w)) / (image_height - 1);

            const pixel_color: color.color = .{ r, g, 0.0 };
            try color.writeColor(pixel_color, writer);
        }
    }
    std.log.info("Done\n", .{});
}
