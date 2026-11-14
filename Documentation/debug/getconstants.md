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
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Function: [function](https://create.roblox.com/docs/luau/functions) | The function to read. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| {[number]: any} | The function's constants by index. Some indexes can be empty. |
# Test requirements
To pass the debug.getconstants test, the function must:
- Return a table.
- Include the function's string constants.
