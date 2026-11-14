# debug.getstack: (Level: number, Index: number?) -> any
Returns the values of a running function, like its local variables, or a single value if an index is given. Level 1 is the current function.
```lua
local function Greet()
	local Number = math.random() + 1
	print(table.find(debug.getstack(1), Number))
end

Greet()
```
# Aliases
| Library | Name |
| :- | :- |
| debug | get_stack |
| | get_stack |
| | getstack |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Level: [number](https://create.roblox.com/docs/luau/numbers) | The stack level to read. |
| Index: [number?](https://create.roblox.com/docs/luau/numbers) | The index of a single value. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| any | The stack values, or the single value. |
# Test requirements
To pass the debug.getstack test, the function must:
- Include the locals of the function at the given level.
