# isexecutorclosure: (Function: function) -> boolean
Returns whether or not a function was made by the executor.
```lua
print(isexecutorclosure(function() end)) --> true
print(isexecutorclosure(print)) --> false
```
# Aliases
| Name |
| :- |
| is_executor_closure |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Function: [function](https://create.roblox.com/docs/luau/functions) | The function to check. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not the executor made it. |
# Test requirements
To pass the isexecutorclosure test, the function must:
- Return `true` for a function made in the executor.
- Return `false` for `print`.
- Return `false` for a function from the game's PlayerModule.
- Return `true` for itself and for a NewCClosure made in the executor.
