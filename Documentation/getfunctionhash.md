# getfunctionhash: (Function: function) -> string
Returns a hash of a function. The same function always gives the same hash. The hash should follow the [reference implementation](https://rubis.app/view/?scrap=mwDweOS6zirsPJtc&type=cpp), a SHA384 of the function's code and constants, so every executor gives the same hash.
```lua
local function Greet() end
print(getfunctionhash(Greet) == getfunctionhash(Greet)) --> true
```
# Aliases
| Name |
| :- |
| get_function_hash |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Function: [function](https://create.roblox.com/docs/luau/functions) | The function to hash. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [string](https://create.roblox.com/docs/luau/strings) | The function's hash. |

# Test requirements
To pass the getfunctionhash test, the function must:
- Return a string.
- Return the same hash every time it's called on the same function.
- Return different hashes for two different functions.
- Return the same hash for two functions with the same code.
- Return a SHA384 hash, 96 hex characters, like the [standard](https://rubis.app/view/?scrap=mwDweOS6zirsPJtc&type=cpp).
- Leave upvalues out of the hash, so two functions with the same code but different upvalues get the same hash.
