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
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Function: [function](https://create.roblox.com/docs/luau/functions) | The function to check. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not it's hooked. |
# Test requirements
To pass the isfunctionhooked test, the function must:
- Return `false` for a function that isn't hooked.
- Return `true` for a function hooked with [hookfunction](hookfunction.md).
- Keep returning `false` for a different function that was never hooked.
- Return `false` after the function is restored with [restorefunction](restorefunction.md).
