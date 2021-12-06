const std = @import("std");

fn simulateSpawns(dayCount : usize, lanternfish : []usize) usize {
    var i : usize = 0;
    while (i < dayCount) : (i += 1) {
        var spawnCount = lanternfish[i % 9];
        lanternfish[(i + 7) % 9] += spawnCount;
    }
    var total : usize = 0;
    for (lanternfish) |n| {
        total += n;
    }
    return total;
}

pub fn main() anyerror!void {
    var dir = std.fs.cwd();
    var file = try dir.openFile("in/day_06.txt", .{ });
    var reader = file.reader();
    defer file.close();
    var buff : [2048]u8 = undefined;
    var length = try file.readAll(&buff);
    var splits = std.mem.tokenize(buff[0..length], ",\n");
    var initialState = [9]usize { 0, 0, 0, 0, 0, 0, 0, 0, 0 };
    while (splits.next()) |elem| {
        var n = try std.fmt.parseInt(usize, elem, 10);
        initialState[n] += 1;
    }
    var fish80 = initialState; // zig wont let me copy an array passed to a function, so here's some jank, as a treat
    var fish256 = initialState;
    var spawn80 = simulateSpawns(80, &fish80);
    var spawn256 = simulateSpawns(256, &fish256);
    std.debug.print("total spawns after 80 days\n{}\n\n", .{ spawn80 });
    std.debug.print("total spawns after 256 days\n{}\n", .{ spawn256 });
}
