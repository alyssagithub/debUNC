# debug.setupvalue: (Function: function, Index: number, Value: any) -> ()
Changes an outside variable that a function uses by its index.
```lua
local Value = {}

local function Greet()
	return Value
end

debug.setupvalue(Greet, 1, "Hello")
print(Greet()) --> Hello
```
# Aliases
| Library | Name |
| :- | :- |
| debug | set_upvalue |
| | set_upvalue |
| | setupvalue |
# Parameters
| Function: [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The function to change.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Index: [number](https://create.roblox.com/docs/luau/numbers) | The index of the upvalue. |
| Value: any | The new value. |
