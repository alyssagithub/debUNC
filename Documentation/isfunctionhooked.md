# isfunctionhooked: (Function: function) -> boolean
Returns whether or not a function has been hooked.
```lua
local function Greet() end
print(isfunctionhooked(Greet)) --> false
hookfunction(Greet, function() end)
print(isfunctionhooked(Greet)) --> true
```
# Aliases
| Name |
| :- |
| is_function_hooked |
# Parameters
| Function: [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The function to check.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [boolean](https://create.roblox.com/docs/luau/booleans)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Whether or not it's hooked.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
