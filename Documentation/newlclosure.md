# newlclosure: (Function: function) -> function
Wraps a function in a Lua function.
```lua
local Wrapped = newlclosure(math.abs)
print(islclosure(Wrapped)) --> true
print(Wrapped(-5)) --> 5
```
# Aliases
| Name |
| :- |
| new_l_closure |
# Parameters
| Function: [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The function to wrap.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The wrapped function.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the newlclosure test, the function must:
- Return a new function, not the one it was given.
- Return a Lua closure, so [islclosure](islclosure.md) returns `true` for it, even when given a C function.
- Return the wrapped function's result, so a wrapped `math.abs(-5)` returns `5`.
