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
| Level: [number](https://create.roblox.com/docs/luau/numbers)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The stack level to read.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Index: [number?](https://create.roblox.com/docs/luau/numbers) | The index of a single value. |
# Returns
| any&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The stack values, or the single value.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
