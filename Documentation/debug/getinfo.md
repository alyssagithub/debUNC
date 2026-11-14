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
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Function: [function](https://create.roblox.com/docs/luau/functions) | The function to read. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| <pre>{<br>&nbsp;&nbsp;&nbsp;&nbsp;func: function,<br>&nbsp;&nbsp;&nbsp;&nbsp;name: string,<br>&nbsp;&nbsp;&nbsp;&nbsp;what: string,<br>&nbsp;&nbsp;&nbsp;&nbsp;numparams: number,<br>&nbsp;&nbsp;&nbsp;&nbsp;is_vararg: number,<br>&nbsp;&nbsp;&nbsp;&nbsp;nups: number,<br>}</pre> | The function's information. Each key is explained below. |
# Info
| Field&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| func: [function](https://create.roblox.com/docs/luau/functions) | The function itself. |
| name: [string](https://create.roblox.com/docs/luau/strings) | The function's name. |
| what: [string](https://create.roblox.com/docs/luau/strings) | Lua for a Lua function and C for a C function. |
| numparams: [number](https://create.roblox.com/docs/luau/numbers) | How many parameters it has. |
| is_vararg: [number](https://create.roblox.com/docs/luau/numbers) | 1 if it takes ... and 0 if it doesn't. |
| nups: [number](https://create.roblox.com/docs/luau/numbers) | How many upvalues it has. |
# Test requirements
To pass the debug.getinfo test, the function must:
- Set `what` to "Lua" and `name` to the function's name for a Lua function.
- Set `what` to "C" and `name` to "wait" for `task.wait`.
- Set `func` to the function that was passed in.
- Set `numparams` to the number of named parameters and `is_vararg` to 1 for a variadic function.
