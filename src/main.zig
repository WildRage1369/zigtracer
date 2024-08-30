const std = @import("std");
const zm = @import("zmath");

pub fn main() !void {
    const image_width = 256;
    const image_height = 256;

    const file = try std.fs.cwd().createFile("render.ppm", .{ .read = true });
    defer file.close();

    var write_buffer: [1024]u8 = undefined;
    _ = try file.write(try std.fmt.bufPrint(&write_buffer, "P3\n{d} {d}\n255\n", .{ image_width, image_height }));

    for (0..image_width) |w| {
        std.log.info("Scanlines remaining: {d} ", .{image_height - w});
        for (0..image_height) |h| {
            const r: f32 = @as(f32, @floatFromInt(h)) / (image_width - 1);
            const g: f32 = @as(f32, @floatFromInt(w)) / (image_height - 1);
            const b: f32 = 0.0;

            const ir: u32 = @intFromFloat(255.999 * r);
            const ig: u32 = @intFromFloat(255.999 * g);
            const ib: u32 = @intFromFloat(255.999 * b);

            _ = try file.write(try std.fmt.bufPrint(&write_buffer, "{d} {d} {d}\n", .{ ir, ig, ib }));
        }
    }
    std.log.info("Done\n", .{});
}
