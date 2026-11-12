# getfunctionhash: (Function: function) -> string
Returns a hash of a function. The same function always gives the same hash.
```lua
local function Greet() end
print(getfunctionhash(Greet) == getfunctionhash(Greet)) --> true
```
# Aliases
| Name |
| :- |
| get_function_hash |
# Parameters
| Function: [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The function to hash.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The function's hash.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the getfunctionhash test, the function must:
- Return a string.
- Return the same hash every time it's called on the same function.
- Return different hashes for two different functions.
- Return the same hash for two functions with the same code.
- Return a SHA384 hash, 96 hex characters, like the standard.
- Leave upvalues out of the hash, so two functions with the same code but different upvalues get the same hash.
