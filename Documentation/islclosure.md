# islclosure: (Function: function) -> boolean
Returns whether or not a function is written in Lua.
```lua
print(islclosure(function() end)) --> true
print(islclosure(print)) --> false
```
# Aliases
| Name |
| :- |
| is_l_closure |
# Parameters
| Function: [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The function to check.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [boolean](https://create.roblox.com/docs/luau/booleans)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Whether or not it's a Lua function.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the islclosure test, the function must:
- Return `true` for a Lua function.
- Return `false` for C functions like `print` and `math.abs`.
