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
| Function: [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The function to check.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [boolean](https://create.roblox.com/docs/luau/booleans)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Whether or not it's a C function.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
