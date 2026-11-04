# debug.getinfo: (Function: function) -> {func: function, name: string, what: string, numparams: number, is_vararg: number, nups: number}
Returns information about a function.
```lua
local function Greet() end
local Info = debug.getinfo(Greet)
print(Info.name) --> Greet
print(Info.what) --> Lua
```
# Aliases
| Library | Name |
| :- | :- |
| debug | get_info |
| | get_info |
| | getinfo |
# Parameters
| Function: [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The function to read.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| <pre>{<br>&nbsp;&nbsp;&nbsp;&nbsp;func: function,<br>&nbsp;&nbsp;&nbsp;&nbsp;name: string,<br>&nbsp;&nbsp;&nbsp;&nbsp;what: string,<br>&nbsp;&nbsp;&nbsp;&nbsp;numparams: number,<br>&nbsp;&nbsp;&nbsp;&nbsp;is_vararg: number,<br>&nbsp;&nbsp;&nbsp;&nbsp;nups: number,<br>}</pre>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The function's information. Each key is explained below.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Info
| func: [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The function itself.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| name: [string](https://create.roblox.com/docs/luau/strings) | The function's name. |
| what: [string](https://create.roblox.com/docs/luau/strings) | Lua for a Lua function and C for a C function. |
| numparams: [number](https://create.roblox.com/docs/luau/numbers) | How many parameters it has. |
| is_vararg: [number](https://create.roblox.com/docs/luau/numbers) | 1 if it takes ... and 0 if it doesn't. |
| nups: [number](https://create.roblox.com/docs/luau/numbers) | How many upvalues it has. |
