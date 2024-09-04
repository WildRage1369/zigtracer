const zm = @import("zmath");
pub const Point = @Vector(4, f32);

pub const Ray = struct {
    direction: @Vector(4, f32),
    origin: @Vector(4, f32),

    pub fn at(self: Ray, t: f32) Point {
        return self.origin + (self.direction * zm.splat(Point, t));
    }
};
