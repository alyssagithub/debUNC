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
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Function: [function](https://create.roblox.com/docs/luau/functions) | The function to change. |
| Index: [number](https://create.roblox.com/docs/luau/numbers) | The index of the upvalue. |
| Value: any | The new value. |

# Test requirements
To pass the debug.setupvalue test, the function must:
- Change the upvalue at the given index, so the function returns the new value.
- Change the shared upvalue, so other functions that use the same upvalue see the new value too.
