# iscclosure: (Function: function) -> boolean
Returns whether or not a function is written in C.
```lua
print(iscclosure(print)) --> true
print(iscclosure(function() end)) --> false
```
# Aliases
| Name |
| :- |
| is_c_closure |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Function: [function](https://create.roblox.com/docs/luau/functions) | The function to check. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not it's a C function. |
# Test requirements
To pass the iscclosure test, the function must:
- Return `true` for C closures such as `assert`, `print`, and `task.wait`.
- Return `true` for a function wrapped with [newcclosure](newcclosure.md).
- Return `false` for a function made in the executor.
