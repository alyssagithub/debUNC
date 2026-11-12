# getfunctionbytecode: (Function: function) -> string
Returns the bytecode of a function, which is its compiled code.
```lua
local function Greet() end
print(#getfunctionbytecode(Greet))
```
# Aliases
| Name |
| :- |
| get_function_bytecode |
# Parameters
| Function: [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The function to read.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The function's bytecode.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the getfunctionbytecode test, the function must:
- Return a string.
- Return bytecode that isn't empty.
- Return the same bytecode each time it's called on the same function.
- Return different bytecode for two different functions.
- Include the function's own string constants, and not another function's.
