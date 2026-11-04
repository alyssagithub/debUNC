# getfunctionhash: (Function: function) -> string
Returns a hash of a function. The same function always gives the same hash.
```lua
local function Greet() end
print(getfunctionhash(Greet) == getfunctionhash(Greet)) --> true
```
# Aliases
| Library | Name |
| :- | :- |
| | get_function_hash |
# Parameters
| Function: [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The function to hash.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The function's hash.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
