const std = @import("std");
const zm = @import("zmath");
const color = @import("color.zig");
const ray = @import("ray.zig");
const print = std.debug.print;
const splat = color.splat;

pub fn main() !void {

    // Image
    const aspect_ratio: f32 = 16.0 / 9.0;
    const image_width: u32 = 400;

    // Calculate the height of the image
    var image_height: u32 = @intFromFloat(@divTrunc(image_width, aspect_ratio));
    image_height = if (image_height < 1) 1 else image_height;

    // Camera
    const focal_length: f32 = 1.0;
    const viewport_height: f32 = 2.0;
    const viewport_width: f32 = viewport_height * (f32Div(image_width, image_height));
    const camera_center: ray.Point = .{ 0, 0, 0, 0 };

    // Calculate the vectors for the viewport edges
    const viewport_u: zm.Vec = .{ viewport_width, 0, 0, 0 };
    const viewport_v: zm.Vec = .{ 0, -viewport_height, 0, 0 };

    // Calculate delta vectors from pixel to pixel
    const delta_u: zm.Vec = viewport_u / splat(@floatFromInt(image_width));
    const delta_v: zm.Vec = viewport_v / splat(@floatFromInt(image_height));

    // Calculate the location of the upper left pixel
    const viewport_upper_left = camera_center - zm.Vec{ 0, 0, focal_length, 0 } - (viewport_u / splat(2)) - (viewport_v / splat(2));
    const pixel100_loc = viewport_upper_left + (splat(0.5) * (delta_u + delta_v));

    const file = try std.fs.cwd().createFile("render.ppm", .{ .read = true });
    defer file.close();
    const writer = file.writer();
    try std.fmt.format(writer, "P3\n{d} {d}\n255\n", .{ image_width, image_height });

    for (0..image_height) |j| {
        if ((image_height - j) % 25 == 0) {
            // std.log.info("Scanlines remaining: {d} ", .{image_height - j});
        }
        for (0..image_width) |i| {
            const pixel_center = pixel100_loc + vecMult(delta_u, @floatFromInt(i)) + vecMult(delta_v, @floatFromInt(j));
            const ray_direction = pixel_center - camera_center;
            const r: ray.Ray = .{ .direction = ray_direction, .origin = camera_center };

            const pixel_color: color.Color = rayColor(r);
            try color.writeColor(pixel_color, writer);
        }
    }
    std.log.info("Done\n", .{});
}

/// Returns the color of a ray
fn rayColor(r: ray.Ray) color.Color {
    const root = hitSphere(zm.Vec{ 0, 0, -1, 0 }, 0.5, r);
    if (root > 0.0) {
        const N = zm.normalize3(r.at(root) - zm.Vec{0, 0, -1, 0});
        return splat(0.5) * color.Color{N[0]+1, N[1]+1, N[2]+1, 0};
    }
    const unit_direction = zm.normalize3(r.direction);
    const a = 0.5 * (color.y(unit_direction) + 1.0);
    return (splat(1.0 - a)) + (splat(1.0)) * (vecMult(color.Color{ 0.5, 0.7, 1.0, 0 }, a));
}

/// Returns true if ray hits sphere
fn hitSphere(center: ray.Point, radius: f32, r: ray.Ray) f32 {
    const oc: zm.Vec = center - r.origin;
    const a = zm.dot3(r.direction, r.direction)[0];
    const b = -2.0 * zm.dot3(r.direction, oc)[0];
    const c = zm.dot3(oc, oc)[0] - splat(radius * radius)[0];
    const discriminant = (b * b) - (4.0 * a * c);

    return if (discriminant < 0.0) -1.0 else ((-b) - zm.sqrt(discriminant)) / (2.0*a);
}

/// Multiplies a @Vector(4, f32) and an int or float
fn vecMult(vec: zm.Vec, num: f32) zm.Vec {
    const scalar_vec: zm.Vec = @splat(num);
    return vec * scalar_vec;
}

/// Divides u32s, f32s, or both and returns an f32
fn f32Div(num1: anytype, num2: anytype) f32 {
    const float1: f32 = if (@TypeOf(num1) == u32) @floatFromInt(num1) else num1;
    const float2: f32 = if (@TypeOf(num2) == u32) @floatFromInt(num2) else num2;
    return float1 / float2;
}
