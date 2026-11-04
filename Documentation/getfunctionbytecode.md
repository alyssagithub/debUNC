# getfunctionbytecode: (Function: function) -> string
Returns the bytecode of a function, which is its compiled code.
```lua
local function Greet() end
print(#getfunctionbytecode(Greet))
```
# Aliases
| Library | Name |
| :- | :- |
| | get_function_bytecode |
# Parameters
| Function: [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The function to read.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The function's bytecode.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
