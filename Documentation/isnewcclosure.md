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
| Function: [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The function to check.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [boolean](https://create.roblox.com/docs/luau/booleans)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Whether or not newcclosure made it.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the isnewcclosure test, the function must:
- Return `true` for a function made with [newcclosure](newcclosure.md).
- Return `false` for C functions like `print`, `assert`, and `task.wait`.
- Return `false` for a Lua function.
