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
| Function: [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The function to check.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [boolean](https://create.roblox.com/docs/luau/booleans)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Whether or not the executor made it.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
