# debug.getconstants: (Function: function) -> {[number]: any}
Returns the fixed values in a function's code, like strings and numbers. Some indexes can be empty, so loop through it instead of using table.find.
```lua
local function Greet()
	print("Hello world!")
end

for Index, Constant in debug.getconstants(Greet) do
	print(Index, Constant)
end
```
# Aliases
| Library | Name |
| :- | :- |
| debug | get_constants |
| | get_constants |
| | getconstants |
# Parameters
| Function: [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The function to read.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| {[number]: any}&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The function's constants by index. Some indexes can be empty.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
