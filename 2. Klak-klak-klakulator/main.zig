const std = @import("std");
const arithmetic = @import("arithmetic.zig");

const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    try stdout.print("Input arithmetic expression: ", .{});
}

fn ask_user() !i64 {

    var buf: [10]u8 = undefined;
    
    try stdout.print("Input arithmetic expression: ", .{});

    if (try stdin.readUntilDelimiterOrEof(buf[0..], '\n')) |user_input| {
        return std.fmt.parseInt(i64, user_input, 10);
    } else {
        return @as(i64, 0);
    }
}

fn parse_input([]u8, size)