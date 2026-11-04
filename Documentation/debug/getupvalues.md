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
| Function: [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The function to read.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| {any}&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | An array of the function's upvalues.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
