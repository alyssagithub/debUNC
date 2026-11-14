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
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Function: [function](https://create.roblox.com/docs/luau/functions) | The outer function. |
| Index: [number](https://create.roblox.com/docs/luau/numbers) | The index of the inner function. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [function](https://create.roblox.com/docs/luau/functions) | The inner function. Some executors give a ProtoProxy instead of a normal function, which can still be called. |
# Test requirements
To pass the debug.getproto test, the function must:
- Return the inner function at the given index as a function.
- Return the right inner function for each index, so index 2 gives the second one.
- Return a function with the inner function's name.
