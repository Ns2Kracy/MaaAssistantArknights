pub const AsstExtAPI = struct {};
pub const AsstHandle = *AsstExtAPI;

pub const AsstBool = u8;
pub const AsstSize = u64;

pub const AsstId = i32;
pub const AsstMsgId = AsstId;
pub const AsstTaskId = AsstId;
pub const AsstAsyncCallId = AsstId;

pub const AsstOptionKey = i32;
pub const AsstStaticOptionKey = AsstOptionKey;
pub const AsstInstanceOptionKey = AsstOptionKey;

pub const AsstApiCallback = fn (msg: AsstMsgId, detail_json: *const c_char, custom_arg: *anyopaque) void;

pub extern fn AsstSetUserDir(path: *const c_char) AsstBool;
pub extern fn AsstLoadResource(path: *const c_char) AsstBool;
pub extern fn AsstSetStaticOption(key: AsstStaticOptionKey, value: *const c_char) AsstBool;

pub extern fn AsstCreate() AsstHandle;
pub extern fn AsstCreateEx(callback: AsstApiCallback, custom_arg: *anyopaque) AsstHandle;
pub extern fn AsstDestroy(handle: AsstHandle) void;

pub extern fn AsstSetInstanceOption(handle: AsstHandle, key: AsstInstanceOptionKey, value: *const c_char) AsstBool;

pub extern fn AsstConnect(handle: AsstHandle, adb_path: *const c_char, address: *const c_char, config: *const c_char) AsstBool;

pub extern fn AsstAppendTask(handle: AsstHandle, type: *const c_char, params: *const c_char) AsstTaskId;
pub extern fn AsstSetTaskParams(handle: AsstHandle, id: AsstTaskId, params: *const c_char) AsstBool;

pub extern fn AsstStart(handle: AsstHandle) AsstBool;
pub extern fn AsstStop(handle: AsstHandle) AsstBool;
pub extern fn AsstRunning(handle: AsstHandle) AsstBool;
pub extern fn AsstConnected(handle: AsstHandle) AsstBool;

pub extern fn AsstAsyncConnect(handle: AsstHandle, adb_path: *const c_char, address: *const c_char, config: *const c_char, block: AsstBool) AsstAsyncCallId;
pub extern fn AsstAsyncClick(handle: AsstHandle, x: i32, y: i32, block: AsstBool) AsstAsyncCallId;
pub extern fn AsstAsyncScreencap(handle: AsstHandle, block: AsstBool) AsstAsyncCallId;

pub extern fn AsstGetImage(handle: AsstHandle, buff: *anyopaque, buff_size: AsstSize) AsstSize;
pub extern fn AsstGetUUID(handle: AsstHandle, buff: *c_char, buff_size: AsstSize) AsstSize;
pub extern fn AsstGetTasksList(handle: AsstHandle, buff: *AsstTaskId, buff_size: AsstSize) AsstSize;
pub extern fn AsstGetNullSize() AsstSize;

pub extern fn AsstGetVersion() *const c_char;
pub extern fn AsstLog(level: *const c_char, message: *const c_char) void;
