# debug.getupvalues: (Function: function) -> {any}
Returns the upvalues of a function, which are the outside variables it uses.
```lua
local Value = {}

local function Greet()
	return Value
end

print(debug.getupvalues(Greet)[1] == Value) --> true
```
# Aliases
| Library | Name |
| :- | :- |
| debug | get_upvalues |
| | get_upvalues |
| | getupvalues |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Function: [function](https://create.roblox.com/docs/luau/functions) | The function to read. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| {any} | An array of the function's upvalues. |

# Test requirements
To pass the debug.getupvalues test, the function must:
- Return a table that holds every upvalue the function uses, including ones it only reaches after an error.
