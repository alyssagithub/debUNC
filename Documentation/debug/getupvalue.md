# debug.getupvalue: (Function: function, Index: number) -> any
Returns an upvalue of a function by its index. Upvalues are outside variables that the function uses.
```lua
local Value = {}

local function Greet()
	return Value
end

print(debug.getupvalue(Greet, 1) == Value) --> true
```
# Aliases
| Library | Name |
| :- | :- |
| debug | get_upvalue |
| | get_upvalue |
| | getupvalue |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Function: [function](https://create.roblox.com/docs/luau/functions) | The function to read. |
| Index: [number](https://create.roblox.com/docs/luau/numbers) | The index of the upvalue. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| any | The upvalue. |
# Test requirements
To pass the debug.getupvalue test, the function must:
- Return the upvalue at the given index, in the order the function uses them.
