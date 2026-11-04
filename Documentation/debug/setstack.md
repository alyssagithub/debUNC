# debug.setstack: (Level: number, Index: number, Value: any) -> ()
Changes a value of a running function, like a local variable. The new value has to be the same type as the old one.
```lua
local function Greet()
	local Number = math.random() + 1
	local Index = table.find(debug.getstack(1), Number)
	debug.setstack(1, Index, 5)
	print(Number) --> 5
end

Greet()
```
# Aliases
| Library | Name |
| :- | :- |
| debug | set_stack |
| | set_stack |
| | setstack |
# Parameters
| Level: [number](https://create.roblox.com/docs/luau/numbers)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The stack level to change.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Index: [number](https://create.roblox.com/docs/luau/numbers) | The index of the value. |
| Value: any | The new value. |
