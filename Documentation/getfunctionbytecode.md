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
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Function: [function](https://create.roblox.com/docs/luau/functions) | The function to read. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [string](https://create.roblox.com/docs/luau/strings) | The function's bytecode. |

# Test requirements
To pass the getfunctionbytecode test, the function must:
- Return a string.
- Return bytecode that isn't empty.
- Return the same bytecode each time it's called on the same function.
- Return different bytecode for two different functions.
- Include the function's own string constants, and not another function's.
