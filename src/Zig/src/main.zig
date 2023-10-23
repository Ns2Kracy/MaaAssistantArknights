const std = @import("std");
const builtin = @import("builtin");
const maa = @import("maa.zig");

pub const ASST_DEBUG = true;

pub fn main() !void {
    const maa_core = switch (builtin.os.tag) {
        .windows => "MaaCore.dll",
        else => "MaaCore.dll",
    };

    _ = try std.DynLib.open(maa_core);

    var cur_path = std.fs.cwd();

    if (!maa.AsstLoadResource(cur_path)) {
        // print error
        std.debug.print("-------- load resource failed --------", .{});
        return -1;
    }

    if (ASST_DEBUG) {
        var load_error = false;
        var overseas_dir = cur_path / "resource" / "global";
        const client = [_]u8{ "YoStarJP", "YoStarEN", "YoStarKR", "txwy" };

        for (client) |c| {
            const client_dir = overseas_dir / c;
            var loaded = maa.AsstLoadResource(client_dir);
            loaded &= maa.AsstLoadResource(client_dir);

            if (!loaded) {
                load_error = true;
                std.debug.print("-------- load resource failed --------", .{});
            }
        }

        if (load_error) {
            return -1;
        }
    }

    const ptr = maa.AsstCreate();
    if (ptr == null) {
        std.debug.print("create failed", .{});
        return -1;
    }

    if (ASST_DEBUG) {
        maa.AsstAsyncConnect(ptr, "adb", "127.0.0.1:5555", "DEBUG", true);
    } else {
        maa.AsstAsyncConnect(ptr, "adb", "127.0.0.1:5555", "", true);
    }

    if (!maa.AsstConnected(ptr)) {
        std.debug.print("connect failed", .{});
        maa.AsstDestroy(ptr);
        return -1;
    }

    if (ASST_DEBUG) {
        maa.AsstAppendTask(ptr, "StartUp", null);

        maa.AsstAppendTask(ptr, "Fight",
            \\{
            \\    "stage": "1-7"
            \\}
        );

        maa.AsstAppendTask(ptr, "Recruit",
            \\{
            \\    "select":[4],
            \\    "confirm":[3,4],
            \\    "times":4
            \\}
        );

        maa.AsstAppendTask(ptr, "Infrast",
            \\{
            \\    "facility": ["Mfg", "Trade", "Power", "Control", "Reception", "Office", "Dorm"],
            \\    "drones": "Money"
            \\}
        );
        maa.AsstAppendTask(ptr, "Mall",
            \\{
            \\    "shopping": true,
            \\    "buy_first": [
            \\       "许可"
            \\    ],
            \\    "black_list": [
            \\        "家具",
            \\        "碳"
            \\    ]
            \\}
        );

        maa.AsstAppendTask(ptr, "Award", "");

        maa.AsstAppendTask(ptr, "Roguelike",
            \\{
            \\    "squad": "突击战术分队",
            \\    "roles": "先手必胜",
            \\    "core_char": "棘刺"
            \\}
        );
    } else {
        maa.AsstAppendTask(ptr, "Debug", "");
    }

    maa.AsstStart(ptr);

    while (maa.AsstRunning(ptr)) {
        std.Thread.yield();
    }

    maa.AsstStop(ptr);
    maa.AsstDestroy(ptr);

    return 0;
}
