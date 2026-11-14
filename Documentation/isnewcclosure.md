# isnewcclosure: (Function: function) -> boolean
Returns whether or not a function was made with [newcclosure](newcclosure.md).
```lua
print(isnewcclosure(newcclosure(function() end))) --> true
print(isnewcclosure(print)) --> false
```
# Aliases
| Name |
| :- |
| is_new_cclosure |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Function: [function](https://create.roblox.com/docs/luau/functions) | The function to check. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not newcclosure made it. |

# Test requirements
To pass the isnewcclosure test, the function must:
- Return `true` for a function made with [newcclosure](newcclosure.md).
- Return `false` for C functions like `print`, `assert`, and `task.wait`.
- Return `false` for a Lua function.
