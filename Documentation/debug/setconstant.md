# debug.setconstant: (Function: function, Index: number, Value: any) -> ()
Changes a fixed value in a function's code, like a string or number, by its index.
```lua
local function Greet()
	return "Hello"
end

debug.setconstant(Greet, 1, "Goodbye")
print(Greet()) --> Goodbye
```
# Aliases
| Library | Name |
| :- | :- |
| debug | set_constant |
| | set_constant |
| | setconstant |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Function: [function](https://create.roblox.com/docs/luau/functions) | The function to change. |
| Index: [number](https://create.roblox.com/docs/luau/numbers) | The index of the constant. |
| Value: any | The new value. |

# Test requirements
To pass the debug.setconstant test, the function must:
- Change the constant in the function it's given, so the function returns the new value.
- Leave other functions that use the same constant unchanged.
