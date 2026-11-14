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
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Function: [function](https://create.roblox.com/docs/luau/functions) | The function to check. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not it's a Lua function. |

# Test requirements
To pass the islclosure test, the function must:
- Return `true` for a Lua function.
- Return `false` for C functions like `print` and `math.abs`.
