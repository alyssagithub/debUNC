# debug.getproto: (Function: function, Index: number) -> function
Returns a function defined inside of another function by its index.
```lua
local function Outer()
	local function Inner() end
end

print(debug.getproto(Outer, 1))
```
# Aliases
| Library | Name |
| :- | :- |
| debug | get_proto |
| | get_proto |
| | getproto |
# Parameters
| Function: [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The outer function.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Index: [number](https://create.roblox.com/docs/luau/numbers) | The index of the inner function. |
# Returns
| [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The inner function. Some executors give a ProtoProxy instead of a normal function, which can still be called.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
