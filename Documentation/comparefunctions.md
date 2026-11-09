# comparefunctions: (First: function, Second: function) -> boolean
Returns whether or not two values are the same function.
```lua
local function Greet() end
print(comparefunctions(Greet, Greet)) --> true
print(comparefunctions(Greet, print)) --> false
```
# Parameters
| First: [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The first function.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Second: [function](https://create.roblox.com/docs/luau/functions) | The second function. |
# Returns
| [boolean](https://create.roblox.com/docs/luau/booleans)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Whether or not they're the same function.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Test requirements
To pass the comparefunctions test, the function must:
- Return true when a function is compared with itself.
- Return false for two different functions.
