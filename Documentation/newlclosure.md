# newlclosure: (Function: function) -> function
Wraps a function in a Lua function.
```lua
local Wrapped = newlclosure(math.abs)
print(islclosure(Wrapped)) --> true
print(Wrapped(-5)) --> 5
```
# Aliases
| Library | Name |
| :- | :- |
| | new_l_closure |
# Parameters
| Function: [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The function to wrap.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The wrapped function.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
